from django.contrib.auth import login as auth_login, authenticate, logout as auth_logout
import datetime
from django.contrib.auth.forms import PasswordResetForm
from django.shortcuts import get_object_or_404
from .models import User, Organization, UserOrganization, VolunteerActivity,\
    VolunteerActivityType, UserVolunteerActivity, DonationRequirement,\
    DonationItemCategory, UserDonationItem
from .serializers import UserSerializer, OtherUserSerializer,\
    OrganizationSerializer,\
    OrganizationUserSerializer, VolunteerActivitySerializer,\
    VolunteerActivityTypeSerializer, UserVolunteerActivitySerializer,\
    DonationRequirementSerializer, DonationItemCategorySerializer,\
    UserDonationItemSerializer
from .permissions import UserListPermission, IsAdminOrIsSelf,\
    IsAdminToWrite, OrganizationsPermission, OrganizationPermission,\
    OrganizationUsersPermission, VolunteerActivitiesPermission,\
    UserVolunteerActivityPermission, DonationRequirementsPermission,\
    UserDonorRequirementPermission
from .filters import VolunteerActivityFilter, DonationRequirementFilter
from common.utils import render_to_json_response
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.exceptions import APIException, PermissionDenied,\
    ParseError, MethodNotAllowed, AuthenticationFailed
from rest_framework import authentication, permissions
from rest_framework.decorators import api_view


class TestAuthenticatedView(APIView):
    authentication_classes = (authentication.TokenAuthentication,
                              authentication.SessionAuthentication,)
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, format=None):
        return Response({
            'logged_in_as': request.user.email
        })


class UsersView(generics.ListCreateAPIView):
    serializer_class = UserSerializer
    paginate_by = 50
    permission_classes = (UserListPermission,)

    def create(self, *args, **kwargs):
        #FIXME: move validation into serializer validate methods
        email = self.request.POST.get('email', None)
        mobile_no = self.request.POST.get('mobile_no', None)
        first_name = self.request.POST.get('first_name', None)
        last_name = self.request.POST.get('last_name', None)
        if not email or not mobile_no or not first_name or not last_name:
            raise ParseError("""Insufficient data: required fields are email,
                             mobile_no, first_name and last_name""")
        if User.objects.filter(email=email).count() > 0:
            raise APIException("duplicate email")
        password = self.request.POST.get('password', '')
        if password == '':
            raise ParseError("No password supplied")
        return super(UsersView, self).create(*args, **kwargs)

    def get_queryset(self):
        return User.objects.all()


class UserProfileView(generics.RetrieveUpdateAPIView):
    '''
        View to get and update currently logged in user's profile.
    '''
    serializer_class = UserSerializer
    permission_classes = (IsAdminOrIsSelf, permissions.IsAuthenticated)

    def get_object(self):
        return User.objects.get(id=self.request.user.id)

    def post(self, request):
        '''
            PATCH requests are made to edit user profile, disallow POST.
        '''
        raise MethodNotAllowed("POST")


class OtherUserProfileView(generics.RetrieveAPIView):
    '''
        Get basic profile data for other users
        (To be able to view their profile page, for eg.)
    '''
    serializer_class = OtherUserSerializer
    model = User


@api_view(['GET'])
def logout(request):
    auth_logout(request)
    return Response({'success': 'User logged out'})


@api_view(['POST'])
@csrf_exempt
def login(request):
    email = request.POST.get("email", "")
    password = request.POST.get("password", "")
    user = authenticate(username=email, password=password)
    if user is not None:
        auth_login(request, user)
        user_data = {
            'token': Token.objects.get(user=user).key,
            'first_name': user.first_name,
            'last_name': user.last_name
        }
        return Response(user_data)
    raise AuthenticationFailed("Username / password do not match")


@api_view(['POST'])
@csrf_exempt
def password_reset_request(request):
    """
    Sends out the password reset mail
    FIXIT: Fails because of no is_active field on User model
    """
    email = request.POST.get("email", "")
    if not email:
        raise AuthenticationFailed('Your registered email address must be provided to reset password')

    form = PasswordResetForm(request.POST)
    if form.is_valid():
        opts = {
            'use_https': request.is_secure(),
            'request': request,
        }

        form.save(**opts)
        return Response({'success': 'Password reset email sent'})
    else:
        raise AuthenticationFailed(', '.join(form.errors))


