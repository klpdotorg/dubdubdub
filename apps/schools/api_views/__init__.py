from .school import (
    SchoolsList, SchoolsInfo, SchoolInfo, SchoolsDiseInfo,
    SchoolDemographics, SchoolProgrammes, SchoolFinance, SchoolInfra,
    SchoolLibrary, SchoolNutrition
)
from .assessment import (
    AssessmentsList, AssessmentInfo, ProgrammesList, ProgrammeInfo,
    ProgrammePercentile, PartnerList
)
from .aggregations import *
from .boundary import (
    Admin1s, Admin2sInsideAdmin1, Admin3sInsideAdmin1,
    Admin2s, Admin3sInsideAdmin2, Admin3s, AdminDetails, AssemblyDetails,
    ParliamentDetails, PincodeDetails, AssemblyList, ParliamentList,
    AssemblyInParliament
)
from .geo import (
    Admin1OfSchool, Admin2OfSchool, Admin3OfSchool,
    PincodeOfSchool, AssemblyOfSchool, ParliamentOfSchool
)

from common.views import KLPAPIView
import dubdubdub.api_urls
from schools.serializers import (
    SchoolListSerializer, BoundarySerializer,
    AssemblySerializer, ParliamentSerializer, PincodeSerializer
)
from schools.models import School, Boundary, Assembly, Parliament, Postal

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.db.models import Q
import urlparse


class OmniSearch(KLPAPIView):
    """Omni-search endpoint for plain text search of all the entities

    Keyword arguments:
    text -- A string to search all kinds of entities for
    """
    is_omni = True

    def get(self, request, format=None):
        response = {
            'pre_schools': [],
            'primary_schools': [],
            'boundaries': [],
            'assemblies': [],
            'parliaments': [],
            'pincodes': [],
        }

        context = {
            'request': request,
            'view': self
        }

        params = request.QUERY_PARAMS
        text = params.get('text', '')

        if not text:
            return Response({
                'error': 'A text must be provided to search'
            }, status=404)

        response['pre_schools'] = SchoolListSerializer(
            School.objects.filter(
                (Q(name__icontains=text) | Q(id__contains=text)
                    | Q(dise_info__dise_code__contains=text)),
                Q(status=2),
                Q(instcoord__coord__isnull=False),
                Q(schooldetails__type__name='PreSchool')
            ).select_related(
                'instcoord',
                'schooldetails__type',
                'address'
            ).prefetch_related(
                'schooldetails'
            )[:3],
            many=True,
            context=context
        ).data

        response['primary_schools'] = SchoolListSerializer(
            School.objects.filter(
                (Q(name__icontains=text) | Q(id__contains=text)
                    | Q(dise_info__dise_code__contains=text)),
                Q(status=2),
                Q(instcoord__coord__isnull=False),
                Q(schooldetails__type__name='Primary School')
            ).select_related(
                'instcoord',
                'schooldetails__type',
                'address'
            ).prefetch_related(
                'schooldetails'
            )[:3],
            many=True,
            context=context
        ).data

        response['boundaries'] = BoundarySerializer(
            Boundary.objects.filter(
                status=2,
                name__icontains=text,
                boundarycoord__coord__isnull=False
            ).select_related(
                'boundarycoord',
                'hierarchy__name',
                'parent__hierarchy__name'
            ).prefetch_related('parent', 'hierarchy')[:10],
            many=True,
            context=context
        ).data

        response['assemblies'] = AssemblySerializer(
            Assembly.objects.filter(
                name__icontains=text,
                coord__isnull=False
            )[:10],
            many=True,
            context=context
        ).data

        response['parliaments'] = ParliamentSerializer(
            Parliament.objects.filter(
                name__icontains=text,
                coord__isnull=False
            )[:10],
            many=True,
            context=context
        ).data

        response['pincodes'] = PincodeSerializer(
            Postal.objects.filter(
                pincode__icontains=text,
                coord__isnull=False
            )[:10],
            many=True,
            context=context
        ).data

        return Response(response)


class MergeEndpoints(KLPAPIView):
    """Merges multiple endpoint outputs
    E.g. - /merge?endpoints=/schools/school/33312/infrastructure&endpoints=/schools/school/33312/library
    merges output of both infrastructure and library endpoints and returns a single JSON.

    Keyword arguments:
    endpoints -- first endpoint
    endpoints -- second endpoint
    """
    def get(self, request, format=None):
        endpoints = request.GET.getlist('endpoints', [])
        data = {}

        if not endpoints:
            return Response({
                'error': 'no endpoints specified'
            }, status=404)

        for endpoint in endpoints:
            parsed = urlparse.urlparse(endpoint)
            try:
                view, args, kwargs = resolve(parsed.path, urlconf=dubdubdub.api_urls)
                kwargs['request'] = request

                data[endpoint] = view(*args, **kwargs).data
            except Exception as e:
                print e
                continue

        return Response(data, status=200)


