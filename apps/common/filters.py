from rest_framework import filters
from django.contrib.gis.geos import Polygon
from rest_framework.exceptions import ParseError


class KLPInBBOXFilter(filters.BaseFilterBackend):
    """
    Filter that only sends objects inside given bbox
    """
    bbox_param = 'bbox'

    def get_filter_bbox(self, request):
        bbox_string = request.QUERY_PARAMS.get(self.bbox_param, None)
        if not bbox_string:
            return None
        try:
            p1x, p1y, p2x, p2y = (float(n) for n in bbox_string.split(','))
        except ValueError:
            raise ParseError("Not valid bbox string in parameter %s."
                            % self.bbox_param)
        x = Polygon.from_bbox((p1x, p1y, p2x, p2y))
        return x

    def filter_queryset(self, request, queryset, view):
        filter_field = getattr(view, 'bbox_filter_field', None)
        if not filter_field:
            return queryset

        bbox = self.get_filter_bbox(request)

        if not bbox:
            return queryset

        return queryset.filter(**{'{}__contained'.format(filter_field): bbox})