class OrganizationsView(generics.ListCreateAPIView):
    serializer_class = OrganizationSerializer
    paginate_by = 50
    permission_classes = (OrganizationsPermission,)

    def create(self, request):
        '''
            Only allows superusers to create new organizations.
        '''
        if not request.user.is_superuser:
            raise PermissionDenied()
        return super(OrganizationsView, self).create(request)

    def get_queryset(self):
        '''
            Gets list of organizations.
            If superuser, get all orgs.
            Else, get only the user's own orgs.
        '''
        user = self.request.user
        if not user.is_authenticated():
            raise PermissionDenied()
        qset = Organization.objects.all()
        if user.is_superuser:
            return qset
        else:
            return Organization.objects.filter(users=user)

    def post_save(self, obj, created=False):
        '''
            When creating an organization, make the user that created
            the organization an admin user in the organization.
        '''
        if created:
            admin_user = self.request.user
            user_org = UserOrganization(user=admin_user, organization=obj,
                                        role=0)
            user_org.save()


class OrganizationView(generics.RetrieveUpdateAPIView):
    serializer_class = OrganizationSerializer
    permission_classes = (OrganizationPermission,)
    model = Organization


class OrganizationUsersView(generics.ListCreateAPIView):
    serializer_class = OrganizationUserSerializer
    paginate_by = 50
    permission_classes = (OrganizationUsersPermission,)

    def pre_save(self, obj):
        obj.organization_id = self.kwargs['org_pk']

    def get_queryset(self):
        org_id = self.kwargs['org_pk']
        organization = get_object_or_404(Organization, pk=org_id)
        return organization.userorganization_set.all()


class OrganizationUserView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = OrganizationUserSerializer
    permission_classes = (OrganizationUsersPermission,)

    def get_object(self):
        organization_id = self.kwargs['org_pk']
        user_id = self.kwargs['user_pk']
        org_user = get_object_or_404(UserOrganization, user=user_id,
                                     organization=organization_id)
        return org_user


class VolunteerActivitiesView(generics.ListCreateAPIView):
    serializer_class = VolunteerActivitySerializer
    paginate_by = 50
    permission_classes = (VolunteerActivitiesPermission,)
    filter_class = VolunteerActivityFilter

    def get_queryset(self):
        return VolunteerActivity.objects.all()


@api_view(['GET'])
def volunteer_activity_dates(request):
    '''
        Fetches valid volunteer dates, accepts some filters
    '''
    now = datetime.datetime.now()
    #qset = VolunteerActivity.objects.all()
    qset = VolunteerActivity.objects.filter(date__gte=now)
    school = request.GET.get('school', None)
    typ = request.GET.get('type', None)
    organization = request.GET.get('organization', None)
    if school:
        qset = qset.objects.filter(school_id=school)
    if typ:
        qset = qset.objects.filter(type_id=typ)
    if organization:
        qset = qset.objects.filter(organization_id=organization)
    qset = qset.values('date').distinct()
    dates = [o['date'].strftime("%Y-%m-%d") for o in qset]
    return Response(dates)


class VolunteerActivityView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = VolunteerActivitySerializer
    permission_classes = (VolunteerActivitiesPermission,)
    model = VolunteerActivity


class VolunteerActivityTypesView(generics.ListCreateAPIView):
    serializer_class = VolunteerActivityTypeSerializer
    paginate_by = 50
    permission_classes = (IsAdminToWrite,)

    def get_queryset(self):
        return VolunteerActivityType.objects.all()


class VolunteerActivityTypeView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = VolunteerActivityTypeSerializer
    permission_classes = (permissions.IsAdminUser,)
    model = VolunteerActivityType


class VolunteerActivityUsersView(generics.ListCreateAPIView):
    serializer_class = UserVolunteerActivitySerializer
    paginate_by = 50
    permission_classes = (permissions.IsAuthenticated,)

    def pre_save(self, obj):
        obj.activity_id = self.kwargs['activity_pk']
        obj.user_id = self.request.user.id

    def get_queryset(self):
        activity_id = self.kwargs['activity_pk']
        activity = get_object_or_404(VolunteerActivity, pk=activity_id)
        organization = activity.organization

        #FIXME: should this be be moved to a permission class?
        if not organization.has_read_perms(self.request.user):
            raise PermissionDenied()
        return UserVolunteerActivity.objects.filter(activity=activity_id)


