from rest_framework import serializers
from rest_framework.renderers import JSONRenderer
from drf_compound_fields.fields import DictField


class KLPSerializer(serializers.ModelSerializer):
    # geometry = DictField(source='get_geometry')
    def __init__(self, *args, **kwargs):
        super(KLPSerializer, self).__init__(*args, **kwargs)
        if 'context' in kwargs:
            request = kwargs['context']['request']
            geometry = request.GET.get('geometry', 'no')
            # add geometry to fields if geometry=yes in query params
            if geometry == 'yes':
                self.fields['geometry'] = DictField(source='get_geometry')


class KLPSimpleGeoSerializer(serializers.ModelSerializer):

    def __init__(self, *args, **kwargs):
        super(KLPSimpleGeoSerializer, self).__init__(*args, **kwargs)

        if 'context' in kwargs:
            request = kwargs['context']['request']
            geometry = request.GET.get('geometry', 'no')
            simplify = request.GET.get('simplify', 'yes')

            if geometry == 'yes' and simplify == 'no':
                self.fields['geometry'] = DictField(source='get_geometry')

            if geometry == 'yes' and simplify == 'yes':
                self.fields['geometry'] = DictField(source='get_simple_geometry')
