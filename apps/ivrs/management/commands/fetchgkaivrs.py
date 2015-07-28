from datetime import datetime, timedelta

from django.core.management.base import BaseCommand

from ivrs.models import State
from stories.models import Story, UserType, Questiongroup, Answer

class Command(BaseCommand):
    args = ""
    help = """Analyzes the GKA IVRS states and saves stories.

    ./manage.py fetchgkaivrs"""

    @transaction.atomic
    def handle(self, *args, **options):
        fifteen_minutes = datetime.now() - timedelta(minutes=15)
        states = State.objects.filter(
            is_processed=False,
            date_of_visit__lte=fifteen_minutes
        )
        if states:
            for state in states:
                if not sane_state(state):
                    continue
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

                    for (question_number, answer) in enumerate(state.answers):
                        if answer != 'NA':
                            question = get_question(question_number+1)
                            answer = Answer.objects.get_or_create(
                                story=story,
                                question=question,
                                text=answer
                            )

                state.is_processed = True
                state.save()

def sane_state(state):
    # A State is not sane if it has:
    # 1. No answers for any questions.
    # 2. An answer to the 2nd question (class visited),
    # but no answers thereafter

    NOT_SANE = False
    SANE = True

    # Checking condition 1.
    if all(answer == 'NA' for answer in state.answers[1:]):
        return NOT_SANE
    # Checking condition 2.
    elif state.answers[2] != 'NA':
        if all(answer == 'NA' for answer in state.answers[2:]):
            return NOT_SANE
    else:
        return SANE
