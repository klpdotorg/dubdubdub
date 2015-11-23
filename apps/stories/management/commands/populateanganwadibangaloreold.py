from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question,
    Questiongroup,
    QuestionType,
    QuestiongroupQuestions,
    Source,
    UserType
)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi Bangalore 2010-12 questions

    ./manage.py populateanganwadibangaloreold"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        # Dates are guessed.
        start_date = datetime.strptime('2010-01-13', '%Y-%m-%d')
        end_date = datetime.strptime('2012-05-30', '%Y-%m-%d')
        question_group = Questiongroup.objects.get_or_create(
            version=6,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type = UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        questions = [
            "Anganwadi worker is aware of year of establishment of this Anganwadi (Ask Anganwadi Worker)",
            "Anganwadi worker was present on the day of the visit",
            "Anganwadi helper was present on the day of the visit",
            "Anganwadi runs in its own building (i.e designated for running Anganwadi,built by the Woman & Child department)",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "There is enough space available for children to play in the Anganwadi premise",
            "Anganwadi center premises has lawn, flower plants and trees.(through observation)",
            "Plaster of the walls are not damaged (through observation)",
            "Anganwadi center floor is in good shape",
            "Anganwadi center roof is in good shape",
            "All doors are strong and can be bolted and locked (through observation)",
            "All windows are strong and can be bolted and locked (through observation)",
            "The floor, walls, corners of walls and roof are free of cobweb and dust",
            "Anganwadi Center wall painted and is full of writings related to Learning (through observation)",
            "There is dust bin in the center",
            "Children are using the waste basket (observed on the day of visit )",
            "Children are taught to maintain cleanliness in the room (ask Aya or Worker & observe)",
            "Store room is maintained to preserve food items",
            "Store room is clean",
            "Food to be distributed on that day was covered properly",
            "All children got the meals on time on the day of visit (through observation)",
            "The cook maintains cleanliness and wore clean clothes on the day of visit (through observation)",
            "There is separate facility for washing hands after meals",
            "Center has water available in the taps",
            "There is regular water supply in the tap (through observation)",
            "surrounding of the water tap is clean (through observation)",
            "There is pure drinking water facility",
            "The vessel is always kept covered and children do not dip their hands/fingers in it(through observation).",
            "There is a toilet for children to use",
            "Toilet roof protects children from rain and heat (through observation)",
            "Running water is available in the toilet tap (through observation)",
            "There is a mug in the toilet and reachable to children (through observation)",
            "The toilet's interior and the basin are free of stink and moss (through observation)"
            "First aid box with all necessary items available (through observation)",
            "Materials available in first aid box are being used (ask Aya or Worker & observe)",
            "There is black board in the center",
            "Black board is convenient for children and teacher's viewing and writing.(Through observation)"
            "Admission records are maintained",
            "The Anganwadi worker daily signs and confirms that children's attendance is as per the attendance register."
            "Name of the student who has taken TC is circled and comment written (to be cross checked)",
            "Anganwadi worker has maintained the document on all the children who have passed out of Anganwadi last year and in aware of their whereabouts (to be cross checked)",
            "50% of the children enrolled were present on the day of visit (to be cross checked)",
            "Progress in children learning is documented",
            "Teacher's diary is maintained",
            "Anganwadi worker maintains the attendance register of the Anganwadi staff(to be asked to Anganwadi Worker & cross check it)",
            "Accounts are maintained (to be asked to Anganwadi Worker & cross check it)",
            "Stock register of the Teach Learning Material is maintained (to be asked to Anganwadi Worker & cross check it)",
            "Anganwadi has a record of health details of each children (ask Aya or Worker & cross check records)",
            "Health checkup was held last month (ask Aya or Worker & cross check records)",
            "Children list of special need is available",
            "There is basic facility for children with special needs",
            "Materials necessary (learning) for physically challenged / disabled children are available. (ask Aya or Worker & cross check records)",
            "Teacher is Trained to teach physically challenged / disabled children (ask Aya or Worker)",
            "Bala Vikas Samithi is present",
            "Has maintained the roster of members (ask Aya or Worker & cross check records)",
            "BVS proceedings book exists (ask Aya or Worker & cross check records)",
            "Anganwadi Centre has a list of roles and responsibilities of BVS as prescribed by the Govt(ask Aya or Worker & cross check records)",
            "Bala Vikas Samithi meeting is conducted",
            "Friends of Anganwadi has been formed (ask Akshara FC & cross check with FoA members)",
            "Friends of Anganwadi members are conducting the activities(ask Akshara FC & cross check with FoA members)",
            "Anganwadi worker is trained",
            "The Anganwadi calendar has been prepared(ask Anganwadi worker cross check records)",
            "Anganwadi has Akshara Anganwadi center Preparedness kit (through observation)",
            "Anganwadi worker has been trained on the kit(ask Worker & cross check )",
            "Anganwadi worker has been trained on Assessment of the children(ask Worker & cross check )",
            "Child Assessment has trained by Akshara has taken place (ask Aya or Worker & cross check records)",
            "Children are engaged with materials based on learning outcomes are used by children (Through observation)",
            "Anganwadi worker gives needed guidance to each child, examines all activities, correct mistakes (Through observation)",
            "Activities are conducted using learning material by the anganwadi worker",
            "Material usage is learning outcome based and effective (Through Observation)"
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

        print "Anganwadi Bangalore 2010-12 questions populated."
