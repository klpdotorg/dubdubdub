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
        btype = self.request.GET.get('school_type', 'all')
        qset = Boundary.objects\
            .select_related('boundarycoord__coord')\
            .prefetch_related('hierarchy')

        if btype == 'preschools':
            qset = qset.filter(hierarchy_id=13)
        elif btype == 'primaryschools':
            qset = qset.filter(hierarchy_id=9)
        else:
            qset = qset.filter(hierarchy__name='district')

        return qset

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
        btype = self.request.GET.get('school_type', 'all')
        qset = Boundary.objects\
            .select_related('boundarycoord__coord')\
            .prefetch_related('parent', 'hierarchy')

        if btype == 'preschools':
            qset = qset.filter(hierarchy__name='project')
        elif btype == 'primaryschools':
            qset = qset.filter(hierarchy__name='block')
        else:
            qset = qset.filter(hierarchy__name__in=['block', 'project'])

        return qset


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
        btype = self.request.GET.get('school_type', 'all')
        qset = Boundary.objects\
            .select_related('boundarycoord__coord')\
            .prefetch_related('parent', 'hierarchy')

        if btype == 'preschools':
            qset = qset.filter(hierarchy__name='circle')
        elif btype == 'primaryschools':
            qset = qset.filter(hierarchy__name='cluster')
        else:
            qset = qset.filter(hierarchy__name__in=['cluster', 'circle'])

        return qset
