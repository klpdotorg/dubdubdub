import django_filters
from .models import VolunteerActivity, DonorRequirement


class VolunteerActivityFilter(django_filters.FilterSet):

    class Meta:
        model = VolunteerActivity
        fields = ['organization', 'type', 'date', 'school', 'users']


class DonorRequirementFilter(django_filters.FilterSet):

    class Meta:
        model = DonorRequirement
        fields = ['organization', 'type', 'school', 'users']
