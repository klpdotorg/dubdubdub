from .models import (
    Question, Questiongroup
)

def get_options(question_number):
    if question_number == 2:
        return " Press 4 or 5 "
    else:
        return " Press 1 for Yes or 2 for No"

def get_question(question_number):
    question_group = Questiongroup.objects.get(
        version=2,
        source__name='ivrs'
    )
    question_number = question_number
    question = Question.objects.get(
        questiongroup=question_group
        questiongroupquestions__sequence=question_number,
    )

    return question
