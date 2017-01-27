from datetime import datetime

from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Community v4 questions

    ./manage.py populatecommunitydatav4"""

    @transaction.atomic
    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="community")[0]
        start_date = datetime.strptime('2015-06-01', '%Y-%m-%d')
        qg_community_v2 = Questiongroup.objects.get(
            version=2, 
            source__name='community'
        )
        qg_ivrs = Questiongroup.objects.get(
            version=2, 
            source__name='ivrs'
        )
        qg_community_v4 = Questiongroup.objects.get_or_create(
            version=4,
            source=s,
            start_date=start_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="Primary School")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        q1 = Question.objects.get_or_create(
            text="Have you visited your child's school in the last month?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q2 = Question.objects.get(
            questiongroup=qg_ivrs,
            text="Are all the toilets in the school functional?",
        )
        q3 = Question.objects.get(
            questiongroup=qg_ivrs,
            text="Does the school have a separate functional toilet for girls?",
        )
        q4 = Question.objects.get(
            questiongroup=qg_ivrs,
            text="Does the school have drinking water?",
        )
        q5 = Question.objects.get(
            questiongroup=qg_ivrs,
            text="Is a Mid Day Meal served in the school?",
        )
        q6 = Question.objects.get_or_create(
            text="Are you satisfied with the MDM served in your child's school?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q7 = Question.objects.get(
            questiongroup=qg_community_v2,
            text="Are the teachers regular?",
        )
        q8 = Question.objects.get(
            questiongroup=qg_community_v2,
            text="Do teacher take classes regularly?",
        )
        q9 = Question.objects.get_or_create(
            text="Is there a teacher shortage in the school?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q10 = Question.objects.get_or_create(
            text="Is SDMC functioning effectively in the school?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q11 = Question.objects.get_or_create(
            text="Do you think your child can read Kannada?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q12 = Question.objects.get_or_create(
            text="Do you think your child can read English?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q13 = Question.objects.get_or_create(
            text="Do you think your child can do addition?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q14 = Question.objects.get_or_create(
            text="Do you think your child can do subtraction?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q15 = Question.objects.get_or_create(
            text="Do you check your childs progess card regularly?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q16 = Question.objects.get_or_create(
            text="Do you send your child for private tution?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q17 = Question.objects.get_or_create(
            text="Do you think Govt schools are better than Private schools?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]

        questions = [q1, q2, q3, q4, q5, q6, q7,
                     q8, q9, q10, q11, q12, q13,
                     q14, q15, q16, q17]

        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=qg_community_v4,
                question=question,
                sequence=count+1
            )

        print "Community data v4 questions populated."
