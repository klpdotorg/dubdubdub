from schools.models import AcademicYear
from schools.serializers import (
    BoundaryLibLangAggSerializer, BoundaryLibLevelAggSerializer,
    BoundarySchoolAggSerializer
)
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.exceptions import APIError
from django.conf import settings
from django.db.models import Q, Count


class BoundaryLibLangAggView(KLPListAPIView):
    model = BoundaryLibLangAggSerializer.Meta.model
    serializer_class = BoundaryLibLangAggSerializer

    def get_queryset(self):
        boundary_id = self.kwargs.get('id')

        BoundaryLibLangAgg = BoundaryLibLangAggSerializer.Meta.model
        return BoundaryLibLangAgg.objects.filter(boundary_id=boundary_id)


class BoundaryLibLevelAggView(KLPListAPIView):
    model = BoundaryLibLevelAggSerializer.Meta.model
    serializer_class = BoundaryLibLevelAggSerializer

    def get_queryset(self):
        boundary_id = self.kwargs.get('id')

        BoundaryLibLevelAgg = BoundaryLibLevelAggSerializer.Meta.model
        return BoundaryLibLevelAgg.objects.filter(boundary_id=boundary_id)


class BoundarySchoolAggView(KLPListAPIView):
    model = BoundarySchoolAggSerializer.Meta.model
    serializer_class = BoundarySchoolAggSerializer

    def get_queryset(self):
        boundary_id = self.kwargs.get('id')
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)

        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.')

        BoundarySchoolAgg = BoundarySchoolAggSerializer.Meta.model
        return BoundarySchoolAgg.objects.filter(
            Q(academic_year=academic_year),
            Q(admin1_id=boundary_id) | Q(admin2_id=boundary_id) | Q(admin3_id=boundary_id)
        )
