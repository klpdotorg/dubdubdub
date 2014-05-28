from schools.models import Boundary
from common.views import KLPListAPIView
from schools.serializers import DistrictSerializer

class Districts(KLPListAPIView):
    serializer_class = DistrictSerializer
    bbox_filter_field = 'boundarycoord__coord'
    
    def get_queryset(self):
        return Boundary.objects.filter(hierarchy__name='district').select_related('boundarycoord', 'type')
