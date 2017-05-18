from django.contrib.auth.models import Group

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
        
    def get_hierarchy_summary(self, chosen_school=None, chosen_boundary=None):
        if chosen_school:
            pass

    def get_neighbour_summary(self, chosen_boundary):
        neighbour_summaries = []
        government_crps = Group.objects.get(name="CRP").user_set.all()
        neighbour_ids = self.neighbourIds[chosen_boundary.id] + [chosen_boundary.id]
        print "+++++++++++++++++++++++++++++"
        print neighbour_ids
        print "++++++++++++++++++++++++++++++"
        neighbours = Boundary.objects.filter(id__in=neighbour_ids)
        for neighbour in neighbours:
            summary = {}
            if neighbour == chosen_boundary:
                summary['chosen'] = True
            else:
                summary['chosen'] = False
            summary['name'] = neighbour.name
            summary['schools'] = neighbour.schools().count()
            summary['sms'] = self.stories.filter(
                group__source__name='sms',
                school__admin3__parent__parent=neighbour,
            ).count()
            summary['sms_govt'] = self.stories.filter(
                group__source__name='sms',
                school__admin3__parent__parent=neighbour,
                user__in=government_crps
            ).count()
            summary['assessments'] = self.assessments.filter(
                student_uid__district=neighbour.name
            ).count()
            summary['contests'] = 1 # Modify after we decide how to identify contests.

            question_groups = Survey.objects.get(
                name="Community"
            ).questiongroup_set.filter(
                source__name__in=["mobile","csv"]
            )
            summary['surveys'] = self.stories.filter(
                group__in=question_groups,
                school__admin3__parent__parent=neighbour,
            ).count()

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

    def get_competency_comparison(self, chosen_boundary, chosen_school):
        pass

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
