from common.serializers import KLPGeoSerializer
from rest_framework import serializers
from schools.models import School

class SchoolsListSerializer(KLPGeoSerializer):
    id = serializers.IntegerField()
    name = serializers.CharField()

    class Meta:
        model = School
        fields = ('id', 'name', 'geometry',)