@api_view(('GET',))
def api_root(request, format=None):
    """Root of all evil
    """
    return Response({
        'Omni Search': reverse('api_omni_search', request=request,
                               format=format) + "?text=pura",
        'Schools': {
            'Schools List': reverse('api_schools_list', request=request,
                                    format=format),

            'Schools Info': reverse('api_schools_info', request=request,
                                    format=format),

            'Schools DISE Info': reverse('api_schools_dise', request=request,
                                         format=format,
                                         kwargs={'year': '2013-14'}),

            'School Info': reverse('api_school_info', request=request,
                                   format=format, kwargs={'pk': 3573}),

            'School Demographics': reverse('api_school_demo', request=request,
                                           format=format, kwargs={'pk': 1886}),

            'School Programmes': reverse('api_school_prog', request=request,
                                         format=format, kwargs={'pk': 3573}),

            'School Finance': reverse('api_school_finance', request=request,
                                      format=format, kwargs={'pk': 3573}),

            'School Infrastructure': reverse('api_school_infra', request=request,
                                             format=format, kwargs={'pk': 3573}),

            'School Library': reverse('api_school_library', request=request,
                                      format=format, kwargs={'pk': 3573}),

            'School Nutrition': reverse('api_school_nutrition', request=request,
                                      format=format, kwargs={'pk': 33313})
        },

        'Boundary': {
            'Admin Details': reverse('api_admin_details', request=request,
                                         format=format, kwargs={'id': 8897}),
            'Assembly Details': reverse('api_assembly_details', request=request,
                                         format=format, kwargs={'id': 24}) + "?geometry=yes",
            'Parliament Details': reverse('api_parliament_details', request=request,
                                         format=format, kwargs={'id': 3}) + "?geometry=yes",
            'Pincode Details': reverse('api_pincode_details', request=request,
                                         format=format, kwargs={'pincode': 560008}) + "?geometry=yes",

            'Admin1s': reverse('api_admin1s', request=request, format=format),

            'Admin2s in Admin1': reverse('api_admin1s_admin2', request=request,
                                         format=format, kwargs={'id': 445}),

            'Admin3s in Admin1': reverse('api_admin1s_admin3', request=request,
                                         format=format, kwargs={'id': 445}),

            'Admin2s': reverse('api_admin2s', request=request, format=format),

            'Admin3s in Admin2': reverse('api_admin2s_admin3', request=request,
                                         format=format, kwargs={'id': 8889}),

            'Admin3s': reverse('api_admin3s', request=request, format=format)
        },

        'Aggregation': {
            'Boundary Library Language': reverse(
                'api_aggregation_boundary_liblang',
                request=request, format=format, kwargs={'id': 8967}
            ),
            'Boundary Library Level': reverse(
                'api_aggregation_boundary_liblevel',
                request=request, format=format, kwargs={'id': 8967}
            ),
            'School Aggregations for Boundary': reverse(
                'api_aggregation_boundary_schools',
                request=request, format=format, kwargs={'id': 8967}
            ),
            'School Aggregations for Assembly': reverse(
                'api_aggregation_assembly_schools',
                request=request, format=format, kwargs={'id': 129}
            ),
            'School Aggregations for Parliament': reverse(
                'api_aggregation_parliament_schools',
                request=request, format=format, kwargs={'id': 12}
            ),
            'School Aggregations for Pincode': reverse(
                'api_aggregation_pincode_schools',
                request=request, format=format, kwargs={'id': 560008}
            ),
        },

        'Geo': {
            'Admin1 of School': reverse('api_school_admin1', request=request,
                                        format=format, kwargs={'pk': 3573}),

            'Admin2 of School': reverse('api_school_admin2', request=request,
                                        format=format, kwargs={'pk': 3573}),

            'Admin3 of School': reverse('api_school_admin3', request=request,
                                        format=format, kwargs={'pk': 3573}),

            'Assemby of School': reverse('api_school_assembly',
                                         request=request,
                                         format=format, kwargs={'pk': 3573}),

            'Parliament of School': reverse('api_school_parliament',
                                            request=request, format=format,
                                            kwargs={'pk': 3573}),

            'Pincode of School': reverse('api_school_pincode', request=request,
                                         format=format, kwargs={'pk': 3573})
        }
    })
