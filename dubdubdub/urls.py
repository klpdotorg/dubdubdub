from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from django.contrib import admin
admin.autodiscover()
from klp.views import Schools

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^grappelli/', include('grappelli.urls')),
    url(r'^api/v1/schools', Schools.as_view(), name='api_schools'),
)
