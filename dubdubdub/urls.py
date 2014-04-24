from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from django.contrib import admin
admin.autodiscover()

from schools.views import Schools
from common.views import StaticPageView

urlpatterns = patterns('',
    url(r'^$', StaticPageView.as_view(
            template_name='home.html',
            extra_context={
                # anything put into this dict will be availabe in template
                'homepage': True
            }
        ), name='home'),

    url(r'^text/aboutus$', StaticPageView.as_view(
            template_name='aboutus.html'
        ), name='aboutus'),

    url(r'^text/partners$', StaticPageView.as_view(
            template_name='partners.html'
        ), name='partners'),

    url(r'^text/disclaimer$', StaticPageView.as_view(
            template_name='disclaimer.html'
        ), name='disclaimer'),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^grappelli/', include('grappelli.urls')),
    url(r'^api/v1/schools', Schools.as_view(), name='api_schools'),
)
