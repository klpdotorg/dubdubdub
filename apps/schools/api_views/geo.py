from schools.models import SchoolDetails, Boundary
from common.views import KLPListAPIView, KLPDetailAPIView
from schools.serializers import SchoolDetailsSerializer, BoundarySerializer


class DistrictOfSchool(KLPDetailAPIView):
    serializer_class = BoundarySerializer
    bbox_filter_field = 'boundarycoord__coord'

    def get_object(self):
        school_id = self.kwargs.get('pk')
        return SchoolDetails.objects.get(school_id=school_id).district