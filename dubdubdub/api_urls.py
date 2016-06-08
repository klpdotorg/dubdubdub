from django.conf.urls import patterns, url, include
# from django.views.decorators.cache import cache_page

from common.views import URLConfigView

from schools.api_views import (
    SchoolsList, SchoolsInfo, SchoolInfo, Admin1s,
    SchoolsDiseInfo, SchoolDemographics, SchoolProgrammes, SchoolFinance,
    Admin2s, Admin3s, Admin2sInsideAdmin1, Admin3sInsideAdmin1,
    Admin3sInsideAdmin2, Admin1OfSchool, Admin2OfSchool, Admin3OfSchool,
    PincodeOfSchool, AssemblyOfSchool, ParliamentOfSchool, SchoolInfra,
    SchoolLibrary, OmniSearch, AdminDetails, AssemblyDetails,
    ParliamentDetails, AssemblyList, ParliamentList, AssemblyInParliament,
    PincodeDetails, SchoolNutrition, MergeEndpoints, PartnerList,
    AssessmentsList, AssessmentInfo, ProgrammesList, ProgrammeInfo, ProgrammePercentile,
    BoundaryLibLevelAggView, BoundaryLibLangAggView, BoundarySchoolAggView,
    AssemblySchoolAggView, ParliamentSchoolAggView, PincodeSchoolAggView,
)

from users.api_views import (
    TestAuthenticatedView, UsersView,
    UserProfileView, OtherUserProfileView, OrganizationsView,
    OrganizationView, OrganizationUsersView, OrganizationUserView,
    VolunteerActivitiesView, VolunteerActivityView,
    VolunteerActivityTypesView,
    VolunteerActivityTypeView, VolunteerActivityUsersView,
    VolunteerActivityUserView, DonationItemCategoriesView,
    DonationRequirementListView, DonationRequirementDetailsView,
    PasswordChangeView, DonationItemListView, DonationItemDetailsView,
    DonationUsersView, DonationUserView
)

from stories.api_views import (
    StoryQuestionsView, StoriesView, StoryInfoView,
    ShareYourStoryView, StoryMetaView, StoryDetailView, StoryVolumeView,
    SurveysViewSet, SurveysQuestionsViewSet
)

ListCreateMapper = {
    'get' : 'list',
    'post' : 'create',
}

RetrieveUpdateDestroyMapper = {
    'get' : 'retrieve',
    'put' : 'update',
    'patch' : 'update',
    'delete' : 'destroy',
}

