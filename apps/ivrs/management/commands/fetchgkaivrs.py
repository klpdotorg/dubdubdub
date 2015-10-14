from datetime import datetime, timedelta

from django.db import transaction
from django.core.management.base import BaseCommand

from ivrs.models import State
from schools.models import School
from ivrs.utils import get_question
from common.utils import post_to_slack
from stories.models import Story, UserType, Questiongroup, Answer

GKA_SERVER = "08039591332"

class Command(BaseCommand):
    args = ""
    help = """Analyzes the GKA IVRS states and saves stories.

    ./manage.py fetchgkaivrs"""

    @transaction.atomic
    def handle(self, *args, **options):
        valid_count = 0 # For posting daily notifications to slack.
        invalid_count = 0
        fifteen_minutes = datetime.now() - timedelta(minutes=15)
        states = State.objects.filter(
            ivrs_type='gka',
            is_processed=False,
            date_of_visit__lte=fifteen_minutes
        )
        if states:
            for state in states:
                if not sane_state(state):
                    state.is_invalid = True
                    invalid_count += 1
                else:
                    school = School.objects.get(id=state.school_id)
                    telephone = state.telephone
                    date = state.date_of_visit
                    akshara_staff = UserType.objects.get_or_create(
                        name=UserType.AKSHARA_STAFF
                    )[0]
                    question_group = Questiongroup.objects.get(
                        version=2,
                        source__name='ivrs'
                    )

                    story = Story.objects.create(
                        school=school,
                        group=question_group,
                        date_of_visit=date,
                        telephone=telephone,
                        user_type=akshara_staff
                    )

                    for (question_number, answer) in enumerate(state.answers[1:]):
                        if answer != 'NA':
                            question = get_question(question_number+1, GKA_SERVER)
                            answer = Answer.objects.get_or_create(
                                story=story,
                                question=question,
                                text=answer
                            )

                    valid_count += 1

                state.is_processed = True
                state.save()

        try:
            post_to_slack(
                channel='#klp',
                author='GKA IVRS',
                message='%s Valid calls & %s Invalid calls' %(valid_count, invalid_count),
                emoji=':calling:',
            )
        except:
            pass

def sane_state(state):
    # A State is not sane if it has:
    # 1. No answers for any questions.
    # 2. An answer to the 2nd question (class visited),
    # but no answers thereafter

    SANE, NOT_SANE = True, False

    # Checking condition 1.
    if all(answer == 'NA' for answer in state.answers[1:]):
        return NOT_SANE
    # Checking condition 2.
    if state.answers[2] != 'NA':
        if all(answer == 'NA' for answer in state.answers[3:]):
            return NOT_SANE

    # If not both, then sane.
    return SANE
