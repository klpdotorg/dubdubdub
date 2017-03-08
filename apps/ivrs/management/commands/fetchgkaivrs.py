from datetime import datetime, timedelta

from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import School
from ivrs.utils import get_question
from common.utils import post_to_slack
from ivrs.models import State, QuestionGroupType
from stories.models import Story, UserType, Questiongroup, Answer

class Command(BaseCommand):
    args = ""
    help = """Analyzes the IVRS/SMS states and saves stories.

    ./manage.py fetchgkaivrs"""

    @transaction.atomic
    def handle(self, *args, **options):
        qg_types = QuestionGroupType.objects.filter(is_active=True)
        for qg_type in qg_types:
            self.process_state(qg_type)

    def process_state(self, qg_type):
        states = State.objects.filter(
            qg_type=qg_type,
            is_processed=False,
        )

        valid_count = states.filter(is_invalid=False).count()
        invalid_count = states.filter(is_invalid=True).count()

        for state in states:
            state.is_processed = True
            state.save()

            if state.is_invalid:
                continue

            school = School.objects.get(id=state.school_id)
            telephone = state.telephone
            date = state.date_of_visit
            akshara_staff = UserType.objects.get_or_create(
                name=UserType.AKSHARA_STAFF
            )[0]
            question_group = qg_type.questiongroup
            story = Story.objects.create(
                school=school,
                is_verified=True,
                group=question_group,
                date_of_visit=date,
                telephone=telephone,
                user_type=akshara_staff
            )
            for (question_number, answer) in enumerate(state.answers[1:]):
                if answer != 'NA':
                    question = get_question(
                        question_number+1,
                        qg_type.questiongroup
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer
                    )

        if qg_type.name == 'gkav4':
            author = 'GKA SMS'
            emoji = ':memo:'
        else:
            author = None

        if author:
            try:
                post_to_slack(
                    channel='#klp',
                    author=author,
                    message='%s Valid calls & %s Invalid calls' %(valid_count, invalid_count),
                    emoji=emoji,
                )
            except:
                pass
