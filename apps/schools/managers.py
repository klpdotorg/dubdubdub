from common.managers import BaseManager, BaseGeoManager
from django.contrib.gis.geos import Polygon

class SchoolsManager(BaseGeoManager):

    def within_bbox(self, bbox_string):
        bbox = Polygon.from_bbox([float(b) for b in bbox_string.split(",")])
        return self.filter(instcoord__coord__within=bbox)
