from schools.models import Boundary, Assembly, Parliament, Postal, MeetingReport
from common.views import KLPListAPIView, KLPDetailAPIView
from common.mixins import CacheMixin
from schools.serializers import (
    BoundarySerializer, BoundaryWithParentSerializer, AssemblySerializer,
    ParliamentSerializer, PincodeSerializer)
from django.db.models import Q
from django.conf import settings

class AdminDetails(KLPDetailAPIView, CacheMixin):
    """Returns details for a particular admin level

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'
    lookup_url_kwarg = 'id'

    def get_queryset(self):
        return Boundary.objects.all_active()


class AssemblyList(KLPListAPIView):
    """Returns list of assemblies"""
    serializer_class = AssemblySerializer
    bbox_filter_field = 'coord'

    def get_queryset(self):
        qset = Assembly.objects.all()

        query = self.request.GET.get('query', '')
        if query:
            qset = qset.filter(name__icontains=query)

        return qset


class ParliamentList(KLPListAPIView):
    """Returns list of assemblies"""
    serializer_class = ParliamentSerializer
    bbox_filter_field = 'coord'

    def get_queryset(self):
        qset = Parliament.objects.all()

        query = self.request.GET.get('query', '')
        if query:
            qset = qset.filter(name__icontains=query)

        return qset


class AssemblyInParliament(KLPListAPIView):
    """Returns list of assemblies"""
    serializer_class = AssemblySerializer
    bbox_filter_field = 'coord'

    def get_queryset(self):
        parliament_id = self.kwargs.get('id')
        try:
            parliament = Parliament.objects.get(id=parliament_id)
        except Exception, e:
            raise e

        assemblies = Assembly.objects.filter(coord__contained=parliament.coord)
        return assemblies


class AssemblyDetails(KLPDetailAPIView, CacheMixin):
    """Returns details for a particular Assembly level

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = AssemblySerializer
    bbox_filter_field = 'coord'
    lookup_url_kwarg = 'id'

    def get_queryset(self):
        return Assembly.objects.all()


class ParliamentDetails(KLPDetailAPIView, CacheMixin):
    """Returns details for a particular Parliamentary level

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = ParliamentSerializer
    bbox_filter_field = 'coord'
    lookup_url_kwarg = 'id'

    def get_queryset(self):
        return Parliament.objects.all()


class PincodeDetails(KLPDetailAPIView, CacheMixin):
    """Returns details for a particular Pincode

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = PincodeSerializer
    bbox_filter_field = 'coord'
    lookup_url_kwarg = 'pincode'
    lookup_field = 'pincode'

    def get_queryset(self):
        return Postal.objects.all()


class Admin1s(KLPListAPIView, CacheMixin):
    """Returns a list of districts

    school_type -- [all]/preschools/primaryschools - school types to return
    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        btype = self.request.GET.get('school_type', 'all')
        meetingreport = self.request.GET.get('meetingreport', None)
        qset = Boundary.objects.all_active().filter(id__gte=settings.STATE_STARTING_BOUNDARY_ID)\
            .select_related('boundarycoord__coord', 'hierarchy__name')\
            .prefetch_related('hierarchy')

        if btype == 'preschools':
            qset = qset.filter(hierarchy_id=13)
        elif btype == 'primaryschools':
            qset = qset.filter(hierarchy_id=9)
        else:
            qset = qset.filter(hierarchy__name='district')

        if meetingreport:
            admin1_ids = MeetingReport.objects.all(
            ).order_by(
            ).values_list(
                'school__schooldetails__admin1',
                flat=True
            ).distinct(
                'school__schooldetails__admin1'
            )
            qset = qset.filter(id__in=admin1_ids)

        return qset


class Admin2sInsideAdmin1(KLPListAPIView):
    """
    Returns a list of all blocks/projects inside given district
    (id and name)

    PreSchool Example:
        http://localhost:8001/api/v1/boundary/admin1/8773/admin2

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        admin1_id = self.kwargs.get('id', 0)
        admin1 = Boundary.objects.get(id=admin1_id)
        return Boundary.objects.all_active().filter(
            parent_id=admin1_id, 
            type=admin1.type
        ).select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin3sInsideAdmin1(KLPListAPIView):
    """
    Returns a list of all clusters/circles
    inside given district (id and name)

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        admin1_id = self.kwargs.get('id', 0)
        admin1 = Boundary.objects.get(id=admin1_id)
        return Boundary.objects.all_active().filter(
            parent__parent_id=admin1_id,
            type=admin1.type
        ).select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name')


class Admin2s(KLPListAPIView, CacheMixin):
    """Returns a list of blocks/projects

    school_type -- [all]/preschools/primaryschools - school types to return
    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        btype = self.request.GET.get('school_type', 'all')
        meetingreport = self.request.GET.get('meetingreport', None)
        qset = Boundary.objects.all_active().filter(id__gte=settings.STATE_STARTING_BOUNDARY_ID)\
            .select_related('boundarycoord__coord', 'parent__hierarchy', 'hierarchy__name')\
            .prefetch_related('parent', 'hierarchy')

        if btype == 'preschools':
            qset = qset.filter(hierarchy__name='project')
        elif btype == 'primaryschools':
            qset = qset.filter(hierarchy__name='block')
        else:
            qset = qset.filter(hierarchy__name__in=['block', 'project'])

        if meetingreport:
            admin2_ids = MeetingReport.objects.all(
            ).order_by(
            ).values_list(
                'school__schooldetails__admin2',
                flat=True
            ).distinct(
                'school__schooldetails__admin2'
            )
            qset = qset.filter(id__in=admin2_ids)


        return qset


class Admin3sInsideAdmin2(KLPListAPIView):
    """Returns a list of all clusters/circles inside given block/project

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        admin2_id = self.kwargs.get('id', 0)
        admin2 = Boundary.objects.get(id=admin2_id)
        return Boundary.objects.all_active().filter(parent_id=admin2_id, type=admin2.type)\
            .select_related('boundarycoord__coord', 'type__name', 'hierarchy__name')


class Admin3s(KLPListAPIView, CacheMixin):
    """Returns a list of custers/circles

    school_type -- [all]/preschools/primaryschools - school types to return
    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_queryset(self):
        btype = self.request.GET.get('school_type', 'all')
        meetingreport = self.request.GET.get('meetingreport', None)
        qset = Boundary.objects.all_active().filter(id__gte=settings.STATE_STARTING_BOUNDARY_ID)\
            .select_related('boundarycoord__coord', 'parent__hierarchy', 'hierarchy__name')\
            .prefetch_related('parent', 'hierarchy')

        if btype == 'preschools':
            qset = qset.filter(hierarchy__name='circle')
        elif btype == 'primaryschools':
            qset = qset.filter(hierarchy__name='cluster')
        else:
            qset = qset.filter(hierarchy__name__in=['cluster', 'circle'])

        if meetingreport:
            admin3_ids = MeetingReport.objects.all(
            ).order_by(
            ).values_list(
                'school__schooldetails__admin3',
                flat=True
            ).distinct(
                'school__schooldetails__admin3'
            )
            qset = qset.filter(id__in=admin3_ids)


        return qset
