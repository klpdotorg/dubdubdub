from django.conf.urls import patterns, url

from .api_views import CheckSchool, ReadSchool

urlpatterns = patterns(
    '',
    url(r'check-school/$', CheckSchool.as_view(), name='api_ivrs_check'),
    url(r'read-school/$', ReadSchool.as_view(), name='api_ivrs_read'),
    url(r'verify/$', Verify.as_view(), name='api_ivrs_verify'),
    url(r'verify-answer/$', VerifyAnswer.as_view(), name='api_ivrs_verify_answer'),
)
