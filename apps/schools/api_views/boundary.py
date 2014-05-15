from schools.models import Boundary
from common.views import APIView, CSVResponseMixin

class Districts(APIView):

    def get(self, *args, **kwargs):
        districts = Boundary.objects.filter(hierarchy__name='district').select_related('boundarycoord', 'type')
        context = {
            'type': 'FeatureCollection',
            'features': [d.get_geojson() for d in districts]
        }
        return self.render_to_response(context)