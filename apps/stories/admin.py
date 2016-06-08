from django.contrib import admin

from .models import (Answer, Question, Questiongroup, QuestiongroupQuestions,
                     QuestionType, Source, Story, StoryImage, Survey)


class AnswerInline(admin.StackedInline):
    model = Answer
    extra = 0
    readonly_fields = ('question',)


class StoryImageInline(admin.StackedInline):
    model = StoryImage
    extra = 0
    readonly_fields = ('image', 'image_tag')


class SurveyAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'partner')
    ordering = ['-created_at']


class StoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'email', 'created_at', 'school', 'is_verified',)
    list_editable = ('is_verified',)
    list_filter = ('is_verified',)
    search_fields = ('school__name',)
    raw_id_fields = ('school',)
    ordering = ['-created_at']
    inlines = [AnswerInline, StoryImageInline]
    actions = ['mark_verified']

    def get_search_results(self, request, queryset, search_term):
        """Searching school_id: By default django doesn't support integer
        search using search_fields
        """
        queryset, use_distinct = super(StoryAdmin, self).get_search_results(
            request, queryset, search_term)
        try:
            search_term_as_int = int(search_term)
        except ValueError:
            pass
        else:
            queryset |= self.model.objects.filter(school_id=search_term_as_int)
        return queryset, use_distinct

    def mark_verified(self, request, queryset):
        rows_updated = queryset.update(is_verified=True)
        if rows_updated == 1:
            story_string = 'story'
        else:
            story_string = 'stories'
        message = "%s %s marked as verified" % (rows_updated, story_string,)
        self.message_user(request, message)

    mark_verified.short_description = "Mark selected stories as verified"


class StoryImageAdmin(admin.ModelAdmin):
    list_display = ('__unicode__', 'image_tag', 'is_verified',)
    search_fields = ('image', 'filename', 'story__name', 'story__email', 'story__user__email',)
    list_filter = ('is_verified',)
    list_editable = ('is_verified',)
    actions = ['mark_verified']

    def mark_verified(self, request, queryset):
        rows_updated = queryset.update(is_verified=True)
        if rows_updated == 1:
            image_string = 'image'
        else:
            image_string = 'images'
        message = "%s %s marked as verified" % (rows_updated, image_string,)
        self.message_user(request, message)

    mark_verified.short_description = "Mark selected images as verified"



class QuestionAdmin(admin.ModelAdmin):
    search_fields = ('text',)
    list_display = (
        'questiongroup_source',
        'school_type',
        'questiongroup_version',
        'questiongroupquestions_sequence',
        'text',
        'key',
        'display_text',
        'is_featured',
        'question_type',
        'is_active'
    )
    list_editable = ('is_featured', 'is_active',)
    list_filter = (
        'school_type',
        'questiongroup__source',
        'questiongroup__version',
        'is_featured'
    )
    def questiongroup_source(self, question):
        return question.questiongroup_set.all().values_list('source__name', flat=True)
    def questiongroup_version(self, question):
        return question.questiongroup_set.all().values_list('version', flat=True)
    def questiongroupquestions_sequence(self, question):
        return question.questiongroupquestions_set.all().values_list('sequence', flat=True)

class QuestionInline(admin.TabularInline):
    model = QuestiongroupQuestions
    readonly_fields = ('question',)

class QuestiongroupAdmin(admin.ModelAdmin):
    list_display = ('source', 'version')
    inlines = [QuestionInline, ]
    readonly_fields = ('source', 'version',)

admin.site.register(Survey, SurveyAdmin)
admin.site.register([Answer,
                    QuestionType, Source])

admin.site.register(Story, StoryAdmin)
admin.site.register(Question, QuestionAdmin)
admin.site.register(Questiongroup, QuestiongroupAdmin)
admin.site.register(StoryImage, StoryImageAdmin)
