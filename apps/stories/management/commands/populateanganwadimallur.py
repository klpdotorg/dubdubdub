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
            "Was anganwadi worker present on time during visit",
            "Was anganwadi helper present on time during visit",
            "Center is functioning with the women & children development dept.",
            "Suficient place in the anganwadi center",
            "There is space in and out of anganwadi center to conduct pre education activity",
            "Playground is big enough for chidren to play",
            "Anganwadi playground is filled with grass plant & tree",
            "Walls of the anganwadi room are in good condition",
            "The floor is in good condition",
            "The roof is in good condition",
            "Doors are strong & can be bolted & locked",
            "All the Window panes are strong and can be locked",
            "No dust & spider web is found in the center room",
            "Anganwadi walls are painted with learning subject",
            "Learning charts are there in the anganwadi center",
            "There is Dustbin in the center",
            "Dustbin is used by children",
            "Children have learnt to keep center room clean",
            "Store room is maintained to preserve food items",
            "Store room is clean",
            "Food for daily use is covered properly",
            "Morning food was distributed at the time of visit (mention the time)",
            "Afternoon food was distributed at the time of visit (mention the time)",
            "Cook / chef are clean",
            "Separate place is maintained for hand wash after lunch",
            "Water tap's are there at anganwadi center",
            "There is water supply through taps",
            "Surrounding areas near the tap is clean",
            "Drinking water is stored in clean vessel",
            "Vessel are always closed to avoid children placing hand",
            "There is toilet in the center",
            "Toilet roof is maintained to avoid sun/rain",
            "There is water facility in the toilet",
            "Jug is easily available to children in the toilet",
            "Algae is not found  in toilet basin",
            "Necessary items are available in the first aid box",
            "Items in the first aid box is in use",
            "Center has black board",
            "Children are able to write on the black board",
            "Children register book is maintained by anganwadi worker",
            "Every day children attendence is confirmed in the register by anganwadi worker through signature",
            "Anganwadi worker has marked the last year 6yrs completed children name (each children details according to name)",
            "50% of attendence was there at the time of visit",
            "Children progress card maintained",
            "Teacher dairy is maintained",
            "Staff attendance & other information is maintained",
            "Accounting records is maintained",
            "Learning material record is maintained",
            "Children medical report is maintaind",
            "Medical check done within 3 months",
            "Children list of special need is available",
            "Ramp facility is available for handicaps",
            "Learning material available for handicap children in the center",
            "Workers are trained to teach handicap children",
            "BVS is available",
            "List of BVS member is maintained",
            "BVS book is maintained",
            "Role & responsibility of the BVS member list is maintained",
            "BVS is functioning as per the rules & regulation",
            "Anganwadi worker is trained about pre school",
            "Pre school start time",
            "Pre school end time",
            "Weakly TLM plan organized in the anganwadi center",
            "List the anganwadi center TLM",
            "Anganwadi worker cooperates with children",
            "Anganwadi worker and helper have mutual understading",
            "Children are involved in activity with the TLM",
            "Anganwadi workers are observing the children activities",
            "Angnawadi workers are using the TLM to children learning",
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
