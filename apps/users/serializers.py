from rest_framework import serializers
from rest_framework.exceptions import PermissionDenied
from .models import User, Organization, UserOrganization, VolunteerActivity,\
    VolunteerActivityType, UserVolunteerActivity, DonationRequirement,\
    DonationItem, UserDonationItem, DonationItemCategory
from schools.serializers import SchoolListSerializer
from django.contrib.auth import login, authenticate, logout
from common.serializers import KLPSerializer
from drf_extra_fields.fields import Base64ImageField


class OrganizationBasicSerializer(serializers.ModelSerializer):

    class Meta:
        fields = ('id', 'name',)
        model = Organization


class UserBasicSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ('id', 'first_name', 'last_name',)


class VolunteerActivityTypeSerializer(serializers.ModelSerializer):

    class Meta:
        model = VolunteerActivityType


class OrganizationUserSerializer(serializers.ModelSerializer):
    organization_details = OrganizationBasicSerializer(
        source='organization',
        read_only=True
    )
    user_details = UserBasicSerializer(
        source='user',
        read_only=True
    )
    class Meta:
        write_only_fields = ('organization', 'user',)
        model = UserOrganization


class VolunteerActivityBasicSerializer(serializers.ModelSerializer):
    organization_details = OrganizationBasicSerializer(
        source='organization',
        read_only=True
    )
    school_details = SchoolListSerializer(
        source='school',
        read_only=True
    )
    activity_type_details = VolunteerActivityTypeSerializer(
        read_only=True,
        source='type'
    )

    class Meta:
        model = VolunteerActivity


class UserVolunteerActivitySerializer(serializers.ModelSerializer):
    user_details = UserBasicSerializer(
        source='user',
        read_only=True
    )
    activity_details = VolunteerActivityBasicSerializer(
        source='activity',
        read_only=True
    )
    class Meta:
        fields = ('status', 'user_details', 'activity_details',)
        model = UserVolunteerActivity


class VolunteerActivitySerializer(KLPSerializer):
    organization_details = OrganizationBasicSerializer(
        source='organization',
        read_only=True
    )
    school_details = SchoolListSerializer(
        source='school',
        read_only=True
    )
    users = UserVolunteerActivitySerializer(
        many=True,
        read_only=True,
        source='uservolunteeractivity_set'
    )
    activity_type_details = VolunteerActivityTypeSerializer(
        read_only=True,
        source='type'
    )

    class Meta:
        model = VolunteerActivity
        #exclude = ('users',)


class UserVolunteerActivityNestedSerializer(serializers.ModelSerializer):
    activity = VolunteerActivitySerializer()

    class Meta:
        model = UserVolunteerActivity
        fields = ('activity', 'status',)


class OrganizationSerializer(serializers.ModelSerializer):
    logo = Base64ImageField(required=False)
    volunteer_activities = VolunteerActivitySerializer(
        source='volunteeractivity_set',
        read_only=True,
        many=True
    )

    users = OrganizationUserSerializer(
        source='userorganization_set',
        read_only=True,
        many=True
    )

    class Meta:
        #exclude = ('users',)
        model = Organization


class UserSerializer(serializers.ModelSerializer):
    image = Base64ImageField(required=False)
    token = serializers.Field(source='get_token')
    volunteer_activities = UserVolunteerActivityNestedSerializer(
        source='uservolunteeractivity_set',
        read_only=True
    )

    organizations = OrganizationUserSerializer(
        source='userorganization_set',
        read_only=True,
        many=True
    )

    def restore_object(self, attrs, instance=None):
        user = super(UserSerializer, self).restore_object(attrs, instance)
        if attrs.has_key('password'):
            user.set_password(attrs['password'])
        return user

    def validate_mobile_no(self, attrs, source):
        value = attrs[source]

        if not len(str(value)) == 10:
            raise serializers.ValidationError("Phone number must be a 10 digit number")
        else:
            try:
                int(value)
            except Exception, e:
                raise serializers.ValidationError("Phone number must only have numbers")
        return attrs

    class Meta:
        model = User
        fields = ('id', 'email', 'mobile_no', 'first_name',
                  'last_name', 'password', 'opted_email', 'token', 'volunteer_activities',
                  'image', 'organizations', 'about', 'twitter_handle', 'fb_url', 
                  'website', 'photos_url', 'youtube_url',)
        write_only_fields = ('password',)


class OtherUserSerializer(serializers.ModelSerializer):
    '''
        Returns a subset of fields for querying other users' profile
    '''
    volunteer_activities = UserVolunteerActivityNestedSerializer(
        source='uservolunteeractivity_set',
        read_only=True
    )

    organizations = OrganizationUserSerializer(
        source='userorganization_set',
        read_only=True,
        many=True
    )

    class Meta:
        model = User
        fields = ('id', 'first_name', 'last_name', 'volunteer_activities', 'organizations',
                  'about', 'twitter_handle', 'fb_url', 
                  'website', 'photos_url', 'youtube_url',)




class DonationItemCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = DonationItemCategory


class DonationItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = DonationItem


class DonationRequirementSerializer(serializers.ModelSerializer):
    items_count = serializers.IntegerField(source='items.count')
    items_url = serializers.CharField(source='get_items_url')
    organization_details = OrganizationBasicSerializer(
        source='organization',
        read_only=True
    )
    school_details = SchoolListSerializer(
        source='school',
        read_only=True
    )

    class Meta:
        model = DonationRequirement


class UserDonationItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserDonationItem


# class DonorRequirementSerializer(serializers.ModelSerializer):

#     class Meta:
#         model = DonorRequirement
#         exclude = ('users',)


# class DonationTypeSerializer(serializers.ModelSerializer):

#     class Meta:
#         model = DonationType


# class UserDonorRequirementSerializer(serializers.ModelSerializer):

#     class Meta:
#         write_only_fields = ('donor_requirement',)
#         model = UserDonorRequirement
