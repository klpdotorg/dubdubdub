from schools.models import Boundary
from common.views import KLPListAPIView
from schools.serializers import BoundarySerializer

class Districts(KLPListAPIView):
    '''
        Returns a list of all districts (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='district').select_related('boundarycoord', 'type')


class BlocksInsideDistrict(KLPListAPIView):
    '''
        Returns a list of all blocks inside given district (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        district_id = self.kwargs.get('id', 0)
        return Boundary.objects.filter(hierarchy__name='block', parent_id=district_id).select_related('boundarycoord', 'type')


class ClustersInsideDistrict(KLPListAPIView):
    '''
        Returns a list of all clusters inside given district (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        district_id = self.kwargs.get('id', 0)
        return Boundary.objects.filter(hierarchy__name='cluster', parent__parent_id=district_id).select_related('boundarycoord', 'type')


class Blocks(KLPListAPIView):
    '''
        Returns a list of all blocks (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='block').select_related('boundarycoord', 'type')


class ClustersInsideBlock(KLPListAPIView):
    '''
        Returns a list of all clusters inside given block (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        block_id = self.kwargs.get('id', 0)
        return Boundary.objects.filter(hierarchy__name='cluster', parent_id=block_id).select_related('boundarycoord', 'type')


class Clusters(KLPListAPIView):
    '''
        Returns a list of all districts (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='cluster').select_related('boundarycoord', 'type')
