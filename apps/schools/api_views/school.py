from schools.models import School, DiseInfo
from schools.filters import SchoolFilter
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.models import SumCase
from common.mixins import CacheMixin
from schools.serializers import SchoolListSerializer, SchoolInfoSerializer,\
    SchoolDiseSerializer, SchoolDemographicsSerializer,\
    SchoolProgrammesSerializer, SchoolFinanceSerializer, SchoolInfraSerializer,\
    SchoolLibrarySerializer
from django.contrib.gis.geos import Polygon
from django.http import Http404
import re


class SchoolsList(KLPListAPIView, CacheMixin):
    '''
        Returns list of schools with id and name.
    '''
    serializer_class = SchoolListSerializer
    bbox_filter_field = "instcoord__coord"
    filter_class = SchoolFilter
    search_fields = ('name',)

    def get_queryset(self):
        qset = School.objects.filter(status=2)
        get_geom = self.request.GET.get('geometry', 'no')
        if get_geom == 'yes':
            qset = qset.select_related('instcoord')

        stype = self.request.GET.get('type', 'all')

        if stype == 'preschools':
            qset = qset.filter(schooldetails__type=2)
        elif stype == 'primaryschools':
            qset = qset.filter(schooldetails__type=1)
        qset = qset.select_related('schooldetails__type')

        if self.request.GET.get('admin1', ''):
            admin1 = self.request.GET.get('admin1')
            qset = qset.filter(schooldetails__admin1_id=admin1)

        if self.request.GET.get('admin2', ''):
            admin2 = self.request.GET.get('admin2')
            qset = qset.filter(schooldetails__admin2_id=admin2)

        if self.request.GET.get('admin3', ''):
            admin3 = self.request.GET.get('admin3')
            qset = qset.filter(schooldetails__admin3_id=admin3)

        return qset


class SchoolsInfo(SchoolsList, CacheMixin):
    '''
        Returns list of schools with more info about each school
        for /schools/info
    '''
    serializer_class = SchoolInfoSerializer
    filter_class = SchoolFilter
    search_fields = ('name',)

    def get_queryset(self):
        # inherit all the filtering from SchoolsList
        qset = super(SchoolsInfo, self).get_queryset()

        qset = qset.select_related('address', 'schooldetails__admin3',
                            'schooldetails__admin2', 'schooldetails__admin1',
                            'schooldetails__type', 'schooldetails__assembly',
                            'schooldetails__parliament', 'electedrep__ward',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy',)\
            .prefetch_related('dise_info__disefacilityagg_set')
        return qset


class SchoolsDiseInfo(KLPListAPIView):
    '''
        Returns list of schools with DISE data
    '''
    # test url:
    # http://localhost:8001/api/v1/schools/dise/2011-12?in_bbox=77.349415,12.822471,77.904224,14.130930
    serializer_class = SchoolDiseSerializer
    bbox_filter_field = "school__instcoord__coord"

    def get_queryset(self):
        year = self.kwargs.get('year', '2011-12')
        schools = DiseInfo.objects.filter(acyear=year, school__status=2)\
            .select_related('instcoord', 'school')
        print schools.query
        return schools


class SchoolInfo(KLPDetailAPIView):
    '''
        Returns info for a single school. for /school/:id
    '''
    serializer_class = SchoolInfoSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('instcoord', 'address', 'schooldetails__admin3',
                            'schooldetails__admin2', 'schooldetails__admin1',
                            'schooldetails__type', 'schooldetails__assembly',
                            'schooldetails__parliament', 'electedrep__ward',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy')


class SchoolDemographics(KLPDetailAPIView):
    serializer_class = SchoolDemographicsSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info',)


class SchoolInfra(KLPDetailAPIView):
    serializer_class = SchoolInfraSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info', 'schooldetails', 'schooldetails__admin3',
                            'schooldetails__type',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy',
                            'schooldetails__admin2', 'schooldetails__admin1')


class SchoolLibrary(KLPDetailAPIView):
    serializer_class = SchoolLibrarySerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info', 'schooldetails', 'schooldetails__admin3',
                            'schooldetails__type',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy',
                            'schooldetails__admin2', 'schooldetails__admin1',
                            'libinfra', 'studentgroup__students__studentstudentgroup__academic_year')


class SchoolProgrammes(KLPDetailAPIView):
    serializer_class = SchoolProgrammesSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info',)


class SchoolFinance(KLPDetailAPIView):

    # DISE data is yearly. Needs year as param or send list maybe
    serializer_class = SchoolFinanceSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info',)
