from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from django.contrib import admin
admin.autodiscover()
from schools.views import SchoolPageView
from common.views import StaticPageView
from users.views import (ProfilePageView, OrganizationPageView,
                         ProfileEditPageView, OrganizationEditPageView,
                         VolunteerActivityAddPageView,
                         VolunteerActivityEditPageView)

urlpatterns = patterns('',

    #home page
    url(r'^$', StaticPageView.as_view(
        template_name='home.html',
        extra_context={
                # anything put into this dict will be availabe in template
                'homepage': True
                }
        ), name='home'),

    #about pages
    url(r'^text/aboutus$', StaticPageView.as_view(
        template_name='aboutus.html'
        ), name='aboutus'),

    url(r'^text/partners$', StaticPageView.as_view(
        template_name='partners.html'
        ), name='partners'),

    url(r'^text/disclaimer$', StaticPageView.as_view(
        template_name='disclaimer.html'
        ), name='disclaimer'),

    #reports page
    url(r'^text/reports$', StaticPageView.as_view(
        template_name='reports.html'
        ), name='reports'),

    #data page
    url(r'^text/data$', StaticPageView.as_view(
        template_name='data.html'
        ), name='data'),

    #programme pages
    url(r'^text/reading$', StaticPageView.as_view(
        template_name='reading_programme.html'
        ), name='reading_programme'),

    url(r'^text/maths$', StaticPageView.as_view(
        template_name='maths_programme.html'
        ), name='maths_programme'),

    url(r'^text/library$', StaticPageView.as_view(
        template_name='library_programme.html'
        ), name='library_programme'),

    url(r'^text/preschool$', StaticPageView.as_view(
        template_name='preschool_programme.html'
        ), name='preschool_programme'),

    url(r'^text/sikshana$', StaticPageView.as_view(
        template_name='sikshana_programme.html'
        ), name='sikshana_programme'),

    url(r'^volunteer$', StaticPageView.as_view(
        template_name='volunteer.html'
        ), name='volunteer'),
    url(r'^volunteer-register$', StaticPageView.as_view(
        template_name='volunteer-register.html'
        ), name='volunteer_register'),

    url(r'^map$', StaticPageView.as_view(
        template_name='map.html',
        extra_context={
            'header_full_width': True,
            'header_fixed': True,
            'hide_footer': True
        }), name='map'),

    url(r'^school$', StaticPageView.as_view(
        template_name='school.html',
        extra_context={
            #'header_full_width': True,
            #'header_fixed': True,
            #'hide_footer': True
        }), name='school_detail'),

    url(r'^schoolpage/school/(?P<pk>[0-9]*)$', SchoolPageView.as_view(), name='school_page'),

    url(r'^profile/(?P<pk>[0-9]*)$', ProfilePageView.as_view(), name='profile_page'),

    url(r'^organisation/(?P<pk>[0-9]*)$', OrganizationPageView.as_view(), name='organization_page'),

    url(r'^organisation/(?P<pk>[0-9]*)/edit$',
        OrganizationEditPageView.as_view(),
        name='organization_edit_page'),

    url(r'^organisation/(?P<pk>[0-9]*)/volunteer_activity$',
        VolunteerActivityAddPageView.as_view(),
        name='volunteeractivity_add_page'),

    url(r'^organisation/(?P<org_pk>[0-9]*)/volunteer_activity/(?P<pk>[0-9]*)$',
        VolunteerActivityEditPageView.as_view(),
        name='volunteeractivity_edit_page'),
    
    url(r'^profile/(?P<pk>[0-9]*)/edit$', ProfileEditPageView.as_view(), name='profile_edit_page'),

    url(r'^password-reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
        'django.contrib.auth.views.password_reset_confirm', {
        'template_name': 'users/password-reset-confirm.html'
        }, name='password_reset_confirm'),

    url(r'^password-reset/done/$', 'django.contrib.auth.views.password_reset_complete', {
        'template_name': 'users/password-reset-complete.html'
        },
        name='password_reset_complete'),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^grappelli/', include('grappelli.urls')),

    url(r'^api/v1/', include('dubdubdub.api_urls')),
    url(r'^api-docs/', include('rest_framework_swagger.urls'))
)
