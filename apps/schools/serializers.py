from common.serializers import KLPGeoSerializer
from rest_framework import serializers
from schools.models import School

class SchoolListSerializer(KLPGeoSerializer):

    class Meta:
        model = School
        fields = ('id', 'name', 'geometry',)

