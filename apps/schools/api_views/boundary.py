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


class Blocks(KLPListAPIView):
    '''
        Returns a list of all districts (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='block').select_related('boundarycoord', 'type')


class Clusters(KLPListAPIView):
    '''
        Returns a list of all districts (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='cluster').select_related('boundarycoord', 'type')
