from .school import SchoolsList, SchoolsInfo, SchoolInfo, SchoolsDiseInfo,\
    SchoolDemographics, SchoolProgrammes, SchoolFinance
from .boundary import Districts, BlocksInsideDistrict, ClustersInsideDistrict, \
    Blocks, ClustersInsideBlock, Clusters
from .geo import DistrictOfSchool, BlockOfSchool, ClusterOfSchool

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

@api_view(('GET',))
def api_root(request, format=None):
    return Response({
        'schools_list': reverse('api_schools_list', request=request, format=format),
        'schools_info': reverse('api_schools_info', request=request, format=format),
        'schools_dise': reverse('api_schools_dise', request=request, format=format, kwargs={'year': '2011-12'}),
        'school_info': reverse('api_school_info', request=request, format=format, kwargs={'pk': 3573}),
        'school_demo': reverse('api_school_demo', request=request, format=format, kwargs={'pk': 3573}),
        'districts': reverse('api_districts', request=request, format=format),
    })