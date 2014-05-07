from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView

from schools.api_views import SchoolsList
from common.views import StaticPageView

urlpatterns = patterns('',
    url(r'^schools/list', SchoolsList.as_view(), name='api_schools_list'),
    #url(r'^schools/info', SchoolsInfo.as_view(), name='api_schools_info'),
)
