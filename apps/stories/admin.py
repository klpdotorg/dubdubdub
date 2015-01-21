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
    list_display = ('id', 'email', 'created_at', 'school', 'is_verified',)
    list_editable = ('is_verified',)
    list_filter = ('is_verified',)
    search_fields = ('school__name',)
    raw_id_fields = ('school',)
    ordering = ['-created_at']
    inlines = [AnswerInline, StoryImageInline]

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


class StoryImageAdmin(admin.ModelAdmin):
    list_display = ('__unicode__', 'image_tag', 'is_verified',)
    list_editable = ('is_verified',)


class QuestionAdmin(admin.ModelAdmin):
    search_fields = ('text',)
    list_display = ('text', 'question_type', 'is_active')
    list_editable = ('is_active',)


class QuestionInline(admin.TabularInline):
    model = QuestiongroupQuestions
    readonly_fields = ('question',)

class QuestiongroupAdmin(admin.ModelAdmin):
    list_display = ('source', 'version')
    inlines = [QuestionInline, ]
    readonly_fields = ('source', 'version',)

admin.site.register([Answer,
                    QuestionType, Source])

admin.site.register(Story, StoryAdmin)
admin.site.register(Question, QuestionAdmin)
admin.site.register(Questiongroup, QuestiongroupAdmin)
admin.site.register(StoryImage, StoryImageAdmin)
