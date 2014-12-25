from django.views.generic.detail import DetailView
from django.views.generic.base import RedirectView
from django.http import Http404
from django.shortcuts import redirect, get_object_or_404
from common.views import StaticPageView
from django.core.urlresolvers import reverse
from models import (User, Organization, VolunteerActivity, VolunteerActivityType,
    DonationItemCategory, DonationRequirement)

class ProfilePageView(DetailView):
    model = User
    template_name = 'profile.html'

    def get_context_data(self, **kwargs):
        context = super(ProfilePageView, self).get_context_data(**kwargs)
        user = context['object']
        context['breadcrumbs'] = [
            {
                'url': '/profile/%d' % (user.id,),
                'name': 'Profile: %s %s' % (user.first_name, user.last_name,)
            }
        ]
        return context



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


class OrganizationSlugPageView(DetailView):
    model = Organization
    slug_field = 'slug'
    slug_url_kwargs = 'slug'
    template_name = 'organization.html'

    def get_context_data(self, **kwargs):
        context = super(OrganizationSlugPageView, self).get_context_data(**kwargs)
        org = context['object']
        context['breadcrumbs'] = [
            {
                'url': '/organisation/%d' % (org.id,),
                'name': 'Organisation: %s' % (org.name,)
            }
        ]
        return context


class OrganizationPKPageView(RedirectView):
    permanent = False
    query_string = True
    pattern_name = 'article-detail'

    def get_redirect_url(self, *args, **kwargs):
        org = get_object_or_404(Organization, pk=kwargs['pk'])
        if not org.slug:
            org.save()
        return reverse('organization_page_slug', kwargs={'slug': org.slug})


class ProfileEditPageView(DetailView):
    model = User
    template_name = 'profile_edit.html'

    def get_context_data(self, **kwargs):
        context = super(ProfileEditPageView, self).get_context_data(**kwargs)
        user = context['object']
        context['breadcrumbs'] = [
            {
                'url': '/profile/%d' % (user.id,),
                'name': 'Profile'
            },
            {
                'url': '/profile/%d/edit' % (user.id,),
                'name': 'Edit'
            }
        ]
        return context


class OrganizationEditPageView(DetailView):
    model = Organization
    template_name = 'organization_edit.html'

    def get_context_data(self, **kwargs):
        context = super(OrganizationEditPageView, self).get_context_data(**kwargs)
        org = context['object']
        context['breadcrumbs'] = [
            {
                'url': '/organisation/%d' % (org.id,),
                'name': 'Organisation: %s' % (org.name,)
            },
            {
                'url': '/organisation/%d/edit' % (org.id,),
                'name': 'Edit'
            }
        ]
        return context


class VolunteerActivityAddPageView(DetailView):
    model = Organization
    template_name = 'volunteeractivity/add.html'

    def get_context_data(self, **kwargs):
        context = super(VolunteerActivityAddPageView, self).get_context_data(**kwargs)
        context['action'] = 'Add'
        context['activity_types'] = VolunteerActivityType.objects.all()
        org = context['object']
        context['breadcrumbs'] = [
            {
                'url': '/organisation/%d' % (org.id,),
                'name': 'Organisation: %s' % (org.name,)
            },
            {
                'url': '/organisation/%d/edit' % (org.id,),
                'name': 'Edit'
            },
            {
                'url': '/organisation/%d/volunteer_activity' % (org.id,),
                'name': 'Add Volunteer Activity'
            },
        ]
        return context


class VolunteerActivityEditPageView(DetailView):
    model = VolunteerActivity
    template_name = 'volunteeractivity/edit.html'

    def get_context_data(self, **kwargs):
        context = super(VolunteerActivityEditPageView, self).get_context_data(**kwargs)
        context['action'] = 'Edit'
        context['activity_types'] = VolunteerActivityType.objects.all()
        activity = context['object']
        org = activity.organization
        context['breadcrumbs'] = [
           {
                'url': '/organisation/%d' % (org.id,),
                'name': 'Organisation: %s' % (org.name,)
            },
            {
                'url': '/organisation/%d/edit' % (org.id,),
                'name': 'Edit'
            },
            {
                'url': '/organisation/%d/volunteer_activity/%d' % (org.id, activity.id,),
                'name': 'Edit Volunteer Activity'
            }
        ]
        return context


class VolunteerMapPageView(StaticPageView):

    def get_context_data(self, **kwargs):
        context = super(VolunteerMapPageView, self).get_context_data(**kwargs)
        context['activity_types'] = VolunteerActivityType.objects.all()
        context['organizations'] = Organization.objects.all()
        return context


class DonatePageView(StaticPageView):

    def get_context_data(self, **kwargs):
        context = super(DonatePageView, self).get_context_data(**kwargs)
        context['categories'] = DonationItemCategory.objects.all()
        context['organizations'] = Organization.objects.all()
        return context



class DonationRequirementsView(StaticPageView):

    def get_context_data(self, **kwargs):
        context = super(DonationRequirementsView, self).get_context_data(**kwargs)
        category_id = self.request.GET.get('category', None)
        organization_id = self.request.GET.get('org', None)
        if category_id:
            context['category'] = get_object_or_404(DonationItemCategory, pk=category_id)
        if organization_id:
            context['organization'] = get_object_or_404(Organization, pk=organization_id)
        context['heading'] = self._get_heading_string(context)
        return context


    def _get_heading_string(self, context):
        """Get heading string for page based on filters selected"""
        if context.has_key('category') and context.has_key('organization'):
            s = "Donate %s to %s" % (context['category'].name, context['organization'].name)
        elif context.has_key('category'):
            s = "Donate %s" % context['category'].name
        elif context.has_key('organization'):
            s = "Donate to %s" % context['organization'].name
        else:
            s = "Donate"
        return s


class DonationRequirementAddEditPageView(StaticPageView):
    """View to render template for donation add and edit.
    
    The same view handles both "add" and "edit" urls,
    populating context accordingly. Both use the same template to render.
    """
    template_name = 'donate/add_edit.html'

    def get_context_data(self, **kwargs):
        context = super(DonationRequirementAddEditPageView, self).get_context_data(**kwargs)
        org = self._get_org()
        context['org'] = org
        donation_requirement = self._get_donation_requirement()
        if donation_requirement:
            context['donation_requirement'] = donation_requirement
        context['item_categories'] = DonationItemCategory.objects.all()
        context['breadcrumbs'] = [
            {
                'url': '/organisation/%d' % (org.id,),
                'name': 'Organisation: %s' % (org.name,)
            },
            {
                'url': '/organisation/%d/edit' % (org.id,),
                'name': 'Edit'
            },
            {
                'url': '/organisation/%d/donation_requirement' % (org.id,),
                'name': 'Add Donation Requirement'
            },
        ]
        return context

    def _get_org(self):
        if self.kwargs.has_key('org_pk'):
            org_id = self.kwargs['org_pk']
        else:
            org_id = self.kwargs['pk']
        return get_object_or_404(Organization, pk=org_id)

    def _get_donation_requirement(self):
        if not self.kwargs.has_key('org_pk'):
            return None
        donation_requirement_id = self.kwargs['pk']
        return get_object_or_404(DonationRequirement, pk=donation_requirement_id)