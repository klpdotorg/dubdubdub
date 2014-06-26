from schools.models import SchoolDetails, Boundary, School
from common.views import KLPListAPIView, KLPDetailAPIView
from schools.serializers import SchoolDetailsSerializer, BoundarySerializer,\
    SchoolPincodeSerializer, AssemblySerializer, ParliamentSerializer,\
    BoundaryWithParentSerializer, PincodeSerializer


class Admin1OfSchool(KLPDetailAPIView):
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).admin1


class Admin2OfSchool(KLPDetailAPIView):
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).admin2


class Admin3OfSchool(KLPDetailAPIView):
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).admin3


class PincodeOfSchool(KLPDetailAPIView):
    serializer_class = PincodeSerializer

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).postal


class AssemblyOfSchool(KLPDetailAPIView):
    serializer_class = AssemblySerializer

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).assembly


class ParliamentOfSchool(KLPDetailAPIView):
    serializer_class = ParliamentSerializer

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).parliament
