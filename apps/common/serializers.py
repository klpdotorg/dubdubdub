from rest_framework import serializers
from rest_framework.renderers import JSONRenderer
from drf_compound_fields.fields import DictField


class KLPNonGeoSerializer(serializers.ModelSerializer):
    def __init__(self, *args, **kwargs):
        super(KLPNonGeoSerializer, self).__init__(*args, **kwargs)
        request = kwargs['context']['request']
        year = request.GET.get('year', 2010)

class KLPGeoSerializer(serializers.ModelSerializer):

    #this will get geometry as a dict from a get_geometry method on the model being serialized
    geometry = DictField(source='get_geometry')

    def __init__(self, *args, **kwargs):
        super(KLPGeoSerializer, self).__init__(*args, **kwargs)
        request = kwargs['context']['request']
        geometry = request.GET.get('geometry', 'no')
        #remove geometry field if geometry=yes param not set
        if geometry != 'yes':
            self.fields.pop('geometry')

