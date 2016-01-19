from rest_framework import status

from schools.models import BoundaryType
from stories.models import (
    Question, Questiongroup
)

GKA_SERVER = "08039591332"
GKA_DEV = "08039510185"
PRI = "08039236431"
PRE = "08039510414"

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
    if ivrs_type == GKA_SERVER or ivrs_type == GKA_DEV:
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

    return status_code


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
