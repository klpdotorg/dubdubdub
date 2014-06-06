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
        'Schools List': reverse('api_schools_list', request=request, format=format),
        'Schools Info': reverse('api_schools_info', request=request, format=format),
        'Schools DISE Info': reverse('api_schools_dise', request=request, format=format, kwargs={'year': '2011-12'}),
        'School Info': reverse('api_school_info', request=request, format=format, kwargs={'pk': 3573}),
        'School Demographics': reverse('api_school_demo', request=request, format=format, kwargs={'pk': 3573}),
        'School Programmes': reverse('api_school_prog', request=request, format=format, kwargs={'pk': 3573}),
        'School Finance': reverse('api_school_finance', request=request, format=format, kwargs={'pk': 3573}),        
        'Districts': reverse('api_districts', request=request, format=format),
        'Blocks in District': reverse('api_districts_block', request=request, format=format, kwargs={'id': 445}),
        'Clusters in District': reverse('api_districts_cluster', request=request, format=format, kwargs={'id': 445}),    
        'Blocks': reverse('api_blocks', request=request, format=format),
        'Clusters in Block': reverse('api_blocks_clusters', request=request, format=format, kwargs={'id': 8889}),
        'Clusters': reverse('api_clusters', request=request, format=format),
        'District of School': reverse('api_school_district', request=request, format=format, kwargs={'pk': 3573}),
        'Block of School': reverse('api_school_block', request=request, format=format, kwargs={'pk': 3573}),
        'Cluster of School': reverse('api_school_cluster', request=request, format=format, kwargs={'pk': 3573}),
    })
