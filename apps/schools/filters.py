import django_filters
from .models import School
from users.models import VolunteerActivityType, Organization


class SchoolFilter(django_filters.FilterSet):

    volunteer_activity_date = django_filters\
        .DateFilter(name='volunteeractivity__date')

    volunteer_activity_min_date = django_filters\
        .DateFilter(name='volunteeractivity__date', lookup_type='gte')

    volunteer_activity_max_date = django_filters\
        .DateFilter(name='volunteeractivity__date', lookup_type='lte')

    volunteer_activity_type = django_filters\
        .ModelChoiceFilter(name='volunteeractivity__type',
                           queryset=VolunteerActivityType.objects.all())

    volunteer_activity_org = django_filters\
        .ModelChoiceFilter(name='volunteeractivity__organization',
                           queryset=Organization.objects.all())

    class Meta:
        fields = ('volunteer_activity_min_date', 'volunteer_activity_max_date',
                  'volunteer_activity_type', 'volunteer_activity_org',
                  'cat', 'sex', 'moi', 'mgmt',)
        model = School
