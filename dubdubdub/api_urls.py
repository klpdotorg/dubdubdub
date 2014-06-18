from django.conf.urls import patterns, url
from django.views.decorators.cache import cache_page

from schools.api_views import SchoolsList, SchoolsInfo, SchoolInfo, Districts, \
    SchoolsDiseInfo, SchoolDemographics, SchoolProgrammes, SchoolFinance, \
    Blocks, Clusters, BlocksInsideDistrict, ClustersInsideDistrict, ClustersInsideBlock, \
    DistrictOfSchool, BlockOfSchool, ClusterOfSchool, PincodeOfSchool, AssemblyOfSchool, \
    ParliamentOfSchool

from users.api_views import TestAuthenticatedView

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
    
    url(r'^boundary/districts$', Districts.as_view(), name="api_districts"),
    url(r'^boundary/districts/(?P<id>[0-9]+)/blocks$', BlocksInsideDistrict.as_view(), name="api_districts_block"),
    url(r'^boundary/districts/(?P<id>[0-9]+)/clusters$', ClustersInsideDistrict.as_view(), name="api_districts_cluster"),
    url(r'^boundary/blocks$', Blocks.as_view(), name="api_blocks"),
    url(r'^boundary/blocks/(?P<id>[0-9]+)/clusters$', ClustersInsideBlock.as_view(), name="api_blocks_clusters"),
    url(r'^boundary/clusters$', Clusters.as_view(), name="api_clusters"),

    url(r'^geo/district/(?P<pk>[0-9]+)$', DistrictOfSchool.as_view(), name="api_school_district"),
    url(r'^geo/block/(?P<pk>[0-9]+)$', BlockOfSchool.as_view(), name="api_school_block"),
    url(r'^geo/cluster/(?P<pk>[0-9]+)$', ClusterOfSchool.as_view(), name="api_school_cluster"),
    url(r'^geo/pincode/(?P<pk>[0-9]+)$', PincodeOfSchool.as_view(), name="api_school_pincode"),
    url(r'^geo/assembly/(?P<pk>[0-9]+)$', AssemblyOfSchool.as_view(), name="api_school_assembly"),
    url(r'^geo/parliament/(?P<pk>[0-9]+)$', ParliamentOfSchool.as_view(), name="api_school_parliament"),

    url('^users/signup$', 'users.api_views.signup', name='api_signup'),
    url('^users/signin$', 'users.api_views.signin', name='api_signin'),
    url('^users/signout$', 'users.api_views.signout', name='api_signout'),
    url('^users/test_authenticated', TestAuthenticatedView.as_view(), name='api_test_authenticated'),
)
