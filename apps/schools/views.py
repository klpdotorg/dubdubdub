# page views go here. For API views, use api_views.py
from django.views.generic.detail import DetailView
from common.views import StaticPageView
from .models import School, Programme, Boundary
from django.conf import settings
import urllib2
from django.http import HttpResponse
from django.core.urlresolvers import reverse


class SchoolPageView(DetailView):
    model = School
    template_name = 'school.html'

    def get_context_data(self, **kwargs):
        # Call the base implementation first to get a context
        context = super(SchoolPageView, self).get_context_data(**kwargs)
        # Add in a QuerySet of all the books
        school = context['object']

        # FIXME: there really should be a better way of handling school / preschool
        # Ideally, this would be better naming of "Boundary Type" and then just use that
        school_type = school.schooldetails.type.name
        context['breadcrumbs'] = [
            {
                'url': reverse('map'),
                'name': 'Map'
            },
            {
                'url': reverse('school_page', kwargs={'pk': school.id}),
                'name': '%s: %s' % (school_type, school.name,)
            }
        ]
        return context


class ProgrammeView(DetailView):
    model = Programme
    template_name = 'programme.html'


class BoundaryPageView(DetailView):
    model = Boundary
    template_name = 'boundary.html'


class AdvancedMapView(StaticPageView):
    template_name = 'advanced_map.html'
    extra_context = {
        'hide_footer': True,
    }


def blog_feed(request):
    url = settings.BLOG_FEED_URL
    json = urllib2.urlopen(url).read()
    return HttpResponse(json)
