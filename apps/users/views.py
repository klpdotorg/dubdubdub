from django.views.generic.detail import DetailView
from models import User, Organization

class ProfilePageView(DetailView):
    model = User
    template_name = 'profile.html'


class OrganizationPageView(DetailView):
    model = Organization
    template_name = 'organization.html'