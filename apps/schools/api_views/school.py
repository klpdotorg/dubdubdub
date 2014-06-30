from schools.models import School, DiseInfo
from common.views import KLPListAPIView, KLPDetailAPIView
from common.models import SumCase
from schools.serializers import SchoolListSerializer, SchoolInfoSerializer,\
    SchoolDiseSerializer, SchoolDemographicsSerializer,\
    SchoolProgrammesSerializer, SchoolFinanceSerializer, SchoolInfraSerializer
from django.contrib.gis.geos import Polygon
from django.http import Http404
import re


class SchoolsList(KLPListAPIView):
    '''
        Returns list of schools with id and name.
    '''
    serializer_class = SchoolListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        qset = School.objects.filter(status=2)
        get_geom = self.request.GET.get('geometry', 'no')
        if get_geom == 'yes':
            qset = qset.select_related('instcoord')
        return qset


class SchoolsInfo(SchoolsList):
    '''
        Returns list of schools with more info about each school
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
                            'schooldetails__admin3__hierarchy',)


class SchoolsDiseInfo(KLPListAPIView):
    '''
        Returns list of schools with DISE data
    '''
    # test url:
    # http://localhost:8001/api/v1/schools/dise/2011-12?in_bbox=77.349415,12.822471,77.904224,14.130930
    serializer_class = SchoolDiseSerializer
    bbox_filter_field = "school__instcoord__coord"

    def get_queryset(self):
        year = self.kwargs.get('year', '2010-11')
        schools = DiseInfo.objects.filter(acyear=year)\
            .select_related('instcoord', 'school')
        print schools.query
        return schools


class SchoolInfo(KLPDetailAPIView):
    '''
        Returns info for a single school.
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
                            'schooldetails__admin3__hierarchy',)


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
