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
            "Anganwadi runs in its own building (i.e designated for running Anganwadi,built by the Woman & Child department)",
            "Store room is maintained to preserve food items",
            "Children have learned to keep center room clean",
            "Surrounding areas near the tap is clean",
            "Toilet is in good condition to use",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "50% of attendance was there at the time of visit",
            "Black board is convenient for children and teacher's viewing and writing",
            "Learning materials are present in the center",
            "Anganwadi Center wall was painted and was full of writings related to learning",
            "Activities are conducted using learning material by the anganwadi worker",
            "Anganwadi worker was involving all children in to the activities",
            "Anganwadi worker helps akshara worker involve in all programmes",
            "List of BVS member is maintained",
            "Anganwadi friendship group is formed",
            "Has the anganwadi worker done evaluation on children's learning till now",
            "Friends of Anganwadi members are conducting the activities",
            "Anganwadi worker & helper had a mutual understanding",
            "BVS is involved in all the anganwadi activities",
            "Children actively answer the questions asked by visitor"
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
