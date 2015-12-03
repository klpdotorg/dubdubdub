from schools.models import AcademicYear, School, Boundary, Assembly, Parliament, Postal
from schools.serializers import (
    BoundaryLibLangAggSerializer, BoundaryLibLevelAggSerializer,
    BoundarySerializer, AssemblySerializer, ParliamentSerializer,
    PincodeSerializer, BoundaryWithGrandparentSerializer
)

import dubdubdub.urls

from common.models import SumCase
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.exceptions import APIError
from django.conf import settings
from django.db.models import Q, Count, Sum
from django.core.urlresolvers import resolve
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


class BaseSchoolAggView(object):
    def get_aggregations(self, active_schools, academic_year):
        active_schools = active_schools.filter(schoolextra__academic_year=academic_year)
        agg = {
            'num_schools': active_schools.count(),
            'moi': active_schools.values('moi').annotate(num=Count('moi')),
            'cat': active_schools.values('cat').annotate(
                num_schools=Count('cat'),
                num_boys=Sum('schoolextra__num_boys'),
                num_girls=Sum('schoolextra__num_girls')
            ),
            'mgmt': active_schools.values('mgmt').annotate(num=Count('mgmt')),
            'gender': active_schools.values('sex').annotate(num=Count('sex'))
        }

        active_institutions = active_schools.filter(institutionagg__academic_year=academic_year)
        agg['mt'] = active_institutions.values('institutionagg__mt').annotate(
            num_students=Sum('institutionagg__num'),
            num_boys=SumCase('institutionagg__num', when="gender='male'"),
            num_girls=SumCase('institutionagg__num', when="gender='female'")
        )

        for mt in agg['mt']:
            mt['name'] = mt['institutionagg__mt']
            del mt['institutionagg__mt']

        agg['num_boys'] = active_schools.filter(
            schoolextra__academic_year=academic_year
        ).aggregate(
            num_boys=Sum('schoolextra__num_boys')
        ).get('num_boys', 0)

        agg['num_girls'] = active_schools.filter(
            schoolextra__academic_year=academic_year
        ).aggregate(
            num_girls=Sum('schoolextra__num_girls')
        ).get('num_girls', 0)

        return agg


class BoundarySchoolAggView(KLPAPIView, BaseSchoolAggView):
    def get(self, request, id=None):
        boundary_id = id
        year = request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        source = request.GET.get('source', None)

        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)

        try:
            boundary = Boundary.objects.get(pk=boundary_id)
        except Exception:
            raise APIError('Boundary not found', 404)

        active_schools = boundary.schools()
        agg = self.get_aggregations(active_schools, academic_year)
        agg['boundary'] = BoundaryWithGrandparentSerializer(boundary, context={'request': request}).data

        # Getting the Anganwadi infrastructure data from the
        # StoryDetail view.
        if source:
            view, args, kwargs = resolve(
                '/api/v1/stories/details/',
                urlconf = dubdubdub.urls
            )
            kwargs['request'] = request
            kwargs['boundary'] = boundary
            stories_response = view(*args, **kwargs)
            agg['infrastructure'] = stories_response.data

        # Not using serializer because we need to do the aggregations here
        # and return the results directly
        return Response(agg)


class AssemblySchoolAggView(KLPAPIView, BaseSchoolAggView):
    def get(self, request, id=None):
        assembly_id = id
        year = request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)

        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)

        try:
            assembly = Assembly.objects.get(pk=assembly_id)
        except Exception:
            raise APIError('Assembly not found', 404)

        active_schools = School.objects.filter(
            id__in=assembly.schooldetails_set.all(),
            status=2
        )

        agg = self.get_aggregations(active_schools, academic_year)

        agg['assembly'] = AssemblySerializer(assembly).data

        return Response(agg)


class ParliamentSchoolAggView(KLPAPIView, BaseSchoolAggView):
    def get(self, request, id=None):
        parliament_id = id
        year = request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)

        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)

        try:
            parliament = Parliament.objects.get(pk=parliament_id)
        except Exception:
            raise APIError('Parliament not found', 404)

        active_schools = School.objects.filter(
            id__in=parliament.schooldetails_set.all(),
            status=2
        )

        agg = self.get_aggregations(active_schools, academic_year)

        agg['parliament'] = ParliamentSerializer(parliament).data

        return Response(agg)


class PincodeSchoolAggView(KLPAPIView, BaseSchoolAggView):
    """
    id - can be pin_id or pincode itself
    """
    def get(self, request, id=None):
        pincode_id = id
        year = request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)

        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)

        try:
            pincode = Postal.objects.get(
                Q(pk=pincode_id) | Q(pincode=pincode_id)
            )
        except Exception:
            raise APIError('Pincode not found', 404)

        active_schools = School.objects.filter(
            id__in=pincode.schooldetails_set.all(),
            status=2
        )

        agg = self.get_aggregations(active_schools, academic_year)

        agg['pincode'] = PincodeSerializer(pincode).data

        return Response(agg)
