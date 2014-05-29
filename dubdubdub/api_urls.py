from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView

from schools.api_views import SchoolsList, SchoolsInfo, SchoolInfo, Districts, SchoolsDiseInfo
from common.views import StaticPageView

urlpatterns = patterns('',
    url(r'^schools/list', SchoolsList.as_view(), name='api_schools_list'),
    url(r'^schools/info', SchoolsInfo.as_view(), name='api_schools_info'),
    url(r'^schools/dise/(?P<year>[0-9]*)', SchoolsDiseInfo.as_view(), name='api_schools_dise'),
    url(r'^schools/school/(?P<pk>[0-9]*)', SchoolInfo.as_view(), name='api_school_info'),
    url(r'^boundary/districts', Districts.as_view(), name="api_districts")
)