urlpatterns = patterns(
    '',

    url(r'^$', 'schools.api_views.api_root', name='api_root'),

    url(r'^merge$', MergeEndpoints.as_view(), name='api_merge'),

    url(r'^patterns/$', URLConfigView.as_view(), name='api_urlspatterns'),

    url(r'^search/$', OmniSearch.as_view(), name='api_omni_search'),

    url(r'^schools/list/$', SchoolsList.as_view(), name='api_schools_list'),
    url(r'^schools/info/$', SchoolsInfo.as_view(), name='api_schools_info'),
    url(r'^schools/dise/(?P<year>[0-9\-]*)$', SchoolsDiseInfo.as_view(),
        name='api_schools_dise'),
    url(r'^schools/school/(?P<pk>[0-9]+)/$', SchoolInfo.as_view(),
        name='api_school_info'),
    url(r'^schools/school/(?P<pk>[0-9]+)/demographics$',
        SchoolDemographics.as_view(), name='api_school_demo'),
    url(r'^schools/school/(?P<pk>[0-9]+)/programmes$',
        SchoolProgrammes.as_view(), name='api_school_prog'),
    url(r'^schools/school/(?P<pk>[0-9]+)/finance$',
        SchoolFinance.as_view(), name='api_school_finance'),
    url(r'^schools/school/(?P<pk>[0-9]+)/infrastructure$',
        SchoolInfra.as_view(), name='api_school_infra'),
    url(r'^schools/school/(?P<pk>[0-9]+)/library$',
        SchoolLibrary.as_view(), name='api_school_library'),
    url(r'^schools/school/(?P<pk>[0-9]+)/nutrition$',
        SchoolNutrition.as_view(), name='api_school_nutrition'),

    url(r'^boundary/assemblies$',
        AssemblyList.as_view(), name="api_assembly_list"),
    url(r'^boundary/assembly/(?P<id>[0-9]+)$',
        AssemblyDetails.as_view(), name="api_assembly_details"),
    url(r'^boundary/parliaments$',
        ParliamentList.as_view(), name="api_parliament_list"),
    url(r'^boundary/parliament/(?P<id>[0-9]+)$',
        ParliamentDetails.as_view(), name="api_parliament_details"),
    url(r'^boundary/parliament/(?P<id>[0-9]+)/assemblies$',
        AssemblyInParliament.as_view(), name="api_parliament_assemblies"),
    url(r'^boundary/pincode/(?P<pincode>[0-9]+)$',
        PincodeDetails.as_view(), name="api_pincode_details"),

    url(r'^boundary/admin/(?P<id>[0-9]+)$',
        AdminDetails.as_view(), name="api_admin_details"),
    url(r'^boundary/admin1s$', Admin1s.as_view(), name="api_admin1s"),
    url(r'^boundary/admin1/(?P<id>[0-9]+)/admin2$',
        Admin2sInsideAdmin1.as_view(), name="api_admin1s_admin2"),
    url(r'^boundary/admin1/(?P<id>[0-9]+)/admin3$',
        Admin3sInsideAdmin1.as_view(), name="api_admin1s_admin3"),
    url(r'^boundary/admin2s$', Admin2s.as_view(), name="api_admin2s"),
    url(r'^boundary/admin2/(?P<id>[0-9]+)/admin3$',
        Admin3sInsideAdmin2.as_view(), name="api_admin2s_admin3"),
    url(r'^boundary/admin3s$', Admin3s.as_view(), name="api_admin3s"),

    url(r'^geo/admin1/(?P<pk>[0-9]+)$', Admin1OfSchool.as_view(),
        name="api_school_admin1"),
    url(r'^geo/admin2/(?P<pk>[0-9]+)$', Admin2OfSchool.as_view(),
        name="api_school_admin2"),
    url(r'^geo/admin3/(?P<pk>[0-9]+)$', Admin3OfSchool.as_view(),
        name="api_school_admin3"),
    url(r'^geo/pincode/(?P<pk>[0-9]+)$', PincodeOfSchool.as_view(),
        name="api_school_pincode"),
    url(r'^geo/assembly/(?P<pk>[0-9]+)$', AssemblyOfSchool.as_view(),
        name="api_school_assembly"),
    url(r'^geo/parliament/(?P<pk>[0-9]+)$', ParliamentOfSchool.as_view(),
        name="api_school_parliament"),

    url('^users$', UsersView.as_view(), name='api_users'),
    url('^users/profile', UserProfileView.as_view(), name='api_user_profile'),
    url('^users/login$', 'users.api_views.login', name='api_user_login'),
    url('^users/logout$', 'users.api_views.logout', name='api_user_logout'),
    url('^users/test_authenticated', TestAuthenticatedView.as_view(),
        name='api_test_authenticated'),
    url('^users/(?P<pk>[0-9]+)$',
        OtherUserProfileView.as_view(), name='api_other_user_profile'),

    url(r'^password-reset/request$', 'users.api_views.password_reset_request',
        name="api_password_reset_request"),
    url(r'^password-change/$', PasswordChangeView.as_view(),
        name="api_password_change"),

    # SYS urls
    url(r'^stories/(?P<pk>[0-9]+)$', ShareYourStoryView.as_view(),
        name="api_share_story"),
    url(r'^stories/(?P<pk>[0-9]+)/questions$', StoryQuestionsView.as_view(),
        name="api_stories_questions"),
    url(r'^stories/$', StoriesView.as_view(),
        name="api_stories"),
    url(r'^stories/info/$', StoryInfoView.as_view(),
        name="api_stories_info"),
    url(r'^stories/meta/$', StoryMetaView.as_view(),
        name="api_stories_info"),
    url(r'^stories/details/$', StoryDetailView.as_view(),
        name="api_stories_info"),
    url(r'^stories/volume/$', StoryVolumeView.as_view(),
        name="api_stories_info"),

    url(
        r'^surveys/$',
        SurveysViewSet.as_view(ListCreateMapper),
        name="api_surveys"
    ),
    url(
        r'^surveys/(?P<pk>[0-9]+)/$',
        SurveysViewSet.as_view(RetrieveUpdateDestroyMapper),
        name="api_surveys_detail"
    ),
    url(
        r'^surveys/(?P<survey_pk>[0-9]+)/questions/$',
        SurveysQuestionsViewSet.as_view(ListCreateMapper),
        name="api_surveys_questions"
    ),
    url(
        r'^surveys/(?P<survey_pk>[0-9]+)/questions/(?P<pk>[0-9]+)/$',
        SurveysQuestionsViewSet.as_view(RetrieveUpdateDestroyMapper),
        name="api_surveys_questions_detail"
    ),

    url('^organizations$', OrganizationsView.as_view(),
        name='api_organizations_view'),
    url('^organizations/(?P<pk>[0-9]+)$', OrganizationView.as_view(),
        name='api_organization_view'),
    url('^organizations/(?P<org_pk>[0-9]+)/users$',
        OrganizationUsersView.as_view(),
        name='api_organizationusers_view'),
    url('^organizations/(?P<org_pk>[0-9]+)/users/(?P<user_pk>[0-9]+)$',
        OrganizationUserView.as_view(), name='api_organizationuser_view'),

    url('^volunteer_activities$',
        VolunteerActivitiesView.as_view(),
        name='api_volunteeractivities_view'),
    url('^volunteer_activities/(?P<pk>[0-9]+)$',
        VolunteerActivityView.as_view(),
        name='api_volunteeractvity_view'),
    url('^volunteer_activities/(?P<activity_pk>[0-9]+)/users$',
        VolunteerActivityUsersView.as_view(),
        name='api_volunteeractvityusers_view'),
    url('^volunteer_activities/(?P<activity_pk>[0-9]+)/users/(?P<user_pk>[0-9]+)$',
        VolunteerActivityUserView.as_view(),
        name='api_volunteeractivityuser_view'),

    url('^volunteer_activity_dates',
        'users.api_views.volunteer_activity_dates',
        name='api_volunteeractivitydates_view'),

    url('^volunteer_activity_types$',
        VolunteerActivityTypesView.as_view(),
        name='api_volunteeractivitytypes_view'),
    url('^volunteer_activity_types/(?P<pk>[0-9]+)',
        VolunteerActivityTypeView.as_view(),
        name='api_volunteeractivitytype_view'),

    url('^donation_requirements/$',
        DonationRequirementListView.as_view(),
        name='api_donationrequirementlist_view'),

    url('^donation_requirements/(?P<pk>[0-9]+)/$',
        DonationRequirementDetailsView.as_view(),
        name='api_donationrequirement_view'),

    url('^donation_requirements/(?P<requirement_pk>[0-9]+)/items/$',
        DonationItemListView.as_view(),
        name='api_donationitemlist_view'),

    url('^donation_requirements/(?P<requirement_pk>[0-9]+)/items/(?P<pk>[0-9]+)$',
        DonationItemDetailsView.as_view(),
        name='api_donationitem_view'),

    url('^donation_requirements/(?P<requirement_pk>[0-9]+)/items/(?P<item_pk>[0-9]+)/users$',
        DonationUsersView.as_view(),
        name='api_donationusers_view'),

    url('^donation_requirements/(?P<requirement_pk>[0-9]+)/items/(?P<item_pk>[0-9]+)/users/(?P<pk>[0-9]+)$',
        DonationUserView.as_view(),
        name='api_donationuser_view'),

    # url('^donation_requirements/donate$',
    #     UserDonationItemCreateView.as_view(),
    #     name='api_donate_create_view'),

    # url('^donation_requirements/donate/(?P<pk>[0-9]+)$',
    #     UserDonationItemModifyView.as_view(),
    #     name='api_donate_modify_view'),

    # url('^donor_requirements$',
    #     DonorRequirementsView.as_view(),
    #     name='api_donorrequirements_view'),
    # url('^donor_requirements/(?P<pk>[0-9]+)$',
    #     DonorRequirementView.as_view(),
    #     name='api_donorrequirement_view'),
    # url('^donor_requirements/(?P<requirement_pk>[0-9]+)/users$',
    #     DonorRequirementUsersView.as_view(),
    #     name='api_donorrequirementusers_view'),
    # url('^donor_requirements/(?P<requirement_pk>[0-9]+)/users/(?P<user_pk>[0-9]+)$',
    #     DonorRequirementUserView.as_view(),
    #     name='api_donorrequirementuser_view'),

    url('^donation_item_categories$',
        DonationItemCategoriesView.as_view(),
        name='api_donationitemcategories_view'),

    # url('^donation_types$',
    #     DonationTypesView.as_view(),
    #     name='api_donationtypes_view'),
    # url('^donation_types/(?P<pk>[0-9]+)',
    #     DonationTypeView.as_view(),
    #     name='api_donationtype_view'),

    # Aggregation Views
    url(r'^aggregation/assembly/(?P<id>[0-9]+)/schools/$',
        AssemblySchoolAggView.as_view(), name='api_aggregation_assembly_schools'),
    url(r'^aggregation/parliament/(?P<id>[0-9]+)/schools/$',
        ParliamentSchoolAggView.as_view(), name='api_aggregation_parliament_schools'),
    url(r'^aggregation/pincode/(?P<id>[0-9]+)/schools/$',
        PincodeSchoolAggView.as_view(), name='api_aggregation_pincode_schools'),
    url(r'^aggregation/boundary/(?P<id>[0-9]+)/schools/$',
        BoundarySchoolAggView.as_view(), name='api_aggregation_boundary_schools'),
    url(r'^aggregation/boundary/(?P<id>[0-9]+)/library-level/$',
        BoundaryLibLevelAggView.as_view(), name='api_aggregation_boundary_liblevel'),
    url(r'^aggregation/boundary/(?P<id>[0-9]+)/library-language/$',
        BoundaryLibLangAggView.as_view(), name='api_aggregation_boundary_liblang'),

    # Assessment urls
    url(r'^partners/$', PartnerList.as_view(), name='api_partner_list'),
    url(r'^assessment/$',
        AssessmentsList.as_view(), name='api_assessment_list'),
    url(r'^assessment/(?P<assessment_id>[0-9]+)/$',
        AssessmentInfo.as_view(), name='api_assessment_info'),
    url(r'^programme/$',
        ProgrammesList.as_view(), name='api_programme_list'),
    url(r'^programme/(?P<programme_id>[0-9]+)/$',
        ProgrammeInfo.as_view(), name='api_programme_info'),
    url(r'^programme/percentile/(?P<programme_id>[0-9]+)/$',
        ProgrammePercentile.as_view(), name='api_programme_percentile'),

    url(r'^ivrs/', include('ivrs.api_urls')),

    # Reports urls
    url(r'^reports/', include('reports.api_urls'))
    #url(r'^reports/(?P<boundary>["admin_1", "admin_2", "admin_3", "assembly", "partliament"]+)/(?P<id>[0-9]+)/(?P<report_type>["finance", "demographics"]+)/(?P<language>["kannada", "english"]+)/$',
        #ReportsDetail.as_view(), name='api_reports_detail'),
)
