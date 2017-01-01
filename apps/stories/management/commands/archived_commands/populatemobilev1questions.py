from datetime import datetime

from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import (
    BoundaryType,
    Partner,
    School
)
from stories.models import (
    Question,
    QuestionType,
    Questiongroup,
    QuestiongroupQuestions,
    Survey,
    Source,
    UserType
)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Mobile v1 questions

    ./manage.py populatemobilev1questions"""

    @transaction.atomic
    def handle(self, *args, **options):
        partner = Partner.objects.get(
            name="Akshara Foundation"
        )
        survey, created = Survey.objects.get_or_create(
            name="Community",
            partner=partner
        )
        source, created = Source.objects.get_or_create(
            name="mobile"
        )

        start_date = datetime.strptime('2016-06-01', '%Y-%m-%d')

        question_group, created = Questiongroup.objects.get_or_create(
            version=1,
            source=source,
            survey=survey,
            start_date=start_date,
            status=Questiongroup.ACTIVE_STATUS
        )

        question_type = QuestionType.objects.get(
            name="checkbox"
        )
        school_type = BoundaryType.objects.get(
            name="Primary School"
        )
        user_type, created = UserType.objects.get_or_create(
            name=UserType.AKSHARA_STAFF
        )

        q1 = Question.objects.get(
            text="Have you visited your child's school in the last month?"
        )
        q2 = Question.objects.get(
            text="Does the school have a separate functional toilet for girls?"
        )
        q3 = Question.objects.get(
            text="Are you satisfied with the MDM served in your child's school?"
        )
        q3.text = "Are you satisfied with the Mid Day Meal served in your child's school?"
        q3.save()
        q4 = Question.objects.get(
            text="Is there a teacher shortage in the school?"
        )
        q5 = Question.objects.get_or_create(
            text="Does the SDMC meet every month?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]
        q6 = Question.objects.get(
            text="Do you think your child can read Kannada?"
        )
        q7 = Question.objects.get(
            text="Do you think your child can read English?"
        )
        q8 = Question.objects.get(
            text="Do you think your child can do addition?"
        )
        q9 = Question.objects.get(
            text="Do you think your child can do subtraction?"
        )
        q10 = Question.objects.get_or_create(
            text="Did you participate in 'Sammudaya Datta Shaale' last time?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{'Yes','No'}",
        )[0]

        questions = [q1, q2, q3, q4, q5, q6, q7,
                     q8, q9, q10]

        print questions

        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group,
                question=question,
                sequence=count+1
            )

        print "Community mobile v1 questions populated."
