from datetime import datetime

from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import (
    Partner,
)
from stories.models import (
    Question,
    Questiongroup,
    QuestiongroupQuestions,
    Survey,
    Source,
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
        survey = Survey.objects.get(
            name="Community",
            partner=partner
        )
        source, created = Source.objects.get_or_create(
            name="csv"
        )

        start_date = datetime.strptime('2016-06-01', '%Y-%m-%d')

        question_group, created = Questiongroup.objects.get_or_create(
            version=1,
            source=source,
            survey=survey,
            start_date=start_date,
            status=Questiongroup.ACTIVE_STATUS
        )

        q1 = Question.objects.get(
            text="Have you visited your child's school in the last month?"
        )
        q2 = Question.objects.get(
            text="Does the school have a separate functional toilet for girls?"
        )
        q3 = Question.objects.get(
            text="Are you satisfied with the Mid Day Meal served in your child's school?"
        )
        q4 = Question.objects.get(
            text="Is there a teacher shortage in the school?"
        )
        q5 = Question.objects.get(
            text="Does the SDMC meet every month?",
        )
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
        q10 = Question.objects.get(
            text="Did you participate in 'Sammudaya Datta Shaale' last time?",
        )

        questions = [q1, q2, q3, q4, q5, q6, q7,
                     q8, q9, q10]

        print questions

        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group,
                question=question,
                sequence=count+1
            )

        print "Community mobile v1 csv questions populated."
