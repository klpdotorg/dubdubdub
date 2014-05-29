from schools.models import School
from common.views import KLPListAPIView, KLPDetailAPIView
from schools.serializers import SchoolListSerializer, SchoolInfoSerializer, SchoolDiseSerializer


class SchoolsList(KLPListAPIView):
    serializer_class = SchoolListSerializer
    bbox_filter_field = "instcoord__coord"
    queryset = School.objects.all().select_related('instcoord')


class SchoolsInfo(SchoolsList):
    serializer_class = SchoolInfoSerializer


class SchoolsDiseInfo(KLPListAPIView):
    serializer_class = SchoolDiseSerializer
    queryset = School.objects.all().select_related('dise_info')


class SchoolInfo(KLPDetailAPIView):
    serializer_class = SchoolInfoSerializer
    model = School
