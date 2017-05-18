from django.db.models import Q
from django.db.models import Count
from django.contrib.auth.models import Group

from schools.api_views.ekstep_gka import EkStepGKA

from schools.models import (
    AssessmentsV2,
    Boundary,
    BoundaryHierarchy
)
from .models import Story, Survey

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
        9541: [431, 433, 444, 9540]
    }
    
    def __init__(self, start_date, end_date):
        self.stories = Story.objects.all()
        self.assessments = AssessmentsV2.objects.all()
        if start_date:
            self.stories = self.stories.filter(
                date_of_visit__gte=start_date,
            )
            self.assessments = self.stories.filter(
                assessed_ts__gte=start_date,
            )
        if end_date:
            self.stories = self.stories.filter(
                date_of_visit__lte=end_date,
            )
            self.assessments = self.stories.filter(
                assessed_ts__lte=end_date,
            )

    def generate_boundary_summary(self, boundary, chosen_boundary):
        government_crps = Group.objects.get(name="CRP").user_set.all()
        
        summary = {}

        if boundary == chosen_boundary:
            summary['chosen'] = True
        else:
            summary['chosen'] = False

        summary['boundary_name'] = boundary.name
        summary['boundary_type'] = boundary.hierarchy.name
        summary['schools'] = boundary.schools().count()
        summary['sms'] = self.stories.filter(
            group__source__name='sms',
            school__admin3__parent__parent=boundary,
        ).count()
        summary['sms_govt'] = self.stories.filter(
            group__source__name='sms',
            school__admin3__parent__parent=boundary,
            user__in=government_crps
        ).count()
        summary['assessments'] = self.assessments.filter(
            Q(student_uid__district=boundary.name) |
            Q(student_uid__block=boundary.name) |
            Q(student_uid__cluster=boundary.name)
        ).count()
        summary['contests'] = 1 # Modify after we decide how to identify contests.
        
        question_groups = Survey.objects.get(
            name="Community"
        ).questiongroup_set.filter(
            source__name__in=["mobile","csv"]
        )
        summary['surveys'] = self.stories.filter(
            group__in=question_groups,
            school__admin3__parent__parent=boundary,
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
        elif chosen_boundary.hierarchy in districts:
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
            school__in=boundary.schools()
        )
        questions = []
        for qg in questiongroups:
            questions += list(qg.questions.all(
            ).order_by('questiongroupquestions__sequence')[:20])

        competencies = {}
        for question in questions:
            list_of_answers = question.answer_set.filter(
                story__in=stories
            ).values('text').annotate(answer_count=Count('text'))
            
            competencies[question.text] = {
                answer['text']:answer['answer_count'] for answer in list_of_answers
            }
        gp_contest['competencies'] = competencies

        #EkStep
        assessments = self.assessments.filter(
            Q(student_uid__district=boundary.name) |
            Q(student_uid__block=boundary.name) |
            Q(student_uid__cluster=boundary.name)
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
        elif chosen_boundary.hierarchy in districts:
            summary = self.get_neighbour_competency(chosen_boundary=chosen_boundary)
        else:
            summary = self.get_hierarchy_competency(chosen_boundary=chosen_boundary)

        return summary

    def generate_report(self, chosen_boundary, chosen_school):
        response = {}
        response['summary_comparison'] = {}
        response['competency_comparison'] = {}
        if not chosen_boundary:
            return response

        response['summary_comparison'] = self.get_summary_comparison(
            chosen_boundary, chosen_school)
        response['competency_comparison'] = self.get_competency_comparison(
            chosen_boundary, chosen_school)

        return response    
