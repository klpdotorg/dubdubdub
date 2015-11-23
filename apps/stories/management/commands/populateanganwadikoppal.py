from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi Koppal 2012-13 questions

    ./manage.py populateanganwadikoppal"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        start_date = datetime.strptime('2013-06-04', '%Y-%m-%d')
        end_date = datetime.strptime('2014-05-30', '%Y-%m-%d')
        question_group = Questiongroup.objects.get_or_create(
            version=5,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        questions = [
            "This Anganwadi has its own building & it was in good condition",
            "Store room is maintained to preserve food items",
            "The children have maintained the class room neatly",
            "In the Anganwadi, there is drinking water & usage water facility and it was neat",
            "Toilet is in good condition to use",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "50% of attendance was there at the time of visit",
            "Children are able to write on the black board",
            "Learning materials are present in the center",
            "Is wall writing and charts related to learning material available for center",
            "Activities are conducted using learning material by the anganwadi worker",
            "Anganwadi worker was involving all children in to the activities",
            "Anganwadi worker helps akshara worker involve in all programmes",
            "The BVS member list is maintained in the center",
            "Anganwadi friendship group is formed",
            "Has the anganwadi worker done evaluation on children's learning till now",
            "Friends of anganwadi are continuously involved",
            "Anganwadi worker & helper had a mutual understanding",
            "BVS is involved in all the anganwadi activities",
            "For questions asked by visitor, children are actively answering"
        ]

        for count, question in enumerate(questions):
            q = Question.objects.get_or_create(
                text=question,
                data_type=1,
                user_type=user_type,
                question_type=question_type,
                school_type=school_type,
                options="{'Yes','No'}",
            )[0]

            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group, question=q, sequence=count+1)

        print "Anganwadi Koppal 2012-13 questions populated."
