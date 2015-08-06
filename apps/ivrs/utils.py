from django.db.models import F

from stories.models import (
    Question, Questiongroup
)

def get_question(question_number):
    question_group = Questiongroup.objects.get(
        version=2,
        source__name='ivrs'
    )
    question = Question.objects.get(
        questiongroup=question_group,
        questiongroupquestions__sequence=question_number,
    )

    return question
