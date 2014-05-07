from django.db.models import Manager
from django.contrib.gis.db.models import GeoManager

class BaseManager(Manager):
    pass

class BaseGeoManager(GeoManager):
    pass