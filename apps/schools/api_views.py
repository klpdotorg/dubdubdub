from django.views.generic import View
from django.contrib.gis.geos import Polygon
#from coords.models import InstCoord
from .models import School, InstCoord, Boundary, BoundaryHierarchy
from common.views import APIView, CSVResponseMixin
from django.core.paginator import Paginator
from django.shortcuts import get_object_or_404

ITEMS_PER_PAGE = 50 #move this to settings if it is a constant?

class SchoolsList(APIView, CSVResponseMixin):

    def get(self, *args, **kwargs):
        bbox_string = self.request.GET.get("bounds")
        page = int(self.request.GET.get("page", 1))
        fmt = self.request.GET.get("fmt", "json")
        #TODO: refactor to accept CSV as param
        if bbox_string:
            schools = School.objects.within_bbox(bbox_string)
        else:
            schools = School.objects.all()
        schools = schools.select_related('instcoord', 'address')
        p = Paginator(schools, ITEMS_PER_PAGE)
        page = p.page(page)

        context = {
            'type': 'FeatureCollection',
            'count': p.count,
            'features': [s.get_list_geojson() for s in page.object_list]
        }
        if fmt == 'csv':
            return self.render_geojson_to_csv(context)
        else:
            return self.render_to_response(context)


class SchoolsInfo(APIView):

    def get(self, *args, **kwargs):
        bbox_string = self.request.GET.get("bounds")
        page = int(self.request.GET.get("page", 1))
        #TODO: refactor to accept CSV as param

        schools = School.objects.all()
        if bbox_string:
            schools = School.objects.within_bbox(bbox_string)
        else:
            schools = School.objects.all()

        schools = schools.select_related('instcoord', 'address')

        p = Paginator(schools, ITEMS_PER_PAGE)
        page = p.page(page)

        context = {
            'type': 'FeatureCollection',
            'count': p.count,
            'features': [s.get_info_geojson() for s in page.object_list]
        }

        return self.render_to_response(context)


class SchoolInfo(APIView):

    def get(self, *args, **kwargs):
        id = kwargs['id']
        school = get_object_or_404(School, pk=id)
        return self.render_to_response(school.get_info_geojson())


class Districts(APIView):

    def get(self, *args, **kwargs):
        districts = Boundary.objects.filter(hierarchy__name='district').select_related('boundarycoord', 'type')
        context = {
            'type': 'FeatureCollection',
            'features': [d.get_geojson() for d in districts]
        }
        return self.render_to_response(context)