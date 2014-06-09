from rest_framework import serializers
from rest_framework.renderers import JSONRenderer
from drf_compound_fields.fields import DictField


class KLPSerializer(serializers.ModelSerializer):
    #geometry = DictField(source='get_geometry')

    def __init__(self, *args, **kwargs):
        super(KLPSerializer, self).__init__(*args, **kwargs)
        #import pdb;pdb.set_trace()

        if 'context' in kwargs:
            request = kwargs['context']['request']
            geometry = request.GET.get('geometry', 'no')
            #add geometry to fields if geometry=yes in query params
            if geometry == 'yes':
                self.fields['geometry'] = DictField(source='get_geometry')

