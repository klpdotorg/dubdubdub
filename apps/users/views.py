from django.views.generic.detail import DetailView
from models import User, Organization, VolunteerActivity, VolunteerActivityType

class ProfilePageView(DetailView):
    model = User
    template_name = 'profile.html'


class OrganizationPageView(DetailView):
    model = Organization
    template_name = 'organization.html'


class ProfileEditPageView(DetailView):
    model = User
    template_name = 'profile_edit.html'


class OrganizationEditPageView(DetailView):
    model = Organization
    template_name = 'organization_edit.html'


class VolunteerActivityAddPageView(DetailView):
    model = Organization
    template_name = 'volunteeractivity/add.html'

    def get_context_data(self, **kwargs):
        context = super(VolunteerActivityAddPageView, self).get_context_data(**kwargs)
        context['action'] = 'Add'
        context['activity_types'] = VolunteerActivityType.objects.all()
        return context


class VolunteerActivityEditPageView(DetailView):
    model = VolunteerActivity
    template_name = 'volunteeractivity/edit.html'

    def get_context_data(self, **kwargs):
        context = super(VolunteerActivityEditPageView, self).get_context_data(**kwargs)
        context['action'] = 'Edit'
        context['activity_types'] = VolunteerActivityType.objects.all()
        return context