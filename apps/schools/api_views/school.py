from django.conf import settings
from schools.models import School, DiseInfo, MdmAgg
from schools.filters import SchoolFilter
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.mixins import CacheMixin
from schools.serializers import SchoolListSerializer, SchoolInfoSerializer,\
    SchoolDiseSerializer, SchoolDemographicsSerializer,\
    SchoolProgrammesSerializer, SchoolFinanceSerializer, SchoolInfraSerializer,\
    SchoolLibrarySerializer, SchoolNutritionSerializer, PrechoolInfraSerializer


class SchoolsList(KLPListAPIView, CacheMixin):
    """Returns list of schools with id and name.

    geometry -- yes/[no] - Whether to return geojson or not
    type -- [all]/preschools/primaryschools - school types to return
    admin1 -- ID of the District to search inside
    admin2 -- ID of the Block/Project to search inside
    admin3 -- ID of the Cluster/Circle to search inside
    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    serializer_class = SchoolListSerializer
    bbox_filter_field = "instcoord__coord"
    filter_class = SchoolFilter
    search_fields = ('name', 'id', 'dise_info__dise_code',)

    def get_queryset(self):
        qset = School.objects.filter(status=2)
        get_geom = self.request.GET.get('geometry', 'no')
        if get_geom == 'yes':
            qset = qset.select_related('instcoord')

        stype = self.request.GET.get('type', 'all')

        if stype == 'preschools':
            qset = qset.filter(schooldetails__type=2)
        elif stype == 'primaryschools':
            qset = qset.filter(schooldetails__type=1)
        qset = qset.select_related('schooldetails__type', 'address')

        if self.request.GET.get('admin1', ''):
            admin1 = self.request.GET.get('admin1')
            qset = qset.filter(schooldetails__admin1_id=admin1)

        if self.request.GET.get('admin2', ''):
            admin2 = self.request.GET.get('admin2')
            qset = qset.filter(schooldetails__admin2_id=admin2)

        if self.request.GET.get('admin3', ''):
            admin3 = self.request.GET.get('admin3')
            qset = qset.filter(schooldetails__admin3_id=admin3)

        return qset


class SchoolsInfo(SchoolsList, CacheMixin):
    """Returns list of schools with more info about each school for /schools/info,
    this is an detailed version of /schools/list

    geometry -- yes/[no] - Whether to return geojson or not
    stype -- [all]/preschools/primaryschools - school types to return
    admin1 -- ID of the District to search inside
    admin2 -- ID of the Block/Project to search inside
    admin3 -- ID of the Cluster/Circle to search inside
    """
    serializer_class = SchoolInfoSerializer
    filter_class = SchoolFilter
    search_fields = ('name', 'id', 'dise_info__dise_code',)

    def get_queryset(self):
        # inherit all the filtering from SchoolsList
        qset = super(SchoolsInfo, self).get_queryset()

        qset = qset.select_related(
            'address', 'schooldetails__admin3',
            'schooldetails__admin2', 'schooldetails__admin1',
            'schooldetails__type', 'schooldetails__assembly',
            'schooldetails__parliament', 'electedrep__ward',
            'schooldetails__admin1__hierarchy',
            'schooldetails__admin2__hierarchy',
            'schooldetails__admin3__hierarchy',
        ).prefetch_related(
            'dise_info__disefacilityagg_set',
            'story_set'
        )
        return qset


class SchoolsDiseInfo(KLPListAPIView):
    """Returns list of schools with DISE data

    bbox -- Bounding box to search within e.g. 77.349415,12.822471,77.904224,14.130930
    """
    # test url:
    # http://localhost:8001/api/v1/schools/dise/2011-12?in_bbox=
    serializer_class = SchoolDiseSerializer
    bbox_filter_field = "school__instcoord__coord"

    def get_queryset(self):
        year = self.kwargs.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        schools = DiseInfo.objects.filter(acyear=year, school__status=2)\
            .select_related('instcoord', 'school')
        return schools


class SchoolInfo(KLPDetailAPIView, CacheMixin):
    """Returns info for a single school.
    """
    serializer_class = SchoolInfoSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('instcoord', 'address', 'schooldetails__admin3',
                            'schooldetails__admin2', 'schooldetails__admin1',
                            'schooldetails__type', 'schooldetails__assembly',
                            'schooldetails__parliament', 'electedrep__ward',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy')


class SchoolDemographics(KLPDetailAPIView):
    """Returns demographic info for a single school.
    """
    serializer_class = SchoolDemographicsSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info',)


class SchoolInfra(KLPDetailAPIView, CacheMixin):
    """Returns infrastructure info for a single school.
    """
    def get_serializer_class(self):
        sid = self.kwargs.get('pk') if hasattr(self, 'kwargs') else None

        if sid:
            school = School.objects.get(pk=sid)

            if school.schooldetails.type_id == 2:
                return PrechoolInfraSerializer
            else:
                return SchoolInfraSerializer
        else:
            return None

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info', 'schooldetails', 'schooldetails__admin3',
                            'schooldetails__type',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy',
                            'schooldetails__admin2', 'schooldetails__admin1')


class SchoolLibrary(KLPDetailAPIView, CacheMixin):
    """Returns library info for a single school.
    """
    serializer_class = SchoolLibrarySerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info', 'schooldetails', 'schooldetails__admin3',
                            'schooldetails__type',
                            'schooldetails__admin1__hierarchy',
                            'schooldetails__admin2__hierarchy',
                            'schooldetails__admin3__hierarchy',
                            'schooldetails__admin2', 'schooldetails__admin1',
                            'libinfra', 'studentgroup__students__studentstudentgroup__academic_year')


class SchoolNutrition(KLPDetailAPIView):
    """Returns nutrition info for a single school.
    """
    serializer_class = SchoolNutritionSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('mdmagg_set', 'dise_info',)


class SchoolProgrammes(KLPDetailAPIView):
    """Returns programmes info for a single school.
    """
    serializer_class = SchoolProgrammesSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info',)


class SchoolFinance(KLPDetailAPIView):
    """Returns finance info for a single school.
    """
    # DISE data is yearly. Needs year as param or send list maybe
    serializer_class = SchoolFinanceSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('dise_info',)
