from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi Mallur questions

    ./manage.py populateanganwadimallur"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        start_date = datetime.strptime('2013-08-06', '%Y-%m-%d')
        end_date = datetime.strptime('2014-12-30', '%Y-%m-%d')
        q = Questiongroup.objects.get_or_create(
            version=2,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        q1 = Question.objects.get_or_create(
            text="In which year anganwadi was started?",
            data_type=1,
            user_type=user_type,
            question_type=QuestionType.objects.get(name="numeric"),
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q2 = Question.objects.get_or_create(
            text="Was anganwadi worker present on time during visit?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q3 = Question.objects.get_or_create(
            text="Was anganwadi helper present on time during visit?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q4 = Question.objects.get_or_create(
            text="Center is functioning with the women & children development dept",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q5 = Question.objects.get_or_create(
            text="The floor is in good condition",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q6 = Question.objects.get_or_create(
            text="The roof is in good condition",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q7 = Question.objects.get_or_create(
            text="Doors are strong & can be bolted & locked",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q8 = Question.objects.get_or_create(
            text="All the Window panes are strong and can be locked",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q9 = Question.objects.get_or_create(
            text="No dust & spider web is found in the center room",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q10 = Question.objects.get_or_create(
            text="Anganwadi walls are painted with learning subject",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q11 = Question.objects.get_or_create(
            text="Learning charts are there in the anganwadi center",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q12 = Question.objects.get_or_create(
            text="There is Dustbin in the center",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q13 = Question.objects.get_or_create(
            text="Dustbin is used by children",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q14 = Question.objects.get_or_create(
            text="Children have learnt to keep center room clean",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q15 = Question.objects.get_or_create(
            text="Store room is maintained to preserve food items",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q16 = Question.objects.get_or_create(
            text="Store room is clean",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q17 = Question.objects.get_or_create(
            text="Food for daily use is covered properly",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q18 = Question.objects.get_or_create(
            text="Morning food was distributed at the time of visit (mention the time)",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q19 = Question.objects.get_or_create(
            text="Afternoon food was distributed at the time of visit (mention the time)",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q20 = Question.objects.get_or_create(
            text="Cook / chef are clean",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q21 = Question.objects.get_or_create(
            text="Separate place is maintained for hand wash after lunch",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q22 = Question.objects.get_or_create(
            text="Water tap's are there at anganwadi center",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q23 = Question.objects.get_or_create(
            text="There is water supply through taps",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q24 = Question.objects.get_or_create(
            text="Surrounding areas near the tap is clean",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q25 = Question.objects.get_or_create(
            text="Drinking water is stored in clean vessel",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q26 = Question.objects.get_or_create(
            text="Vessel are always closed to avoid children placing hand",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q27 = Question.objects.get_or_create(
            text="There is toilet in the center",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q28 = Question.objects.get_or_create(
            text="Toilet roof is maintained to avoid sun/rain",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q29 = Question.objects.get_or_create(
            text="There is water facility in the toilet",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q30 = Question.objects.get_or_create(
            text="Jug is easily available to children in the toilet",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q31 = Question.objects.get_or_create(
            text="Algae is not found in toilet basin",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q32 = Question.objects.get_or_create(
            text="Necessary items are available in the first aid box",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q33 = Question.objects.get_or_create(
            text="Items in the first aid box is in use",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q34 = Question.objects.get_or_create(
            text="Center has black board",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q35 = Question.objects.get_or_create(
            text="Children are able to write on the black board",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q36 = Question.objects.get_or_create(
            text="Children register book is maintained by anganwadi worker",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q37 = Question.objects.get_or_create(
            text="Every day children attendence is confirmed in the register by anganwadi worker through signature",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q38 = Question.objects.get_or_create(
            text="Anganwadi worker has marked the last year 6yrs completed children name (each children details according to name)",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q39 = Question.objects.get_or_create(
            text="50% of attendence was there at the time of visit",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q40 = Question.objects.get_or_create(
            text="Children progress card maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q41 = Question.objects.get_or_create(
            text="Teacher dairy is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q42 = Question.objects.get_or_create(
            text="Staff attendance & other information is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q43 = Question.objects.get_or_create(
            text="Accounting records is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q44 = Question.objects.get_or_create(
            text="Learning material record is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q45 = Question.objects.get_or_create(
            text="Children medical report is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q46 = Question.objects.get_or_create(
            text=" Medical check done within 3 months",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q47 = Question.objects.get_or_create(
            text="Children list of special need is available",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q48 = Question.objects.get_or_create(
            text="Ramp facility is available for handicaps",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q49 = Question.objects.get_or_create(
            text="Learning material available for handicap children in the center",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q50 = Question.objects.get_or_create(
            text="Workers are trained to teach handicap children",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q51 = Question.objects.get_or_create(
            text="BVS is available",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q52 = Question.objects.get_or_create(
            text="List of BVS member is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q53 = Question.objects.get_or_create(
            text="BVS book is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q54 = Question.objects.get_or_create(
            text="Role & responsibility of the BVS member list is maintained",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q55 = Question.objects.get_or_create(
            text="BVS is functioning as per the rules & regulation",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q56 = Question.objects.get_or_create(
            text="Anganwadi worker is trained about pre school",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q57 = Question.objects.get_or_create(
            text="Pre school start time",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q58 = Question.objects.get_or_create(
            text="Pre school end time",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q59 = Question.objects.get_or_create(
            text="Weekly TLM plan organized in the anganwadi center",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q60 = Question.objects.get_or_create(
            text="List the anganwadi center TLM",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q61 = Question.objects.get_or_create(
            text="Anganwadi worker cooperates with children",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q62 = Question.objects.get_or_create(
            text="Anganwadi worker and helper have mutual understanding",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q63 = Question.objects.get_or_create(
            text="Children are involved in activity with the TLM",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q64 = Question.objects.get_or_create(
            text="Anganwadi workers are observing the children activities",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q65 = Question.objects.get_or_create(
            text="Angnawadi workers are using the TLM to children learning",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q66 = Question.objects.get_or_create(
            text="TLM meterial are dependable and effective in using & learning",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q67 = Question.objects.get_or_create(
            text="Children actively answer the questions asked by visitor",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]

        questions = [q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13,
                     q14, q15, q16, q17, q18, q19, q20, q21, q22, q23, q24,
                     q25, q26, q27, q28, q29, q30, q31, q32, q33, q34, q35,
                     q36, q37, q38, q39, q40, q41, q42, q43, q44, q45, q46,
                     q47, q48, q49, q50, q51, q52, q53, q54, q55, q56, q57,
                     q58, q59, q60, q61, q62, q63, q64, q65, q66, q67]

        for count, question in enumerate(questions): 
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=q, question=question, sequence=count+1)

        print "Anganwadi Mallur questions populated."
