from django.conf.urls import patterns, url
# from django.views.decorators.cache import cache_page


from api_views import (
    DemographicsBoundaryReportDetails, ReportBoundarySummary,
    DemographicsBoundaryComparisonDetails, DiseBoundaryDetails,
    DemographicsElectedRepReportDetails, DemographicsElectedRepComparisonDetails,
    ElectedRepInfo
)

urlpatterns = patterns(
    '',

    # Reports urls
    url(r'summary/$',
        ReportBoundarySummary.as_view(), name='api_reports_detail'),
    url(r'demographics/boundary/details/$',
        DemographicsBoundaryReportDetails.as_view(), name='api_reports_detail'),
    url(r'demographics/assembly/details/$',
        DemographicsElectedRepReportDetails.as_view(), name='api_reports_detail'),
    url(r'demographics/boundary/comparison/$',
        DemographicsBoundaryComparisonDetails.as_view(), name='api_reports_detail'),
    url(r'demographics/assembly/comparison/$',
        DemographicsElectedRepComparisonDetails.as_view(), name='api_reports_detail'),
    url(r'dise/boundary/$',
        DiseBoundaryDetails.as_view(), name='api_reports_detail'),
    url(r'electedrep/$', ElectedRepInfo.as_view(), name='api_reports_detail')

)
