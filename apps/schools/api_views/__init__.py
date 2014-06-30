from .school import SchoolsList, SchoolsInfo, SchoolInfo, SchoolsDiseInfo,\
    SchoolDemographics, SchoolProgrammes, SchoolFinance, SchoolInfra,\
    SchoolLibrary
from .boundary import Admin1s, Admin2sInsideAdmin1, Admin3sInsideAdmin1, \
    Admin2s, Admin3sInsideAdmin2, Admin3s
from .geo import Admin1OfSchool, Admin2OfSchool, Admin3OfSchool,\
    PincodeOfSchool, AssemblyOfSchool, ParliamentOfSchool

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse


@api_view(('GET',))
def api_root(request, format=None):
    return Response({
        'Schools': {
            'Schools List': reverse('api_schools_list', request=request,
                                    format=format),

            'Schools Info': reverse('api_schools_info', request=request,
                                    format=format),

            'Schools DISE Info': reverse('api_schools_dise', request=request,
                                         format=format,
                                         kwargs={'year': '2011-12'}),

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
                                      format=format, kwargs={'pk': 3573})
        },

        'Boundary': {
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
