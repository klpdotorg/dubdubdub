#page views go here. For API views, use api_views.py
from django.views.generic.detail import DetailView
from .models import School
from django.conf import settings
import urllib2
from django.http import HttpResponse

class SchoolPageView(DetailView):
    model = School
    template_name = 'school.html'

    def get_context_data(self, **kwargs):
        # Call the base implementation first to get a context
        context = super(SchoolPageView, self).get_context_data(**kwargs)
        # Add in a QuerySet of all the books
        school = context['object']
        context['breadcrumbs'] = [
            {
                'url': '/map',
                'name': 'Map'
            },
            {
                'url': '/school/%d' % (school.id,),
                'name': 'School: %s' % (school.name,)
            }
        ]
        return context


def blog_feed(request):
    url = settings.BLOG_FEED_URL
    json = urllib2.urlopen(url).read()
    return HttpResponse(json)

