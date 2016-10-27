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
        valid_count = 0 # For posting daily notifications to slack.
        invalid_count = 0

        states = State.objects.filter(
            qg_type=qg_type,
            is_processed=False,
        )

        for state in states:
            if not sane_state(state, qg_type):
                state.is_invalid = True
                invalid_count += 1
            else:
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
                valid_count += 1

            state.is_processed = True
            state.save()

        if qg_type.name == 'gkav3':
            author = 'GKA IVRS'
            emoji = ':calling:'
        elif qg_type.name == 'gkav4':
            author = 'GKA SMS'
            emoji = ':memo:'
        elif qg_type.name == 'prischoolv1':
            author = 'Primary School IVRS'
            emoji = ':calling:'
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

def sane_state(state, qg_type):
    # A State is not sane if it has:
    # 1. No answers for any questions. (For GKA and MAHITI)
    # 2. An answer to the 2nd question, 'class visited',
    # but no answers thereafter (Only for GKA).

    SANE, NOT_SANE = True, False

    # Checking condition 1.
    if all(answer == 'NA' for answer in state.answers[1:]):
        return NOT_SANE
    # Checking condition 2.
    if qg_type.name in ['gkav1', 'gkav2', 'gkav3']:
        if state.answers[2] != 'NA':
            if all(answer == 'NA' for answer in state.answers[3:]):
                return NOT_SANE
    if qg_type.name == 'gkav4':
        # If there is only 'IGNORED_INDEX' in the answers list. The answers
        # list will remain having only "IGNORED_INDEX" for every erroneous
        # sms that we receive. The error checking happens on the receipt
        # of the message itself, even before processing.
        if len(state.answers) == 1:
            return NOT_SANE
        elif len(state.answers) != 6:
            return NOT_SANE

    # If not both, then sane.
    return SANE
