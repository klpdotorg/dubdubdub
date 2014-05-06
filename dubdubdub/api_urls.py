from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView

from schools.views import Schools
from common.views import StaticPageView

urlpatterns = patterns('',
    url(r'^schools', Schools.as_view(), name='api_schools'),
)
