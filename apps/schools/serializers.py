from common.serializers import KLPGeoSerializer
from rest_framework import serializers
from schools.models import School, Boundary

class SchoolListSerializer(KLPGeoSerializer):

    class Meta:
        model = School
        fields = ('id', 'name', 'geometry',)


class SchoolInfoSerializer(KLPGeoSerializer):
    dise_code = serializers.IntegerField(source='dise_info_id')
    type_id = serializers.CharField(source='boundary.type_id')
    address_full = serializers.CharField(source='address.full')
    landmark = serializers.CharField(source='address.landmark')

    class Meta:
        model = School
        fields = ('id', 'name', 'mgmt', 'cat', 'moi', 'sex', 'address_full', 'landmark',
            'dise_code', 'type_id', 'geometry')


class DistrictSerializer(KLPGeoSerializer):
    type = serializers.CharField(source='get_type')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type', 'geometry',)