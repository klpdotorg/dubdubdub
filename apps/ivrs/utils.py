import datetime

from rest_framework import status

from django.utils import timezone

from .models import State

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup
)

# Exotel numbers. Find them at http://my.exotel.in/viamentis/apps#installed-apps
PRI = "08039236431"
PRE = "08039510414"
GKA_DEV = "08039510185"
GKA_SMS = "08039514048"
GKA_SERVER = "08039591332"


def get_date(date):
    date = datetime.datetime.strptime(
        date, '%Y-%m-%d %H:%M:%S'
    )
    date = timezone.make_aware(
        date, timezone.get_current_timezone()
    )
    return date


def check_school(state, school_id):
    school_type = None

    if not school_id:
        status_code = status.HTTP_404_NOT_FOUND
        message = "School ID not entered"

    elif School.objects.filter(id=school_id).exists():
        state.school_id = school_id
        school_type = School.objects.filter(
            id=school_id
        ).values(
            'admin3__type__name'
        )[0]['admin3__type__name']

    else:
        status_code = status.HTTP_404_NOT_FOUND
        message = "School ID not found"

    # Validating whether the entered school ID corresponds to the
    # correct school_type. Assigns the ivrs_type based on the call
    # number as well.
    if school_type:
        if ivrs_type in [GKA_SERVER, GKA_SMS, GKA_DEV]:
            if school_type != u'Primary School':
                status_code = status.HTTP_404_NOT_FOUND
                message = "Please enter Primary School ID"
            state.ivrs_type = 'gka-v3'
            # Initializing answer slots 1 to 10 with NA
            for i in range(0, 10):
                state.answers.append('NA')

        elif ivrs_type == PRI:
            if school_type != u'Primary School':
                status_code = status.HTTP_404_NOT_FOUND
                message = "Please enter Primary School ID"
            state.ivrs_type = 'ivrs-pri'
            # Initializing answer slots 1 to 6 with NA
            for i in range(0, 6):
                state.answers.append('NA')

        # ivrs_type == PRE
        else:
            if school_type != u'PreSchool':
                status_code = status.HTTP_404_NOT_FOUND
                message = "Please enter PreSchool ID"
            state.ivrs_type = 'ivrs-pre'
            # Initializing answer slots 1 to 6 with NA
            for i in range(0, 6):
                state.answers.append('NA')

    state.save()
    return (state, status_code, message)


def verify_answer(session_id, question_number, response):
    if State.objects.filter(session_id=session_id).exists():
        state = State.objects.get(session_id=session_id)

        status_code = status.HTTP_200_OK
        question_number = int(question_number)
        question = get_question(question_number, ivrs_type)

        if response:
            response = int(response.strip('"'))

            # Mapping integers to Yes/No.
            accepted_answers = {1: 'Yes', 2: 'No'}
            if question.question_type.name == 'checkbox' and response in accepted_answers:
                if question_number == 1 and (ivrs_type in [GKA_SERVER, GKA_SMS, GKA_DEV]):
                    # This special case is there for question 1 which clubs "Was the school
                    # open?" and "Class visited". Since "Class visited accepts answers from
                    # 1 tp 8, we can't cast "1" and "2" to "yes" and "no". The answer to
                    # whether the school was open or not is handled in the save_answer
                    # function within utils.py
                    response = response
                else:
                    response = accepted_answers[response]

            # Save the answer.
            state, status_code = save_answer(
                state, question_number, question, ivrs_type, response
            )

        else:
            status_code = status.HTTP_404_NOT_FOUND
    else:
        status_code = status.HTTP_404_NOT_FOUND

    if status_code == status.HTTP_404_NOT_FOUND:
        message = "Error in data"
    else:
        message = "Data accepted"

    return (state, status_code, message)


# GKA v3 questions are at https://github.com/klpdotorg/dubdubdub/issues/549#issuecomment-170913566
# We special case question Q1 and question Q5. Q1 should be split into Q1 and Q2. Q5 should
# be split into Q5, Q6 and Q7.
# DISCLAIMER: There is no neat way of doing this. Beware of the mess below!
def save_answer(state, question_number, question, ivrs_type, response):
    # Perform sanity check for GKA & PRI. PRE (old ivrs) only
    # has checkbox and numeric as answers types. Answers other
    # than 1 or 2 are already moderated on the exotel end. The
    # numeric answers cannot be moderated for the old ivrs.
    status_code = status.HTTP_200_OK
    if ivrs_type in [GKA_SERVER, GKA_SMS, GKA_DEV]:
        if question_number == 1: # Question 1 & 2 based on responses.
            if response == 0:
                # Q1. School is closed.
                state.answers[question_number] = 'No'
            elif response in range(1, 9):
                # Q1. School is open.
                state.answers[question_number] = 'Yes'
                # Q2. Class visited.
                state.answers[question_number + 1] = response
            else:
                status_code = status.HTTP_404_NOT_FOUND

        elif question_number == 5: # Question 5, 6 & 7 based on responses.
            if response == 99:
                # Q5. TLM is not being used.
                state.answers[question_number] = 'No'
                # Q7. Multiple TLMs are not being used.
                state.answers[question_number + 2] = 'No'
            elif response in range(1, 22):
                # Q5. TLM is being used.
                state.answers[question_number] = 'Yes'
                # Q6. TLM code
                state.answers[question_number + 1] = response
                # Q7. Multiple TLMs are not being used.
                state.answers[question_number + 2] = 'No'
            elif response == 55:
                # Q5. TLM is being used.
                state.answers[question_number] = 'Yes'
                # Q7. Multiple TLMs are being used.
                state.answers[question_number + 2] = 'Yes'
            else:
                status_code = status.HTTP_404_NOT_FOUND

        else:
            if response in eval(question.options):
                state.answers[question_number] = response
            else:
                status_code = status.HTTP_404_NOT_FOUND

    elif ivrs_type == PRI:
        if response in eval(question.options):
            state.answers[question_number] = response
        else:
            status_code = status.HTTP_404_NOT_FOUND
    else:
        state.answers[question_number] = response

    state.save()

    return (state, status_code)


def get_question(question_number, ivrs_type):
    if ivrs_type == GKA_DEV or ivrs_type == GKA_SERVER:
        question_group = Questiongroup.objects.get(
            version=5,
            source__name='ivrs'
        )
        school_type = BoundaryType.objects.get(name="Primary School")
    elif ivrs_type == PRI:
        question_group = Questiongroup.objects.get(
            version=3,
            source__name='ivrs'
        )
        school_type = BoundaryType.objects.get(name="Primary School")
    else: # ivrs_type == PRE
        question_group = Questiongroup.objects.get(
            version=999, # To be implemented.
            source__name='ivrs'
        )
        school_type = BoundaryType.objects.get(name="PreSchool")

    question = Question.objects.get(
        school_type=school_type,
        questiongroup=question_group,
        questiongroupquestions__sequence=question_number,
    )

    return question
