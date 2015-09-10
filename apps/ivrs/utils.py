from schools.models import BoundaryType
from stories.models import (
    Question, Questiongroup
)

GKA_SERVER = "08039591332"
GKA_DEV = "08039510185"
PRI = "08039236431"
PRE = "08039510414"

def get_question(question_number, ivrs_type):
    if ivrs_type == GKA_DEV or ivrs_type == GKA_SERVER:
        question_group = Questiongroup.objects.get(
            version=2,
            source__name='ivrs'
        )
        school_type = BoundaryType.objects.get(name="Primary School")
    elif ivrs_type == PRI:
        question_group = Questiongroup.objects.get(
            version=3,
            source__name='ivrs'
        )
        school_type = BoundaryType.objects.get(name="Primary School")
    else:
        question_group = Questiongroup.objects.get(
            version=1,
            source__name='ivrs'
        )
        school_type = BoundaryType.objects.get(name="PreSchool")

    question = Question.objects.get(
        school_type=school_type,
        questiongroup=question_group,
        questiongroupquestions__sequence=question_number,
    )

    return question
