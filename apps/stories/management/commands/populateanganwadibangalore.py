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
            "Anganwadi ground filled with grass, plant & tree",
            "Children medical report is maintained",
            "There is pure drinking water facility",
            "Food was distributed on time at the time of visit",
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure",
            "List of BVS member is maintained",
            "Anganwadi helper was present on time during visit",
            "There is basic facility for children with special needs",
            "Learning material is available for handicap children in the center",
            "Vessel are always closed to avoid children placing hand",
            "Anganwadi workers are trained of TLM basic",
            "Anganwadi friendship group is formed",
            "There is water facility in the toilet",
            "BVS book is maintained",
            "Center has water available in the taps",
            "There is dust bin in the center",
            "Children are active with the TLM provided by akshara",
            "Children list of special need is available",
            "Surrounding near the tap is clean",
            "The floor, walls, corners of walls and roof are free of cobweb and dust",
            "All the window panes are strong and can be locked",
            "Center is functioning with the women & children development dept.",
            "Children are able to write on the black board",
            "Necessary items are available in the first aid box",
            "Anganwadi worker has marked the last year 6yrs completed children name (each children details according to name)",
            "Store room is maintained to preserve food items",
            "Accounting records are maintained",
            "Learning material record is maintained",
            "Anganwadi walls are painted with learning subject",
            "Toilet roof is maintained to avoid children from sun/rain",
            "Anganwadi worker are trained about TLM kit",
            "Anganwadi center roof is in good shape",
            "In the Anganwadi, assessment has been done by akshara foundation",
            "Dustbin is used by children",
            "Children have learned to keep center room clean",
            "Every day children attendance is confirmed in the attendance book by anganwadi worker through signature",
            "Activities are conducted by anganwadi friendship group members",
            "There is a toilet for children to use",
            "Learning materials are present in the center",
            "TLM material are dependable and effective in using & learning",
            "Doors are strong & can be bolted & locked",
            "Activities are conducted using learning material by the anganwadi worker",
            "Workers are trained to teach handicapped children",
            "Anganwadi workers are examining the children activities",
            "There is black board in the center",
            "Algae is not found in toilet basin",
            "Food to be distributed on that day was covered properly",
            "Teacher dairy is maintained",
            "BVS is functioned as per the rules & regulation",
            "Medical check done within 3 months",
            "Progress in children learning is documented",
            "For the children play ground is spacious",
            "Staff attendance & other information is maintained",
            "Children register book is maintained by anganwadi worker",
            "Details provided for the child to whom TC is issued",
            "Jug is easily available to children in the toilet",
            "There is water supply through taps",
            "There is separate facility for washing hands after meals",
            "Anganwadi worker is trained",
            "Regarding learn process",
            "Anganwadi worker are aware in which year anganwadi was started",
            "Anganwadi center floor is in good shape",
            "Role & responsibility of the BVS member list is maintained",
            "Cook / chef are clean",
            "Items in the first aid box is in use",
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
