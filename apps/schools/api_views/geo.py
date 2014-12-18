from schools.models import SchoolDetails, Boundary, School
from common.views import KLPListAPIView, KLPDetailAPIView
from schools.serializers import SchoolDetailsSerializer, BoundarySerializer,\
    AssemblySerializer, ParliamentSerializer,\
    BoundaryWithParentSerializer, PincodeSerializer


class Admin1OfSchool(KLPDetailAPIView):
    """Returns the district for the given school
    """
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).admin1


class Admin2OfSchool(KLPDetailAPIView):
    """Returns the block/project for the given school
    """
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).admin2


class Admin3OfSchool(KLPDetailAPIView):
    """Returns the cluster/circle for the given school
    """
    serializer_class = BoundaryWithParentSerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).admin3


class PincodeOfSchool(KLPDetailAPIView):
    """Returns the pincode for the given school
    """
    serializer_class = PincodeSerializer

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).postal


class AssemblyOfSchool(KLPDetailAPIView):
    """Returns the assembly level for the given school
    """
    serializer_class = AssemblySerializer

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).assembly


class ParliamentOfSchool(KLPDetailAPIView):
    """Returns the parliamentary level for the given school
    """
    serializer_class = ParliamentSerializer

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).parliament
