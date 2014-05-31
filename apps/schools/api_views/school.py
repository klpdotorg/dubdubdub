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
    serializer_class = SchoolDiseSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        year = self.kwargs.get('year', '2010-11')
        bbox = self.request.QUERY_PARAMS.get('bbox', None)
        print bbox
        schools = School.objects.filter(dise_info__acyear=year).select_related('instcoord', 'dise_info')
        
        if bbox:
            bbox_filter = dict()
            coords_match = re.match(r"([\d\.]+),([\d\.]+),([\d\.]+),([\d\.]+)", bbox)

            if coords_match and len(coords_match.groups()) == 4:
                bbox = map(lambda x: float(x), coords_match.groups())
                geom = Polygon.from_bbox(bbox)
                
                bbox_filter[self.bbox_filter_field + '__contained'] = geom
                schools = schools.filter(**bbox_filter)

        print schools.query
        return schools


class SchoolInfo(KLPDetailAPIView):
    serializer_class = SchoolInfoSerializer
    model = School
