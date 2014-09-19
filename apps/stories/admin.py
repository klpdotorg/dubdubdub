from django.contrib import admin

from .models import (Answer, Question, Questiongroup, QuestiongroupQuestions,
    QuestionType, Source, Story, StoryImage)

admin.site.register([Answer, Question, Questiongroup, QuestiongroupQuestions,
    QuestionType, Source, Story, StoryImage])
