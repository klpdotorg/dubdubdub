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
# We special case question 1 and question 5, because 1 should be split into 1 and 2. Then 5 should
# be split into 5, 6 and 7.


def save_answer(question, ivrs_type, response):
    # Perform sanity check for GKA & PRI. PRE (old ivrs) only
    # has checkbox and numeric as answers types. Answers other
    # than 1 or 2 are already moderated on the exotel end. The
    # numeric answers cannot be moderated for the old ivrs.
    status_code = status.HTTP_200_OK
    if ivrs_type == GKA_SERVER or ivrs_type == PRI or ivrs_type == GKA_DEV:
        if response in eval(question.options):
            state.answers[int(question_number)] = response
            state.save()
        else:
            status_code = status.HTTP_404_NOT_FOUND
    else:
        state.answers[int(question_number)] = response
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
