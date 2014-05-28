from common.serializers import KLPGeoSerializer
from rest_framework import serializers
from schools.models import School, Boundary

class SchoolListSerializer(KLPGeoSerializer):

    class Meta:
        model = School
        fields = ('id', 'name', 'geometry',)


class SchoolInfoSerializer(KLPGeoSerializer):
    dise_code = serializers.IntegerField(source='get_dise_code')

    class Meta:
        model = School
        fields = ('id', 'name', 'dise_code', 'geometry')


class DistrictSerializer(KLPGeoSerializer):
    type = serializers.CharField(source='get_type')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type', 'geometry',)