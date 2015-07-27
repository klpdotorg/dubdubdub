from schools.models import AcademicYear, Boundary, BoundarySchoolAgg
from schools.serializers import (
    BoundaryLibLangAggSerializer, BoundaryLibLevelAggSerializer,
    BoundarySerializer
)
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.exceptions import APIError
from django.conf import settings
from django.db.models import Q, Count, Sum
from rest_framework.response import Response
from rest_framework import exceptions


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


class BoundarySchoolAggView(KLPAPIView):
    def get(self, request, id=None):
        boundary_id = id
        year = request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)

        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)

        try:
            boundary = Boundary.objects.get(pk=boundary_id)
        except Exception:
            raise APIError('Boundary not found', 404)

        school_agg = BoundarySchoolAgg.objects.filter(**{
            'academic_year_id': academic_year.id,
            'admin{admin_level}_id'.format(admin_level=boundary.get_admin_level()): boundary.id
        })

        if school_agg.count() == 0:
            raise APIError('No data found for given boundary', 404)

        agg = school_agg.aggregate(
            num_school=Sum('num_school'),
            num_preschool=Sum('num_preschool'),
            num_boys_school=Sum('num_boys_school'),
            num_girls_school=Sum('num_girls_school'),
            num_boys=Sum('num_boys'),
            num_girls=Sum('num_girls')
        )

        agg['moi'] = boundary.schools().values('moi').annotate(num=Count('moi'))
        agg['cat'] = boundary.schools().values('cat').annotate(num=Count('cat'))
        agg['mgmt'] = boundary.schools().values('mgmt').annotate(num=Count('mgmt'))

        agg['boundary'] = BoundarySerializer(boundary).data

        # Not using serializer because we need to do the aggregations here
        # and return the results directly
        return Response(agg)
