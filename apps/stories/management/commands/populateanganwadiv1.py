from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi Bangalore 2014-15 v1

    ./manage.py populateanganwadiv1"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        start_date = datetime.strptime('2014-08-18', '%Y-%m-%d')
        end_date = datetime.strptime('2015-12-30', '%Y-%m-%d')
        question_group = Questiongroup.objects.get_or_create(
            version=1,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type_checkbox = QuestionType.objects.get(name="checkbox")
        question_type_numeric = QuestionType.objects.get(name="numeric")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type = UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        questions = [
            "Number of students enrolled(boys)",
            "Number of students enrolled(girl)",
            "Number of students present(boy)",
            "Number of students present(girl)",
            "Where is the center functioning",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule)  meaning there is an indoor enclosure",
            "There is an outdoor space for 30 children  with space of 30sq",
            "There is a toilet for children to use",
            "There is pure drinking water facility",
            "There is safety around the center",
            "There is cleanliness around the center",
            "The building is safe",
            "There is basic facility for children with special needs",
            "There is seating facility available for children",
            "There is clean rooms to sit for children",
            "There is dust and spider web inside the center room",
            "There is dust bin in the center",
            "There is seperate space for storing food items in the center",
            "Store room is clean",
            "Food to be distributed on that day was covered properly",
            "Cook/ chef are clean",
            "There is seperate place for children to wash hands after lunch",
            "First aid box contains all the necessary items",
            "There is sufficient learning material and playing items for children",
            "There is sufficient learning material for indoor activities",
            "Indoor learning materials are bieng used by children",
            "There is black board in the center and children are able to write on it",
            "There is writings on the wall related to learning",
            "The medical report of every children is maintained",
            "BVS is present",
            "Anganwadi friendship group is formed",
            "Activities are conducted by anganwadi friendship group members",
            "Anganwadi worker is trained",
            "Learning materials present",
            "Number of students with special needs(boy)",
            "Number of students with special needs(girl)"
        ]

        for count, question in enumerate(questions):
            if count in [0, 1, 2, 3, 4, 34, 35]:
                question_type = question_type_numeric
                options = None
            else:
                question_type = question_type_checkbox
                options = "{'Yes','No'}"

            q = Question.objects.get_or_create(
                text=question,
                data_type=1,
                user_type=user_type,
                question_type=question_type,
                school_type=school_type,
                options=options,
            )[0]

            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group, question=q, sequence=count+1)

        print "Anganwadi Bangalore 2014-15 v1 questions populated."
