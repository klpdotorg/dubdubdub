from rest_framework import serializers
from rest_framework.exceptions import PermissionDenied
from .models import User, Organization, UserOrganization, VolunteerActivity,\
    VolunteerActivityType, UserVolunteerActivity, DonationRequirement,\
    DonationItem, UserDonationItem, DonationItemCategory
from schools.serializers import SchoolListSerializer
from django.contrib.auth import login, authenticate, logout


class OrganizationSerializer(serializers.ModelSerializer):

    class Meta:
        exclude = ('users',)
        model = Organization


class OrganizationUserSerializer(serializers.ModelSerializer):

    class Meta:
        write_only_fields = ('organization',)
        model = UserOrganization


class VolunteerActivitySerializer(serializers.ModelSerializer):
    organization_details = OrganizationSerializer(
        source='organization',
        read_only=True
    )
    school_details = SchoolListSerializer(
        source='school',
        read_only=True
    )

    class Meta:
        model = VolunteerActivity
        exclude = ('users',)


class UserVolunteerActivityNestedSerializer(serializers.ModelSerializer):
    activity = VolunteerActivitySerializer()

    class Meta:
        model = UserVolunteerActivity
        fields = ('activity', 'status',)


class UserSerializer(serializers.ModelSerializer):

    token = serializers.Field(source='get_token')
    volunteer_activities = UserVolunteerActivityNestedSerializer(
        source='uservolunteeractivity_set',
        read_only=True
    )

    def restore_object(self, attrs, instance=None):
        email = attrs.get('email', None)
        password = attrs.get('password', None)
        extras = {
            'mobile_no': attrs.get('mobile_no', None),
            'first_name': attrs.get('first_name', None),
            'last_name': attrs.get('last_name', None)
        }
        request = self.context['request']

        #create new user
        if not instance:
            user = User.objects.create_user(email, password, **extras)
            email = request.POST.get('email')
            password = request.POST.get('password')
            user = authenticate(username=email, password=password)
            login(request, user)
            return user
        else:
            if request.user.id != instance.id \
                    and not request.user.is_superuser:
                raise PermissionDenied()
            for key in extras.keys():
                if extras[key] is not None:
                    setattr(instance, key, extras[key])
            if password and password != '':
                instance.set_password(password)
            instance.save()
            return instance

    def save_object(self, *args, **kwargs):
        pass

    class Meta:
        model = User
        fields = ('id', 'email', 'mobile_no', 'first_name',
                  'last_name', 'password', 'token', 'volunteer_activities')
        write_only_fields = ('password',)


class OtherUserSerializer(serializers.ModelSerializer):
    '''
        Returns a subset of fields for querying other users' profile
    '''
    volunteer_activities = UserVolunteerActivityNestedSerializer(
        source='uservolunteeractivity_set',
        read_only=True
    )

    class Meta:
        model = User
        fields = ('id', 'first_name', 'last_name', 'volunteer_activities',)




class VolunteerActivityTypeSerializer(serializers.ModelSerializer):

    class Meta:
        model = VolunteerActivityType


class UserVolunteerActivitySerializer(serializers.ModelSerializer):

    class Meta:
        fields = ('user', 'status',)
        model = UserVolunteerActivity


class DonationItemCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = DonationItemCategory


class DonationItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = DonationItem


class DonationRequirementSerializer(serializers.ModelSerializer):
    items = DonationItemSerializer(many=True)
    #users = UserDonationItemSerializer(many=True)

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
