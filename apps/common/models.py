from django.contrib.gis.db import models
from django.forms.models import model_to_dict


class BaseModel(models.Model):
    # things that *all* models will have in common

    def get_dict(self, fields=None, exclude=None):
        """returns JSON serializable dict of the properties

        Keyword arguments:
        fields -- optional list of fields to return, returns everything by default
        exclude -- optional list of fields to exclude from the returned dict
        """
        return model_to_dict(self, fields, exclude)

    class Meta:
        # This isn't a real model
        abstract = True


class GeoBaseModel(BaseModel):
    # things that only geo enabled models will have in common

    # def get_dict(self, fields=None, exclude=None):
    #     """returns JSON serializable dict of the properties
    #     This needs to be overridden to parse Geo fields

    #     Keyword arguments:
    #     fields -- optional list of fields to return, returns everything by default
    #     exclude -- optional list of fields to exclude from the returned dict
    #     """
    #     return model_to_dict(self, fields, exclude)

    # overriding the default manager
    objects = models.GeoManager()

    class Meta:
        # This isn't a real model
        abstract = True
