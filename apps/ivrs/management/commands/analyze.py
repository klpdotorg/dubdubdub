import json
import datetime

from collections import Counter

from django.core.management.base import BaseCommand

from ivrs.models import State
from schools.models import School, BoundaryType
from stories.models import Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with New GKA IVRS questions

    ./manage.py populatenewgkaivrsdata"""

    def handle(self, *args, **options):
        d1 = datetime.datetime.now() - datetime.timedelta(days=39)
        d2 = datetime.datetime.now() - datetime.timedelta(days=33)

        states = State.objects.filter(
            ivrs_type="gka-sms",
            date_of_visit__gte=d1,
            date_of_visit__lte=d2,
            is_invalid=False
        ).order_by(
            '-date_of_visit'
        )

        d = {}
        for state in states:
            if state.date_of_visit.day in d:
                if state.telephone in d[state.date_of_visit.day]:
                    d[state.date_of_visit.day][state.telephone] += 1
                else:
                    d[state.date_of_visit.day][state.telephone] = 1
            else:
                d[state.date_of_visit.day] = {}

        # print json.dumps(d, indent=4)

        school_ids = states.values_list('school_id', flat=True)
        schools = School.objects.filter(id__in=school_ids)
        districts = schools.values_list(
            'admin3__parent__parent__name',
            flat=True
            ).order_by(
            ).distinct(
                'admin3__parent__parent__name'
                )

        response = {}
        district_school_mapping = {}
        district_answers_mapping = {}
        for district in districts:
            response[district] = {}

            #########################
            district_school_mapping[district] = schools.filter(
                admin3__parent__parent__name=district
                ).values_list('id', flat=True).order_by().distinct('id')
            number_of_schools_visited = len(district_school_mapping[district])
            # print "Schools: " + str(number_of_schools_visited)
            number_of_classes_visited = sum(
                Counter(
                    [i for i in school_ids if i in district_school_mapping[district]]
                    ).itervalues()
                )
            # print "Classes: " + str(number_of_classes_visited)
            ########################
            response[district]
            response[district]['classes_visited'] = number_of_classes_visited

            district_answers_mapping[district] = {i:{} for i in range(1,6)}
            temp_states = None
            # print json.dumps(district_answers_mapping, indent=4)
            temp_states = states.filter(school_id__in=district_school_mapping[district])
            # print district_answers_mapping[district][1]
            for temp_state in temp_states:
                for (question_number, value) in enumerate(temp_state.answers[1:]):
                    # print temp_state.answers[1:]
                    # print question_number
                    # print value
                    # print district_answers_mapping[district][question_number+1]
                    if value == 'NA':
                        continue
                    if value in district_answers_mapping[district][question_number+1]:
                        district_answers_mapping[district][question_number+1][value] += 1
                    else:
                        district_answers_mapping[district][question_number+1][value] = 1

                    # print "--------------------"

            for i in range(1, 6):
                total = sum(district_answers_mapping[district][i].itervalues())
                #print district_answers_mapping[district][i]
                if 'Yes' in district_answers_mapping[district][i]:
                    percentage = float(float(district_answers_mapping[district][i]['Yes']/float(total))*100)
                else:
                    percentage = 0
                district_answers_mapping[district][i]['Percentage'] = round(percentage, 2)

            district_answers_mapping[district]['schools_visited'] = number_of_schools_visited
            district_answers_mapping[district]['classes_visited'] = number_of_classes_visited

            blocks = schools.filter(
                admin3__parent__parent__name=district
            ).values_list(
            'admin3__parent__name',
            flat=True
            ).order_by(
            ).distinct(
                'admin3__parent__parent__name'
            )
            block = blocks[0]
            district_answers_mapping[district]['blocks'] = block

        print json.dumps(district_answers_mapping, indent=4)

        # for district in districts:
        #     number_of_schools_visited = s.filter(order_by().distinct('school_id').count()
        # school = School.objects.get(id=state.school_id)
        # district = school.admin3.parent.parent.name.replace(',', '-')
