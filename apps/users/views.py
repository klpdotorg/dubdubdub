from django.views.generic.detail import DetailView
from django.http import Http404
from common.views import StaticPageView
from models import User, Organization, VolunteerActivity, VolunteerActivityType

class ProfilePageView(DetailView):
    model = User
    template_name = 'profile.html'


class EmailVerificationView(StaticPageView):
    template_name = 'email_verified.html'

    def get(self, request, **kwargs):
        email_verification_code = self.request.GET.get('token', '')
        email = self.request.GET.get('email', '')

        users = User.objects.filter(
            is_email_verified=False,
            email=email,
            email_verification_code=email_verification_code
        )
        if users.count() == 1:
            user = users[0]
            user.is_email_verified = True
            user.save()
        else:
            raise Http404()

        return super(EmailVerificationView, self).get(request, **kwargs)


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
