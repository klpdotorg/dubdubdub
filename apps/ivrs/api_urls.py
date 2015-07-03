from django.conf.urls import patterns, url

from .api_views import CheckSchool, ReadSchool

urlpatterns = patterns(
    '',
    url(r'check-school/$', CheckSchool.as_view(), name='api_ivrs_check'),
    url(r'read-school/$', ReadSchool.as_view(), name='api_ivrs_read'),
)
