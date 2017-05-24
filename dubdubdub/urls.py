from django.conf.urls import patterns, include, url
from django.conf import settings
from django.views.generic import TemplateView
from django.views.generic.base import RedirectView
from schools.views import (SchoolPageView, ProgrammeView, NewBoundaryPageView,
                           BoundaryPageView, AdvancedMapView)
from stories.views import IVRSPageView, SYSView
from common.views import StaticPageView
from users.views import (
    ProfilePageView, OrganizationSlugPageView,
    OrganizationPKPageView, ProfileEditPageView, OrganizationEditPageView,
    VolunteerActivityAddPageView, VolunteerActivityEditPageView,
    EmailVerificationView, VolunteerMapPageView, DonatePageView,
    DonationRequirementsView, DonationRequirementView,
    DonationRequirementAddEditPageView
)

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns(
    '',
    # share your story form
    url(r'^sys/(?P<pk>[0-9]+)$', SYSView.as_view(), name='sys'),

    # home page
    url(r'^$', StaticPageView.as_view(
        template_name='home.html',
    ), name='home'),

    url(r'^status/$', StaticPageView.as_view(
        template_name='comingsoon.html'
    ), name='status'),

    # mobile responses
    url(r'^mobile/$', StaticPageView.as_view(
        template_name='survey_responses.html'
    ), name='mobile'),

    # story dashboard
    url(r'^stories/$', StaticPageView.as_view(
        template_name='story_dashboard.html'
    ), name='story_dashboard'),

    # gka ivrs
    url(r'^gka/$', StaticPageView.as_view(
        template_name='gka_dashboard.html'
        ), name='gka_dashboard'),

    # styleguide page
    url(r'^styleguide/$', StaticPageView.as_view(
        template_name='styleguide.html'
    ), name='styleguide'),

    # about pages
    url(r'^about/$', StaticPageView.as_view(
        template_name='aboutus.html',
    ), name='aboutus'),
    url(r'text/aboutus/$', RedirectView.as_view(url='/about')),

    url(r'^partners/$', StaticPageView.as_view(
        template_name='partners.html',
    ), name='partners'),
    url(r'text/partners/$', RedirectView.as_view(url='/partners')),

    url(r'^disclaimer/$', StaticPageView.as_view(
        template_name='disclaimer.html',
    ), name='disclaimer'),
    url(r'text/disclaimer/$', RedirectView.as_view(url='/disclaimer')),

    # reports page
    url(r'^reports/$', StaticPageView.as_view(
        template_name='reports.html',
    ), name='reports'),
    url(r'text/reports/$', RedirectView.as_view(url='/reports')),

    # temporary klp reports page to link to static pdfs
    url(r'^reports/klp/$', StaticPageView.as_view(
        template_name='klpreports.html',
    ), name='klpreports'),

    # temporary dise reports page to link to static pdfs
    url(r'^reports/dise/$', StaticPageView.as_view(
        template_name='disereports.html',
    ), name='disereports'),

    # data page
    url(r'^data/$', StaticPageView.as_view(
        template_name='data.html',
    ), name='data'),
    url(r'text/data$', RedirectView.as_view(url='/data')),
    url(r'listFiles/2$', RedirectView.as_view(url='/data')),

    # partners pages

    url(r'^partners/akshara/reading/$', StaticPageView.as_view(
        template_name='partners/akshara/reading.html',
    ), name='reading_programme'),

    url(r'^programmes/reading/$', RedirectView.as_view(url='/partners/akshara/reading/')),
    url(r'text/reading/$', RedirectView.as_view(url='/partners/akshara/reading/')),

    url(r'^partners/akshara/maths/$', StaticPageView.as_view(
        template_name='partners/akshara/maths.html',
    ), name='maths_programme'),
    url(r'^text/maths/$', RedirectView.as_view(url='/partners/akshara/maths/')),

    url(r'^partners/akshara/library/$', StaticPageView.as_view(
        template_name='partners/akshara/library.html',
    ), name='library_programme'),
    url(r'^text/library/$', RedirectView.as_view(url='/partners/akshara/library/')),

    url(r'^partners/akshara/preschool/$', StaticPageView.as_view(
        template_name='partners/akshara/preschool.html',
    ), name='preschool_programme'),
    url(r'^text/preschool/$', RedirectView.as_view(url='/partners/akshara/preschool/')),

    url(r'^partners/sikshana/reading/$', StaticPageView.as_view(
        template_name='partners/sikshana/reading.html',
    ), name='sikshana_programme'),
    url(r'^programmes/sikshana/$', RedirectView.as_view(url='/partners/sikshana/reading/')),
    url(r'^text/sikshana/$', RedirectView.as_view(url='/partners/sikshana/reading/')),

    url(r'^partners/pratham/learn-out-of-the-box/$', StaticPageView.as_view(
        template_name='partners/pratham/learn.html',
    ), name='partners_pratham_learn'),

    url(r'^volunteer/$', StaticPageView.as_view(
        template_name='volunteer.html',
    ), name='volunteer'),
    url(r'text/volunteer/$', RedirectView.as_view(url='/volunteer/')),

    # URL for assessment programme details
    url(r'^programme/(?P<pk>[0-9]+)$', ProgrammeView.as_view(), name='programme'),

    url(r'^map/$', StaticPageView.as_view(
        template_name='map.html',
        extra_context={
            'hide_footer': True,
        }), name='map'),


    # report pages
    url(r'^reports/search$', StaticPageView.as_view(
        template_name='report_search.html'
        ), name='report_search'),

    url(r'^reports/demographics/(?P<report_type>electedrep|boundary)/(?P<language>english|kannada)/(?P<id>[0-9]+)/$', StaticPageView.as_view(
        template_name='demographics.html'
        ), name='demographics'),

    url(r'^reports/demographics_dise/(?P<report_type>electedrep|boundary)/(?P<language>english|kannada)/(?P<id>[0-9]+)/$', StaticPageView.as_view(
        template_name='demographics_dise.html'
        ), name='demographics_dise'),

    url(r'^reports/finance/(?P<report_type>electedrep|boundary)/(?P<language>english|kannada)/(?P<id>[0-9]+)/$', StaticPageView.as_view(
        template_name='finance.html'
        ), name='finance'),

    url(r'^reports/infrastructure/(?P<report_type>electedrep|boundary)/(?P<language>english|kannada)/(?P<id>[0-9]+)/$', StaticPageView.as_view(
        template_name='infrastructure.html'
        ), name='infrastructure'),

    url(r'^reports/surveys$', StaticPageView.as_view(
        template_name='story_report.html'
        ), name='stories'),



    # url(r'^volunteer-map$', StaticPageView.as_view(
    #     template_name='volunteer-map.html',
    #     extra_context={
    #         'header_full_width': True,
    #         'header_fixed': True,
    #         'hide_footer': True
    #     }), name='volunteer_map'),

    url(r'^advanced-map/$', AdvancedMapView.as_view(), name='advanced_map'),

    url(r'^volunteer-map$', VolunteerMapPageView.as_view(
        template_name='volunteer-map.html',
        extra_context={
            'hide_footer': True,
        }), name='volunteer_map'),

    url('^donate$', DonatePageView.as_view(
        template_name='donate/donate.html',
    ), name='donate'),

    url('^donate/requests/$', DonationRequirementsView.as_view(
        template_name='donate/donate_requests.html'
    ), name='donate_requests'),

    url('^donate/requests/(?P<pk>[0-9]+)$', DonationRequirementView.as_view(
        template_name='donate/donate_request.html'
    ), name='donate_request'),

    url(r'^organisation/(?P<pk>[0-9]+)/donation_requirement$',
        DonationRequirementAddEditPageView.as_view(
            extra_context={
                'action': 'Add'
            }
        ),
        name='donationrequest_add_page'),

    url(r'^organisation/(?P<org_pk>[0-9]+)/donation_requirement/(?P<pk>[0-9]+)$',
        DonationRequirementAddEditPageView.as_view(
            extra_context={
                'action': 'Edit'
            }
        ),
        name='volunteeractivity_edit_page'),

    url(r'^school/(?P<pk>[0-9]+)/$',
        SchoolPageView.as_view(), name='school_page'),

    url(r'^schoolpage/school/(?P<pk>[0-9]*)$$', RedirectView.as_view(
        pattern_name='school_page',
        query_string=True
    ), name='old_school_page'),

    # boundary page
    url(r'^boundary/(?P<pk>[0-9]+)/$', BoundaryPageView.as_view(), name='boundary_page'),
    url(r'^(?P<boundary_type>preschool-district|primary-district|circle|cluster|project|block)/(?P<pk>[0-9]+)/$', NewBoundaryPageView.as_view(), name='boundary_page_new'),

    # sdmc reports
    url(r'^sdmc/$', StaticPageView.as_view(
        template_name='sdmc_reports.html'
    ), name='sdmc'),

    url(r'^users/verify_email',
        EmailVerificationView.as_view(), name='user_email_verify'),

    url(r'^profile/(?P<pk>[0-9]+)/$',
        ProfilePageView.as_view(), name='profile_page'),

    url(r'^organisation/(?P<pk>[0-9]+)/$',
        OrganizationPKPageView.as_view(), name='organization_page'),
    url(r'^organisation/(?P<slug>[-a-zA-Z0-9_]+)/$',
        OrganizationSlugPageView.as_view(), name='organization_page_slug'),

    url(r'^organisation/(?P<pk>[0-9]+)/edit$',
        OrganizationEditPageView.as_view(),
        name='organization_edit_page'),

    url(r'^organisation/(?P<pk>[0-9]+)/volunteer_activity$',
        VolunteerActivityAddPageView.as_view(),
        name='volunteeractivity_add_page'),

    url(r'^organisation/(?P<org_pk>[0-9]+)/volunteer_activity/(?P<pk>[0-9]+)$',
        VolunteerActivityEditPageView.as_view(),
        name='volunteeractivity_edit_page'),

    url(r'^profile/(?P<pk>[0-9]+)/edit$',
        ProfileEditPageView.as_view(), name='profile_edit_page'),

    #url(r'^ivrs$', IVRSPageView.as_view(), name='ivrs_page'),

    url(r'^password-reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
        'django.contrib.auth.views.password_reset_confirm', {
            'template_name': 'users/password-reset-confirm.html'
        }, name='password_reset_confirm'),

    url(r'^password-reset/done/$',
        'django.contrib.auth.views.password_reset_complete', {
            'template_name': 'users/password-reset-complete.html'
        },
        name='password_reset_complete'),

    url(r'^blog-feed$', 'schools.views.blog_feed', name='blog_feed'),

    url(r'^admin/', include(admin.site.urls)),

    url(r'^api/v1/', include('dubdubdub.api_urls')),
    url(r'^api/docs/', include('rest_framework_swagger.urls')),
)

if settings.DEBUG:
    urlpatterns += patterns(
        '',
        url(r'^media/(?P<path>.*)$', 'django.views.static.serve', {
            'document_root': settings.MEDIA_ROOT,
        })
    )
