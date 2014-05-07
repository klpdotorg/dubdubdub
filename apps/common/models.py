import json
from django.contrib.gis.db import models
from django.contrib.gis.geos import Point
from django.forms.models import model_to_dict
from .managers import BaseManager, BaseGeoManager

class BaseModel(models.Model):
    # things that *all* models will have in common
    def get_dict(self, fields=None, exclude=None):
        """returns JSON serializable dict of the properties

        Keyword arguments:
        fields -- optional list of fields to return, returns everything by default
        exclude -- optional list of fields to exclude from the returned dict
        """
        return model_to_dict(self, fields, exclude)

    objects = BaseManager()

    class Meta:
        # This isn't a real model
        abstract = True


class GeoBaseModel(BaseModel):
    # things that only geo enabled models will have in common
    def get_dict(self, fields=None, exclude=None):
        """returns JSON serializable dict of the properties
        This needs to be overridden to parse Geo fields

        Keyword arguments:
        fields -- optional list of fields to return, returns everything by default
        exclude -- optional list of fields to exclude from the returned dict
        """
        geo_dict = model_to_dict(self, fields, exclude)
        # model_to_dict returns output like -
        # {'coord': <Point object at 0x40ff5b0>, 'school': 32988}

        for key, value in geo_dict.iteritems():
            if isinstance(value, Point):
                # geo_dict[key] = json.loads(value.geojson)
                geo_dict[key] = [
                    geo_dict[key].x,
                    geo_dict[key].y
                ]

        return geo_dict

    # not sure how useful the below methods would be
    def get_geojson_dict(self, fields=None, exclude=None):
        geojson_dict = {
            "type": "Feature",
            "geometry": {
            },
            "properties": {
            }
        }

        self_dict = model_to_dict(self, fields, exclude)
        # model_to_dict returns output like -
        # {'coord': <Point object at 0x40ff5b0>, 'school': 32988}

        for key, value in self_dict.iteritems():
            if isinstance(value, Point):
                # self_dict[key] = json.loads(value.geojson)
                geojson_dict['geometry'] = {
                    u'type': u'Point',
                    u'coordinates': [
                        self_dict[key].x,
                        self_dict[key].y
                    ]
                }
            else:
                geojson_dict['properties'][key] = value

        return geojson_dict

    def get_geojson(self, fields=None, exclude=None):
        return json.dumps(self.get_geojson_dict(fields, exclude))

    # overriding the default manager
    objects = BaseGeoManager()

    class Meta:
        # This isn't a real model
        abstract = True


def queryset_to_geojson(geofield_or_relation=None):
    """turns a queryset to geojson

    Keyword arguments:
    geofield_or_relation -- provide a relation like this related_fieldname.column_name
                            and this method will take that field from the related model
                            and put that value as geometry of the geojson
    """
    pass