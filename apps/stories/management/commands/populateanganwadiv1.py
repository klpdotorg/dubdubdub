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
            "Number of students enrolled (boys)",
            "Number of students enrolled (girls)",
            "Number of students present (boys)",
            "Number of students present (girls)",
            "Where is the center functioning",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "There is an outdoor space for 30 children, with space of 30sq",
            "There is a toilet for children to use",
            "There is pure drinking water facility",
            "There is safety around the center",
            "There is cleanliness around the center",
            "The building is safe",
            "There is basic facility for children with special needs",
            "There is seating facility available for children",
            "There are clean rooms to sit for children",
            "The floor, walls, corners of walls and roof are free of cobweb and dust",
            "There is dust bin in the center",
            "Store room is maintained to preserve food items",
            "Store room is clean",
            "Food to be distributed on that day was covered properly",
            "The cook / chef  maintains cleanliness and wore clean clothes on the day of visit",
            "There is separate facility for washing hands after meals",
            "First aid box contains all the necessary items",
            "There is sufficient learning material and playing items for children",
            "There is sufficient learning material for indoor activities",
            "Indoor learning materials are being used by children",
            "There is black board in the center",
            "Anganwadi Center wall was painted and was full of writings related to learning",
            "Anganwadi has a record of health details of each children",
            "Bala Vikas Samithi is present",
            "Anganwadi friendship group is formed",
            "Friends of Anganwadi members are conducting the activities",
            "Anganwadi worker is trained",
            "Learning materials are present in the center",
            "Number of students with special needs (boys)",
            "Number of students with special needs (girls)"
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
