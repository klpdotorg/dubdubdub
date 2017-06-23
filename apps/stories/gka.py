from django.db.models import Q
from django.db.models import Count
from django.contrib.auth.models import Group

from schools.api_views.ekstep_gka import EkStepGKA

from schools.models import (
    AssessmentsV2,
    Boundary,
    BoundaryHierarchy
)
from .models import Story, Survey, Answer, Question

GKA_DISTRICTS = [445, 416, 424, 417, 419, 418]


class GKA(object):

    neighbourIds = {
        413: [414,  415,  420, 421, 422],
        414: [413, 415, 418, 419, 420],
        415: [413, 414, 416, 418, 445],
        416: [415, 417, 445],
        417: [416],
        418: [414, 415, 419, 424, 445],
        419: [414, 418, 420, 424],
        420: [414, 419, 421, 423, 424],
        421: [413, 420, 422, 423],
        422: [413, 421, 423, 427, 428],
        423: [420, 421, 422, 424, 426, 427],
        424: [418, 419, 420, 423, 426, 425],
        425: [424, 426, 429, 430],
        426: [423, 424, 425, 427, 429],
        427: [422, 423, 426, 428, 429],
        428: [422, 427, 429, 436],
        429: [425, 426, 427, 428, 430, 435, 436],
        430: [425, 429, 433, 434, 435, 441, 444],
        431: [433, 441, 9540, 9541],
        433: [430, 431, 444, 9540, 9541],
        434: [430, 435, 439, 444, 8878],
        435: [429, 430, 434, 436, 437, 8878],
        436: [428, 429, 435, 437],
        437: [435, 436, 8878],
        439: [434, 444, 8878],
        441: [430, 431, 433],
        442: [414, 415, 420, 421, 422],
        443: [425, 429, 433, 434, 435, 441, 444],
        444: [430, 433, 434, 439, 9540, 9541],
        445: [415, 416, 418],
        8878: [434, 435, 437, 439],
        9540: [431, 433, 444, 9541],
        9541: [431, 433, 444, 9540],
    }
    
    def __init__(self, start_date, end_date):
        self.stories = Story.objects.select_related(
            'school').all().order_by().values('id')
        self.assessments = AssessmentsV2.objects.all().order_by().values('assess_uid')
        if start_date:
            self.stories = self.stories.filter(
                date_of_visit__gte=start_date,
            )
            self.assessments = self.assessments.filter(
                assessed_ts__gte=start_date,
            )
        if end_date:
            self.stories = self.stories.filter(
                date_of_visit__lte=end_date,
            )
            self.assessments = self.assessments.filter(
                assessed_ts__lte=end_date,
            )

        survey = Survey.objects.get(name="GP Contest")
        questiongroups = survey.questiongroup_set.all()
        self.gp_contest_stories = self.stories.filter(
            group__in=questiongroups,
        )
        self.gp_contest_schools = self.gp_contest_stories.values_list(
            'school', flat=True).distinct('school')

    def generate_boundary_summary(self, boundary, chosen_boundary):
        government_crps = Group.objects.get(name="CRP").user_set.all()
        
        summary = {}

        if boundary == chosen_boundary:
            summary['chosen'] = True
        else:
            summary['chosen'] = False

        boundary_schools = boundary.schools()
            
        summary['boundary_name'] = boundary.name
        summary['boundary_type'] = boundary.hierarchy.name
        summary['schools'] = boundary_schools.count()
        summary['sms'] = self.stories.filter(
            group__source__name='sms',
            school__in=boundary_schools,
        ).count()
        summary['sms_govt'] = self.stories.filter(
            group__source__name='sms',
            school__in=boundary_schools,
            user__in=government_crps
        ).count()
        summary['assessments'] = self.assessments.filter(
            student_uid__school_code__in=boundary_schools
        ).count()

        summary['contests'] = boundary_schools.filter(
            id__in=self.gp_contest_schools
        ).aggregate(
            gp_count=Count(
                'electedrep__gram_panchayat',
                distinct=True
            )
        )['gp_count']

        question_groups = Survey.objects.get(
            name="Community"
        ).questiongroup_set.filter(
            source__name="csv"
        )
        
        summary['surveys'] = self.stories.filter(
            group__in=question_groups,
            school__in=boundary_schools,
        ).count()

        return summary

    def get_hierarchy_summary(self, chosen_school=None, chosen_boundary=None):
        hierarchy_summaries = []
        if chosen_school:
            chosen_boundary = chosen_school.admin3

        boundary = chosen_boundary
        boundaries = [boundary,]
        while(boundary.hierarchy.name != "district"):
            boundaries.append(boundary.parent)
            boundary = boundary.parent

        for boundary in boundaries:
            summary = self.generate_boundary_summary(boundary, chosen_boundary)
            hierarchy_summaries.append(summary)

        return hierarchy_summaries

    def get_neighbour_summary(self, chosen_boundary):
        neighbour_summaries = []
        if chosen_boundary == 'GKA':
            neighbour_ids = GKA_DISTRICTS
            chosen_boundary = Boundary.objects.get(id=GKA_DISTRICTS[0])
        else:
            neighbour_ids = self.neighbourIds[chosen_boundary.id] + [chosen_boundary.id]
        neighbours = Boundary.objects.filter(id__in=neighbour_ids)
        for neighbour in neighbours:
            summary = self.generate_boundary_summary(neighbour, chosen_boundary)
            neighbour_summaries.append(summary)

        return neighbour_summaries

    def get_summary_comparison(self, chosen_boundary, chosen_school):
        summary = {}
        districts = BoundaryHierarchy.objects.filter(name='district')
        block = BoundaryHierarchy.objects.get(name='block')
        cluster = BoundaryHierarchy.objects.get(name='cluster')

        if chosen_school:
            summary = self.get_hierarchy_summary(chosen_school=chosen_school)
        elif chosen_boundary == 'GKA' or chosen_boundary.hierarchy in districts:
            summary = self.get_neighbour_summary(chosen_boundary=chosen_boundary)
        else:
            summary = self.get_hierarchy_summary(chosen_boundary=chosen_boundary)

        return summary

    def generate_boundary_competency(self, boundary, chosen_boundary):
        gp_contest = {}
        ekstep = {}
        
        if boundary == chosen_boundary:
            gp_contest['chosen'] = True
            ekstep['chosen'] = True
        else:
            gp_contest['chosen'] = False
            ekstep['chosen'] = False

        boundary_schools = boundary.schools().values_list('id', flat=True)

        gp_contest['boundary_name'] = boundary.name
        gp_contest['boundary_type'] = boundary.hierarchy.name
        gp_contest['type'] = 'gp_contest'

        ekstep['boundary_name'] = boundary.name
        ekstep['boundary_type'] = boundary.hierarchy.name
        ekstep['type'] = 'ekstep'

        # GP Contest
        survey = Survey.objects.get(name="GP Contest")
        questiongroups = survey.questiongroup_set.all()
        stories = self.stories.filter(
            group__in=questiongroups,
            school__in=boundary_schools
        )

        answers = Answer.objects.filter(story__in=stories)
        answer_counts = answers.values('question', 'text').annotate(Count('text'))

        competencies = {}

        temp_list = []
        for entry in answer_counts:
            question_id = entry['question']
            if question_id in temp_list:
                continue
            else:
                temp_list.append(question_id)
            question_text = Question.objects.only('text').get(id=question_id).text
            answer_text = entry['text']
            answer_count = entry['text__count']
            if question_text not in competencies:
                competencies[question_text] = {}
            competencies[question_text][answer_text] = answer_count

        gp_contest['competencies'] = competencies

        #EkStep
        assessments = self.assessments.filter(
            student_uid__school_code__in=boundary_schools
        )
        ekstep_class = EkStepGKA()
        ekstep['competencies'] = ekstep_class.get_scores(assessments)

        return gp_contest, ekstep

    def get_hierarchy_competency(self, chosen_school=None, chosen_boundary=None):
        hierarchy_competencies = []
        if chosen_school:
            chosen_boundary = chosen_school.admin3

        boundary = chosen_boundary
        boundaries = [boundary,]
        while(boundary.hierarchy.name != "district"):
            boundaries.append(boundary.parent)
            boundary = boundary.parent

        for boundary in boundaries:
            competency = self.generate_boundary_competency(boundary, chosen_boundary)
            hierarchy_competencies.append(competency)

        return hierarchy_competencies

    def get_neighbour_competency(self, chosen_boundary):
        neighbour_competencies = []
        if chosen_boundary == 'GKA':
            neighbour_ids = GKA_DISTRICTS
            chosen_boundary = Boundary.objects.get(id=GKA_DISTRICTS[0])
        else:
            neighbour_ids = self.neighbourIds[chosen_boundary.id] + [chosen_boundary.id]
        neighbours = Boundary.objects.filter(id__in=neighbour_ids)
        for neighbour in neighbours:
            competency = self.generate_boundary_competency(neighbour, chosen_boundary)
            neighbour_competencies.append(competency)

        return neighbour_competencies

    def get_competency_comparison(self, chosen_boundary, chosen_school):
        summary = {}
        districts = BoundaryHierarchy.objects.filter(name='district')
        block = BoundaryHierarchy.objects.get(name='block')
        cluster = BoundaryHierarchy.objects.get(name='cluster')

        if chosen_school:
            summary = self.get_hierarchy_competency(chosen_school=chosen_school)
        elif chosen_boundary == 'GKA' or chosen_boundary.hierarchy in districts:
            summary = self.get_neighbour_competency(chosen_boundary=chosen_boundary)
        else:
            summary = self.get_hierarchy_competency(chosen_boundary=chosen_boundary)

        return summary

    def generate_report(self, chosen_boundary, chosen_school):
        response = {}
        response['summary_comparison'] = {}
        response['competency_comparison'] = {}
        
        if chosen_school:
            chosen_boundary = chosen_school.admin3
        elif not chosen_boundary:
            chosen_boundary = 'GKA'

        response['summary_comparison'] = self.get_summary_comparison(
            chosen_boundary, chosen_school)
        response['competency_comparison'] = self.get_competency_comparison(
            chosen_boundary, chosen_school)

        return response    
