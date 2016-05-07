from datetime import datetime, timedelta

from django.db import transaction
from django.core.management.base import BaseCommand

from ivrs.models import State
from schools.models import School
from ivrs.utils import get_question
from common.utils import post_to_slack
from stories.models import Story, UserType, Questiongroup, Answer

PRI = "08039236431"
GKA_SMS = "08039514048"
GKA_SERVER = "08039591332"
# PRE = "08039510414" - Not implemented.

class Command(BaseCommand):
    args = ""
    help = """Analyzes the GKA IVRS/SMS states and saves stories.

    ./manage.py fetchgkaivrs"""

    @transaction.atomic
    def handle(self, *args, **options):
        question_group_version_dict = {
            # Corresponds to version numbers of the Questiongroups
            # with source names 'ivrs' and 'sms' within stories app.
            'gka' : 2,
            'gka-new' : 4,
            'gka-v3' : 5,
            'ivrs-pri' : 3,
            'gka-sms': 1,
            # 'ivrs-pre' : 999 - Not implemented.
        }

        for ivrs_type, version in question_group_version_dict.items():
            self.process_state(ivrs_type, version)

    def process_state(self, ivrs_type, version):
        valid_count = 0 # For posting daily notifications to slack.
        invalid_count = 0
        # fifteen_minutes = datetime.now() - timedelta(minutes=15)

        if ivrs_type == 'gka-sms':
            source_name = 'sms'
        else:
            source_name = 'ivrs'

        ivrs_type_number_dict = {
            'gka' : GKA_SERVER,
            'gka-new' : GKA_SERVER,
            'gka-v3' : GKA_SERVER,
            'ivrs-pri' : PRI,
            'gka-sms' : GKA_SMS,
            # 'ivrs-pre' : PRE, - Not implemented.
        }

        states = State.objects.filter(
            ivrs_type=ivrs_type,
            is_processed=False,
            # date_of_visit__lte=fifteen_minutes
        )

        for state in states:
            if not sane_state(state, ivrs_type):
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
                    version=version,
                    source__name=source_name
                )
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
                            ivrs_type_number_dict[ivrs_type]
                        )
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=answer
                        )
                valid_count += 1

            state.is_processed = True
            state.save()

        if ivrs_type == 'gka-v3':
            author = 'GKA IVRS'
            emoji = ':calling:'
        elif ivrs_type == 'gka-sms':
            author = 'GKA SMS'
            emoji = ':memo:'
        elif ivrs_type == 'ivrs-pri':
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

def sane_state(state, ivrs_type):
    # A State is not sane if it has:
    # 1. No answers for any questions. (For GKA and MAHITI)
    # 2. An answer to the 2nd question, 'class visited',
    # but no answers thereafter (Only for GKA).

    SANE, NOT_SANE = True, False

    # Checking condition 1.
    if all(answer == 'NA' for answer in state.answers[1:]):
        return NOT_SANE
    # Checking condition 2.
    if ivrs_type in ['gka', 'gka-new', 'gka-v3']:
        if state.answers[2] != 'NA':
            if all(answer == 'NA' for answer in state.answers[3:]):
                return NOT_SANE
    if ivrs_type == 'gka-sms':
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
