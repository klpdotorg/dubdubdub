from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi Mallur 2013-14 questions

    ./manage.py populateanganwadimallur"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        start_date = datetime.strptime('2013-08-06', '%Y-%m-%d')
        end_date = datetime.strptime('2014-12-30', '%Y-%m-%d')
        question_group = Questiongroup.objects.get_or_create(
            version=4,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        questions = [
            "In which year anganwadi was started",
            "Anganwadi worker was present on time during visit",
            "Anganwadi helper was present on time during visit",
            "Center is functioning with the women & children development dept.",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "There is space in and out of anganwadi center to conduct pre education activity",
            "There is enough space available for children to play in the Anganwadi premises",
            "Anganwadi center premises has lawn, flower plants and trees",
            "Anganwadi center walls are in good shape",
            "Anganwadi center floor is in good shape",
            "Anganwadi center roof is in good shape",
            "All doors are strong and can be bolted and locked",
            "All windows are strong and can be bolted and locked",
            "The floor, walls, corners of walls and roof are free of cobweb and dust",
            "Anganwadi Center wall was painted and was full of writings related to learning",
            "Learning materials are present in the center",
            "There is dust bin in the center",
            "Dustbin is used by children",
            "Children have learned to keep center room clean",
            "Store room is maintained to preserve food items",
            "Store room is clean",
            "Food to be distributed on that day was covered properly",
            "All children got the meals on time on the day of visit",
            "Afternoon food was distributed at the time of visit (mention the time)",
            "The cook / chef  maintains cleanliness and wore clean clothes on the day of visit",
            "There is separate facility for washing hands after meals",
            "Center has water available in the taps",
            "There is regular water supply in the tap",
            "Surrounding areas near the tap is clean",
            "There is pure drinking water facility",
            "The vessel is always kept covered and children do not dip their hands/fingers in it",
            "There is a toilet for children to use",
            "Toilet roof is maintained to avoid children from sun/rain",
            "There is water facility in the toilet",
            "Jug is easily available to children in the toilet",
            "The toilet's interior and the basin are free of stink and moss",
            "First aid box contains all the necessary items",
            "Materials available in first aid box are being used",
            "There is black board in the center",
            "Black board is convenient for children and teacher's viewing and writing",
            "Children register book is maintained by anganwadi worker",
            "The Anganwadi worker daily signs and confirms that children's attendance is as per the attendance register",
            "Name of the student who has taken TC is circled and comment written",
            "50% of attendance was there at the time of visit",
            "Progress in children learning is documented",
            "Teacher's diary is maintained",
            "Anganwadi worker maintains the attendance register of the Anganwadi staff",
            "Accounting records are maintained",
            "Learning material record is maintained",
            "Anganwadi has a record of health details of each children",
            "Medical check was done within last 3 months",
            "Children list of special need is available",
            "There is basic facility for children with special needs",
            "Materials necessary (learning) for physically challenged / disabled children are available",
            "Teacher is trained to teach physically challenged / disabled children",
            "Bala Vikas Samithi is present",
            "List of BVS member is maintained",
            "BVS proceedings book exists",
            "Anganwadi Centre has a list of roles and responsibilities of BVS as prescribed by the Govt.",
            "BVS is functioning as per the rules & regulation",
            "Anganwadi worker is trained",
            "Pre school start time",
            "Pre school end time",
            "Weekly TLM plan organized in the anganwadi center",
            "List the anganwadi center TLM",
            "Anganwadi worker cooperates with children",
            "Anganwadi worker & helper had a mutual understanding",
            "Children are active with the TLM provided by akshara",
            "Anganwadi worker gives needed guidance to each child, examines all activities, correct mistakes",
            "Activities are conducted using learning material by the anganwadi worker",
            "TLM material are dependable and effective in using & learning",
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

        print "Anganwadi Mallur 2013-14 questions populated."
