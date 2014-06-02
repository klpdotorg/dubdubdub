from schools.models import School
from common.views import KLPListAPIView, KLPDetailAPIView
from schools.serializers import SchoolListSerializer, SchoolInfoSerializer, SchoolDiseSerializer
from django.contrib.gis.geos import Polygon
import re

class SchoolsList(KLPListAPIView):
    serializer_class = SchoolListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        qset = School.objects.all()
        get_geom = self.request.GET.get('geometry', 'no')
        if get_geom == 'yes':
            qset = qset.select_related('instcoord')
        return qset


class SchoolsInfo(SchoolsList):
    serializer_class = SchoolInfoSerializer


class SchoolsDiseInfo(KLPListAPIView):
    # test url: http://localhost:8001/api/v1/schools/dise/2011-12?in_bbox=77.349415,12.822471,77.904224,14.130930
    serializer_class = SchoolDiseSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        year = self.kwargs.get('year', '2010-11')
        schools = School.objects.filter(dise_info__acyear=year).select_related('instcoord', 'dise_info')
        # print schools.query
        return schools


class SchoolInfo(KLPDetailAPIView):
    serializer_class = SchoolInfoSerializer
    model = School
