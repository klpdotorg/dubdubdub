from django.db.models import F

from stories.models import (
    Question, Questiongroup
)

GKA = "08039510185"
PRI = "08039236431"
PRE = "08039510414"

def get_question(question_number, ivrs_type):
    if ivrs_type == GKA:
        question_group = Questiongroup.objects.get(
            version=2,
            source__name='ivrs'
        )
    else:
        question_group = Questiongroup.objects.get(
            version=1,
            source__name='ivrs'
        )
    question = Question.objects.get(
        questiongroup=question_group,
        questiongroupquestions__sequence=question_number,
    )

    return question
