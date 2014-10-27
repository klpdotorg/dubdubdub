from django.contrib import admin

from .models import (Answer, Question, Questiongroup, QuestiongroupQuestions,
                     QuestionType, Source, Story, StoryImage)


class AnswerInline(admin.StackedInline):
    model = Answer
    extra = 0
    readonly_fields = ('question',)


class StoryImageInline(admin.StackedInline):
    model = StoryImage
    extra = 0
    readonly_fields = ('image', 'image_tag')


class StoryAdmin(admin.ModelAdmin):
    list_display = ('__unicode__', 'is_verified',)
    list_editable = ('is_verified',)
    list_filter = ('is_verified',)
    raw_id_fields = ('school',)
    inlines = [AnswerInline, StoryImageInline]


admin.site.register([Answer, Question, Questiongroup, QuestiongroupQuestions,
                    QuestionType, Source, StoryImage])

admin.site.register(Story, StoryAdmin)