class VolunteerActivityUserView(generics.RetrieveUpdateDestroyAPIView):
    '''
        View to update status of user volunteer activities as well
        as delete them.
        Only users with write perms on organization who owns the activity
        can change status.
        Only volunteer user can delete.
    '''
    serializer_class = UserVolunteerActivitySerializer
    permission_classes = (UserVolunteerActivityPermission,)

    def update(self, request, *args, **kwargs):
        if kwargs['partial'] is not True:
            raise MethodNotAllowed("Use PATCH to change status")
        return super(VolunteerActivityUserView, self).update(request,
                                                             *args, **kwargs)

    def get_object(self):
        activity_id = self.kwargs['activity_pk']
        user_id = self.kwargs['user_pk']
        return get_object_or_404(UserVolunteerActivity, user=user_id,
                                 activity=activity_id)


class DonationItemCategoriesView(generics.ListCreateAPIView):
    serializer_class = DonationItemCategorySerializer
    permission_classes = (IsAdminToWrite,)
    paginate_by = 50

    def get_queryset(self):
        return DonationItemCategory.objects.all()


class DonationRequirementsView(generics.ListCreateAPIView):
    serializer_class = DonationRequirementSerializer
    paginate_by = 50
    permission_classes = (DonationRequirementsPermission,)
    filter_class = DonationRequirementFilter

    def get_queryset(self):
        return DonationRequirement.objects.all()


class UserDonationItemCreateView(generics.CreateAPIView):
    serializer_class = UserDonationItemSerializer
    model = UserDonationItem


class UserDonationItemModifyView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = UserDonationItemSerializer
    model = UserDonationItem
    #FIXME: add permissions, etc.



# class DonorRequirementView(generics.RetrieveUpdateDestroyAPIView):
#     serializer_class = DonorRequirementSerializer
#     permission_classes = (DonorRequirementsPermission,)
#     model = DonorRequirement


# class DonationTypesView(generics.ListCreateAPIView):
#     serializer_class = DonationTypeSerializer
#     paginate_by = 50
#     permission_classes = (IsAdminToWrite,)

#     def get_queryset(self):
#         return DonationType.objects.all()


# class DonationTypeView(generics.RetrieveUpdateDestroyAPIView):
#     serializer_class = DonationTypeSerializer
#     permission_classes = (permissions.IsAdminUser,)
#     model = DonationType


# class DonorRequirementUsersView(generics.ListCreateAPIView):
#     serializer_class = UserDonorRequirementSerializer
#     permission_classes = (permissions.IsAuthenticated,)
#     paginate_by = 50

#     def pre_save(self, obj):
#         obj.donor_requirement_id = self.kwargs['requirement_pk']
#         obj.user_id = self.request.user.id

#     def get_queryset(self):
#         requirement_id = self.kwargs['requirement_pk']
#         requirement = get_object_or_404(DonorRequirement, pk=requirement_id)
#         organization = requirement.organization

#         #FIXME: should this be be moved to a permission class?
#         if not organization.has_read_perms(self.request.user):
#             raise PermissionDenied()
#         return UserDonorRequirement.objects.filter(donor_requirement=requirement_id)


# class DonorRequirementUserView(generics.RetrieveUpdateDestroyAPIView):
#     '''
#         View to update status of user donor requirements as well
#         as delete them.
#         Only users with write perms on organization who owns the requirement
#         can change status.
#         Only volunteer user can delete.
#     '''
#     serializer_class = UserDonorRequirementSerializer
#     permission_classes = (UserDonorRequirementPermission,)

#     def update(self, request, *args, **kwargs):
#         if kwargs['partial'] is not True:
#             raise MethodNotAllowed("Use PATCH to change status")
#         return super(DonorRequirementUserView, self).update(request,
#                                                             *args, **kwargs)

#     def get_object(self):
#         requirement_id = self.kwargs['requirement_pk']
#         user_id = self.kwargs['user_pk']
#         return get_object_or_404(UserDonorRequirement, user=user_id,
#                                  donor_requirement=requirement_id)
