from datetime import datetime

from django.db import transaction
from django.core.management.base import BaseCommand


from schools.models import (
    BoundaryType,
    Partner
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
    help = """Populate DB with GP Contest class 4,5 and 6 questions

    ./manage.py populategpcontestquestions"""

    @transaction.atomic
    def handle(self, *args, **options):
        partner = Partner.objects.get(
            name="Akshara Foundation"
        )
        survey, created = Survey.objects.get_or_create(
            name="Konnect GKA Monitoring",
            partner=partner
        )
        source, created = Source.objects.get_or_create(
            name="konnectsms"
        )

        start_date = datetime.strptime('2017-11-14', '%Y-%m-%d')

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

        q1 = Question.objects.get_or_create(
            text="Was group work happening during Math classes in class 4 and 5 at the time of your visit?",
            display_text="How many responses indicate that group work was happening in the schools visited?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No,Unknown}",
        )[0]
        q2 = Question.objects.get_or_create(
            text="Did you see the Ganitha Kalika Andolana TLM being used in class 4 or 5 at the time of your visit?",
            display_text="Did you see the Ganitha Kalika Andolana TLM being used in class 4 or 5 at the time of your visit?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No,Unknown}",
        )[0]
        q3 = Question.objects.get_or_create(
            text="Did you observe the math class happening in class 4 or 5 at the time of your visit?",
            display_text="Did you observe the math class happening in class 4 or 5 at the time of your visit?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No,Unknown}",
        )[0]
        q4 = Question.objects.get_or_create(
            text="Were the class 4 and 5 math teachers trained in GKA methodology in the school you have visited?",
            display_text="How many responses indicate that class 4 and 5 math teachers are trained in GKA methodology in the schools visited?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No,Unknown}",
        )[0]

        questions = [q1, q2, q3, q4]

        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group,
                question=question,
                sequence=count + 1
            )
