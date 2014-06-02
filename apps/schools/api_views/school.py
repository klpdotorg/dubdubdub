from schools.models import School, DiseInfo
from common.views import KLPListAPIView, KLPDetailAPIView
from schools.serializers import SchoolListSerializer, SchoolInfoSerializer, SchoolDiseSerializer
from django.contrib.gis.geos import Polygon
import re

class SchoolsList(KLPListAPIView):
    '''
        Returns list of schools with id and name.  
    '''
    serializer_class = SchoolListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        qset = School.objects.all()
        get_geom = self.request.GET.get('geometry', 'no')
        if get_geom == 'yes':
            qset = qset.select_related('instcoord')
        return qset


class SchoolsInfo(SchoolsList):
    '''
        Returns list of schools with more info about each school
    '''
    serializer_class = SchoolInfoSerializer


class SchoolsDiseInfo(KLPListAPIView):
    '''
        Returns list of schools with DISE data
    '''
    # test url: http://localhost:8001/api/v1/schools/dise/2011-12?in_bbox=77.349415,12.822471,77.904224,14.130930
    serializer_class = SchoolDiseSerializer
    bbox_filter_field = "school__instcoord__coord"

    def get_queryset(self):
        year = self.kwargs.get('year', '2010-11')
        schools = DiseInfo.objects.filter(acyear=year).select_related('instcoord', 'school')
        print schools.query
        return schools


class SchoolInfo(KLPDetailAPIView):
    '''
        Returns info for a single school.
    '''
    serializer_class = SchoolInfoSerializer
    model = School
