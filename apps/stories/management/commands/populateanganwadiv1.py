from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi V1 questions

    ./manage.py populateanganwadiv1"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="community")[0]
        start_date = datetime.strptime('2013-06-04', '%Y-%m-%d')
        end_date = datetime.strptime('2014-05-30', '%Y-%m-%d')
        q = Questiongroup.objects.get_or_create(
            version=3,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        q1 = Question.objects.get_or_create(
            text="This Anganwadi has its own building & it was in good condition.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q2 = Question.objects.get_or_create(
            text="To preserve the food material in the anganwadi separate room is available.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q3 = Question.objects.get_or_create(
            text="The children have maintained class room neatly.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q4 = Question.objects.get_or_create(
            text="In the Anganwadi there is drinking water & usage water facility and it was neat.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q5 = Question.objects.get_or_create(
            text="Toilet is in good condition to use.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q6 = Question.objects.get_or_create(
            text="Is sufficient places available inside & outside of the anganwadi center for any educational activities?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q7 = Question.objects.get_or_create(
            text="50% of attendence was there at the time of visit.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q8 = Question.objects.get_or_create(
            text="Children are able to write on the black board.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q9 = Question.objects.get_or_create(
            text="TLM kit is available at the anganwadi center.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q10 = Question.objects.get_or_create(
            text="Is wall writing and charts related to learning material available for center?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q11 = Question.objects.get_or_create(
            text="Anganwadi worker used Akshara learning materiel on the day of visit.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q12 = Question.objects.get_or_create(
            text="Anaganwadi worker was involving all children in to the activities.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q13 = Question.objects.get_or_create(
            text="Anaganwadi worker helps akshara worker involve in all programmes.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q14 = Question.objects.get_or_create(
            text="The BVS member list is maintained in the center.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q15 = Question.objects.get_or_create(
            text="Anganwadi friendship group is formed.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q16 = Question.objects.get_or_create(
            text="Has the anganwadi worker done evaluation on children's learning till now?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q17 = Question.objects.get_or_create(
            text="Friends of anganwadi are continuously involved.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q18 = Question.objects.get_or_create(
            text="Anaganwadi worker & helper had a mutual understanding.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q19 = Question.objects.get_or_create(
            text="BVS is involved in all the anganwadi activities.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q20= Question.objects.get_or_create(
            text="For question asked by visitor, children are actively answering.",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]

        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q1, sequence=1)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q2, sequence=2)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q3, sequence=3)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q4, sequence=4)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q5, sequence=5)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q6, sequence=6)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q7, sequence=7)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q8, sequence=8)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q9, sequence=9)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q10, sequence=10)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q11, sequence=11)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q12, sequence=12)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q13, sequence=13)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q14, sequence=14)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q15, sequence=15)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q16, sequence=16)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q17, sequence=17)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q18, sequence=18)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q19, sequence=19)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q20, sequence=20)

        print "Anganwadi V1 questions populated."
