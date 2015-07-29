from django.conf.urls import patterns, url

from .api_views import (
    CheckSchool, ReadSchool, Verify, VerifyAnswer, ReadChapter, ReadTLM,
)

urlpatterns = patterns(
    '',
    url(r'check-school/$', CheckSchool.as_view(), name='api_ivrs_check'),
    url(r'read-school/$', ReadSchool.as_view(), name='api_ivrs_read_school'),
    url(r'read-chapter/$', ReadChapter.as_view(), name='api_ivrs_read_chapter'),
    url(r'read-tlm/$', ReadTLM.as_view(), name='api_ivrs_read_tlm'),
    url(r'verify/$', Verify.as_view(), name='api_ivrs_verify'),
    url(r'verify-answer/(?P<question_number>[-\w]+)/$', VerifyAnswer.as_view(), name='api_ivrs_verify_answer'),
)
