from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from django.contrib import admin
admin.autodiscover()

from klp.views import Schools
from common.views import HomeView

urlpatterns = patterns('',
    url(r'^$', HomeView.as_view(), name='home'),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^grappelli/', include('grappelli.urls')),
    url(r'^api/v1/schools', Schools.as_view(), name='api_schools'),
)
