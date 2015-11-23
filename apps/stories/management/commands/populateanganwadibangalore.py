from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi Bangalore 2013-14 questions

    ./manage.py populateanganwadibangalore"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        start_date = datetime.strptime('2014-01-13', '%Y-%m-%d')
        end_date = datetime.strptime('2014-05-30', '%Y-%m-%d')
        question_group = Questiongroup.objects.get_or_create(
            version=3,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        questions = [
            "Store room is clean",
            "Anganwadi worker was present on time during visit",
            "Anganwadi center walls are in good shape",
            "Anganwadi center premises has lawn, flower plants and trees",
            "Anganwadi has a record of health details of each children",
            "There is pure drinking water facility",
            "All children got the meals on time on the day of visit",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "List of BVS member is maintained",
            "Anganwadi helper was present on time during visit",
            "There is basic facility for children with special needs",
            "Materials necessary (learning) for physically challenged / disabled children are available",
            "The vessel is always kept covered and children do not dip their hands/fingers in it",
            "Anganwadi workers are trained of TLM basic",
            "Anganwadi friendship group is formed",
            "There is water facility in the toilet",
            "BVS proceedings book exists",
            "Center has water available in the taps",
            "There is dust bin in the center",
            "Children are active with the TLM provided by akshara",
            "Children list of special need is available",
            "Surrounding areas near the tap is clean",
            "The floor, walls, corners of walls and roof are free of cobweb and dust",
            "All windows are strong and can be bolted and locked",
            "Center is functioning with the women & children development dept.",
            "Black board is convenient for children and teacher's viewing and writing",
            "First aid box contains all the necessary items",
            "Name of the student who has taken TC is circled and comment written",
            "Store room is maintained to preserve food items",
            "Accounting records are maintained",
            "Learning material record is maintained",
            "Anganwadi Center wall was painted and was full of writings related to learning",
            "Toilet roof is maintained to avoid children from sun/rain",
            "Anganwadi workers are trained about TLM kit",
            "Anganwadi center roof is in good shape",
            "In the Anganwadi, assessment has been done by akshara foundation",
            "Dustbin is used by children",
            "Children have learned to keep center room clean",
            "The Anganwadi worker daily signs and confirms that children's attendance is as per the attendance register",
            "Friends of Anganwadi members are conducting the activities",
            "There is a toilet for children to use",
            "Learning materials are present in the center",
            "TLM material are dependable and effective in using & learning",
            "All doors are strong and can be bolted and locked",
            "Activities are conducted using learning material by the anganwadi worker",
            "Teacher is trained to teach physically challenged / disabled children",
            "Anganwadi worker gives needed guidance to each child, examines all activities, correct mistakes",
            "There is black board in the center",
            "The toilet's interior and the basin are free of stink and moss",
            "Food to be distributed on that day was covered properly",
            "Teacher's diary is maintained",
            "BVS is functioning as per the rules & regulation",
            "Medical check was done within last 3 months",
            "Progress in children learning is documented",
            "There is enough space available for children to play in the Anganwadi premises",
            "Anganwadi worker maintains the attendance register of the Anganwadi staff",
            "Children register book is maintained by anganwadi worker",
            "Anganwadi worker has maintained the document on all the children who have passed out of Anganwadi last year and are aware of their whereabouts",
            "Jug is easily available to children in the toilet",
            "There is regular water supply in the tap",
            "There is separate facility for washing hands after meals",
            "Anganwadi worker is trained",
            "Regarding learn process",
            "Anganwadi worker is aware of year of establishment of this Anganwadi",
            "Anganwadi center floor is in good shape",
            "Anganwadi Centre has a list of roles and responsibilities of BVS as prescribed by the Govt.",
            "The cook / chef maintains cleanliness and wore clean clothes on the day of visit",
            "Materials available in first aid box are being used",
            "Bala Vikas Samithi is present",
            "50% of attendance was there at the time of visit"
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

        print "Anganwadi Bangalore 2013-14 questions populated."
