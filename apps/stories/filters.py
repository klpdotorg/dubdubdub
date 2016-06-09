import django_filters

from .models import Question, Questiongroup


class QuestionFilter(django_filters.FilterSet):
    type = django_filters.CharFilter(name="questiontype__name")
    source = django_filters.CharFilter(name="questiongroup__source__name")

    class Meta:
        model = Question
        fields = ['text', 'type', 'source']


class QuestiongroupFilter(django_filters.FilterSet):
    DRAFT_STATUS = 0
    ACTIVE_STATUS = 1
    ARCHIVED_STATUS = 2

    STATUS_CHOICES = (
        (DRAFT_STATUS, 'Draft'),
        (ACTIVE_STATUS, 'Active'),
        (ARCHIVED_STATUS, 'Archived'),
    )

    source = django_filters.CharFilter(name="source__name")
    status = django_filters.MultipleChoiceFilter(choices=STATUS_CHOICES)

    class Meta:
        model = Questiongroup
        fields = ['source', 'status']
