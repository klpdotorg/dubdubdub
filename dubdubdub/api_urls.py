from django.conf.urls import patterns, url
from django.views.decorators.cache import cache_page

from schools.api_views import SchoolsList, SchoolsInfo, SchoolInfo, Admin1s, \
    SchoolsDiseInfo, SchoolDemographics, SchoolProgrammes, SchoolFinance, \
    Admin2s, Admin3s, Admin2sInsideAdmin1, Admin3sInsideAdmin1, Admin3sInsideAdmin2, \
    Admin1OfSchool, Admin2OfSchool, Admin3OfSchool, PincodeOfSchool, AssemblyOfSchool, \
    ParliamentOfSchool

from users.api_views import TestAuthenticatedView, UsersView, UserProfileView, \
    OrganizationsView, OrganizationView, OrganizationUsersView, \
    OrganizationUserView

urlpatterns = patterns('',
    # Caches the results of the url for 60 seconds
    #url(r'^schools/list', cache_page(60)(SchoolsList.as_view()), name='api_schools_list'),
    url(r'^$', 'schools.api_views.api_root', name='api_root'),
    url(r'^schools/list$', SchoolsList.as_view(), name='api_schools_list'),
    url(r'^schools/info$', SchoolsInfo.as_view(), name='api_schools_info'),
    url(r'^schools/dise/(?P<year>[0-9\-]*)$', SchoolsDiseInfo.as_view(), name='api_schools_dise'),

    url(r'^schools/school/(?P<pk>[0-9]+)$', SchoolInfo.as_view(), name='api_school_info'),
    url(r'^schools/school/(?P<pk>[0-9]+)/demographics$', SchoolDemographics.as_view(), name='api_school_demo'),
    url(r'^schools/school/(?P<pk>[0-9]+)/programmes$', SchoolProgrammes.as_view(), name='api_school_prog'),
    url(r'^schools/school/(?P<pk>[0-9]+)/finance$', SchoolFinance.as_view(), name='api_school_finance'),

    url(r'^boundary/admin1s$', Admin1s.as_view(), name="api_admin1s"),
    url(r'^boundary/admin1/(?P<id>[0-9]+)/admin2$', Admin2sInsideAdmin1.as_view(), name="api_admin1s_admin2"),
    url(r'^boundary/admin1/(?P<id>[0-9]+)/admin3$', Admin3sInsideAdmin1.as_view(), name="api_admin1s_admin3"),
    url(r'^boundary/admin2s$', Admin2s.as_view(), name="api_admin2s"),
    url(r'^boundary/admin2s/(?P<id>[0-9]+)/admin3$', Admin3sInsideAdmin2.as_view(), name="api_admin2s_admin3"),
    url(r'^boundary/admin3s$', Admin3s.as_view(), name="api_admin3s"),

    url(r'^geo/admin1/(?P<pk>[0-9]+)$', Admin1OfSchool.as_view(), name="api_school_admin1"),
    url(r'^geo/admin2/(?P<pk>[0-9]+)$', Admin2OfSchool.as_view(), name="api_school_admin2"),
    url(r'^geo/admin3/(?P<pk>[0-9]+)$', Admin3OfSchool.as_view(), name="api_school_admin3"),
    url(r'^geo/pincode/(?P<pk>[0-9]+)$', PincodeOfSchool.as_view(), name="api_school_pincode"),
    url(r'^geo/assembly/(?P<pk>[0-9]+)$', AssemblyOfSchool.as_view(), name="api_school_assembly"),
    url(r'^geo/parliament/(?P<pk>[0-9]+)$', ParliamentOfSchool.as_view(), name="api_school_parliament"),

    url('^user/users$', UsersView.as_view(), name='api_user_users'),
    url('^user/profile', UserProfileView.as_view(), name='api_user_profile'),
    url('^user/signin$', 'users.api_views.signin', name='api_user_signin'),
    url('^user/signout$', 'users.api_views.signout', name='api_user_signout'),
    url('^user/test_authenticated', TestAuthenticatedView.as_view(), name='api_test_authenticated'),

    url('^organization/organizations$', OrganizationsView.as_view(), name='api_organizations_view'),
    url('^organization/(?P<pk>[0-9]+)$', OrganizationView.as_view(), name='api_organization_view'),
    url('^organization/(?P<org_pk>[0-9]+)/users$', OrganizationUsersView.as_view(), name='api_organizationusers_view'),
    url('^organization/(?P<org_pk>[0-9]+)/users/(?P<user_pk>[0-9]+)$', OrganizationUserView.as_view(), name='api_organizationuser_view'),
)
