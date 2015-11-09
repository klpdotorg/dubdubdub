from django.conf.urls import patterns, url

from .api_views import (
    CheckSchool,
    VerifyAnswer,
    ReadSchool,

    DynamicResponse,
)

urlpatterns = patterns(
    '',
    url(r'check-school/$',
        CheckSchool.as_view(),
        name='api_ivrs_check'
    ),
    url(r'read-school/$',
        ReadSchool.as_view(),
        name='api_ivrs_read_school'
    ),
    url(r'dynamic-response/$',
        DynamicResponse.as_view(),
        name='dynamic_response'
    ),
    url(r'verify-answer/(?P<question_number>[-\w]+)/$',
        VerifyAnswer.as_view(),
        name='api_ivrs_verify_answer'
    ),
)
