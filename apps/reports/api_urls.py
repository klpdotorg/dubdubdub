from django.conf.urls import patterns, url
# from django.views.decorators.cache import cache_page


from api_views import (
    DemographicsBoundaryReportDetails, BoundarySummaryReport,
    DemographicsBoundaryComparisonDetails, DiseBoundaryDetails,
    DemographicsElectedRepReportDetails, DemographicsElectedRepComparisonDetails,
    ElectedRepInfo, ElectedRepSummaryReport
)

urlpatterns = patterns(
    '',

    # Reports urls
    url(r'summary/boundary/$',
        BoundarySummaryReport.as_view(), name='api_reports_detail'),
    url(r'demographics/boundary/details/$',
        DemographicsBoundaryReportDetails.as_view(), name='api_reports_detail'),
    url(r'summary/electedrep/$',
        ElectedRepSummaryReport.as_view(), name='api_reports_detail'),
    url(r'demographics/electedrep/details/$',
        DemographicsElectedRepReportDetails.as_view(), name='api_reports_detail'),
    url(r'demographics/boundary/comparison/$',
        DemographicsBoundaryComparisonDetails.as_view(), name='api_reports_detail'),
    url(r'demographics/electedrep/comparison/$',
        DemographicsElectedRepComparisonDetails.as_view(),
        name='api_reports_detail'),
    url(r'dise/boundary/$',
        DiseBoundaryDetails.as_view(), name='api_reports_detail'),
    url(r'electedrep/$', ElectedRepInfo.as_view(), name='api_reports_detail')

)
