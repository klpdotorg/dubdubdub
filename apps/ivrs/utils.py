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

def skip_questions(state, number=None):
    state.answers.append('No')
    state.save()
    for i in range(0,number):
        state.answers.append('NA')
        state.question_number = F('question_number') + 1
        state.save()
    state.question_number = F('question_number') + 1
    state.save()
