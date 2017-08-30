from django.conf.urls import patterns, url

from .api_views import (
    SMSView,
)

urlpatterns = patterns(
    '',
    url(r'sms/$',
        SMSView.as_view(),
        name='api_sms'
    ),
)
