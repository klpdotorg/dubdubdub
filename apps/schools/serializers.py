from common.serializers import KLPGeoSerializer, KLPNonGeoSerializer
from rest_framework import serializers
from schools.models import School, Boundary

class SchoolListSerializer(KLPGeoSerializer):

    class Meta:
        model = School
        fields = ('id', 'name', 'geometry',)


class SchoolInfoSerializer(KLPGeoSerializer):
    dise_code = serializers.CharField(source='dise_info_id')
    cluster = serializers.CharField(source='schooldetails.cluster_or_circle.name')
    block = serializers.CharField(source='schooldetails.block_or_project.name')
    district = serializers.CharField(source='schooldetails.district.name')

    type_id = serializers.CharField(source='schooldetails.type_id')
    address_full = serializers.CharField(source='address.full')
    landmark = serializers.CharField(source='address.landmark')
    identifiers = serializers.CharField(source='address.get_identifiers')

    class Meta:
        model = School
        fields = ('id', 'name', 'mgmt', 'cat', 'moi', 'sex', 'address_full', 'landmark',
            'identifiers', 'cluster', 'block', 'district', 'dise_code', 'type_id', 'geometry')


class SchoolDiseSerializer(KLPNonGeoSerializer):
    class Meta:
        model = School
        fields = ('id', 'name', 'dise_info')


class BoundarySerializer(KLPGeoSerializer):
    type = serializers.CharField(source='get_type')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type', 'geometry',)