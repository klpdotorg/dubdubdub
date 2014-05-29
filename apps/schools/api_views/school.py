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

    def get_queryset(self):
        year = self.kwargs.get('year', 2010)
        # FIXIT: year must be like 2011-12
        return School.objects.filter(dise_info__acyear=year)


class SchoolInfo(KLPDetailAPIView):
    serializer_class = SchoolInfoSerializer
    model = School
