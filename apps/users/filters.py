import django_filters
from .models import VolunteerActivity, DonationRequirement


class VolunteerActivityFilter(django_filters.FilterSet):

    class Meta:
        model = VolunteerActivity
        fields = ['organization', 'type', 'date', 'school', 'users']


class DonationRequirementFilter(django_filters.FilterSet):

    class Meta:
        model = DonationRequirement
        fields = ['organization'] #FIXME
