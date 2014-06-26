from schools.models import Boundary
from common.views import KLPListAPIView
from schools.serializers import BoundarySerializer,\
    BoundaryWithParentSerializer
from django.db.models import Q


class Admin1s(KLPListAPIView):
    '''
        Returns a list of all districts (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='district')\
            .select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin2sInsideAdmin1(KLPListAPIView):
    '''
        Returns a list of all blocks/projects inside given district
        (id and name)

        PreSchool Example:
            http://localhost:8001/api/v1/boundary/admin1/8773/admin2
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        admin1_id = self.kwargs.get('id', 0)
        admin1 = Boundary.objects.get(id=admin1_id)
        return Boundary.objects.filter(parent_id=admin1_id, type=admin1.type)\
            .select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin3sInsideAdmin1(KLPListAPIView):
    '''
        Returns a list of all clusters/circles
        inside given district (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        admin1_id = self.kwargs.get('id', 0)
        admin1 = Boundary.objects.get(id=admin1_id)
        return Boundary.objects.filter(parent__parent_id=admin1_id,
                                       type=admin1.type)\
            .select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin2s(KLPListAPIView):
    '''
        Returns a list of all blocks (id and name)
    '''
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(Q(hierarchy__name='block') |
                                       Q(hierarchy__name='project'))\
            .select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin3sInsideAdmin2(KLPListAPIView):
    '''
        Returns a list of all clusters inside given block (id and name)
    '''
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        admin2_id = self.kwargs.get('id', 0)
        admin2 = Boundary.objects.get(id=admin2_id)
        return Boundary.objects.filter(parent_id=admin2_id, type=admin2.type)\
            .select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin3s(KLPListAPIView):
    '''
        Returns a list of all districts (id and name)
    '''
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        return Boundary.objects.filter(Q(hierarchy__name='cluster') |
                                       Q(hierarchy__name='circle'))\
            .select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')
