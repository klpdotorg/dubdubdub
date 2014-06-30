from django.contrib.auth import login, authenticate, logout
from django.shortcuts import get_object_or_404
from .models import User, Organization, UserOrganization, VolunteerActivity,\
    VolunteerActivityType
from .serializers import UserSerializer, OrganizationSerializer,\
    OrganizationUserSerializer, VolunteerActivitySerializer,\
    VolunteerActivityTypeSerializer
from .permissions import UserListPermission, IsAdminOrIsSelf,\
    OrganizationsPermission, OrganizationPermission,\
    OrganizationUsersPermission, VolunteerActivitiesPermission
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
        super(UsersView, self).create(*args, **kwargs)

    def get_queryset(self):
        return User.objects.all()


class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = (IsAdminOrIsSelf,)

    def get_object(self):
        return User.objects.get(id=self.request.user.id)

    def post(self, request):
        '''
            PATCH requests are made to edit user profile, disallow POST.
        '''
        raise MethodNotAllowed("POST")


@api_view(['GET'])
def signout(request):
    logout(request)
    return Response({'success': 'User logged out'})


@api_view(['POST'])
@csrf_exempt
def signin(request):
    email = request.POST.get("email", "")
    password = request.POST.get("password", "")
    user = authenticate(username=email, password=password)
    if user is not None:
        login(request, user)
        token = Token.objects.get(user=user).key
        return Response({'success': 'User logged in', 'token': token})
    raise AuthenticationFailed("Username / password do not match")


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

    def create(self, request, *args, **kwargs):
        org_id = self.kwargs['org_pk']
        request.DATA['organization'] = org_id
        return super(OrganizationUsersView, self).create(request, *args,
                                                         **kwargs)

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
        #import pdb;pdb.set_trace()
        return org_user


class VolunteerActivitiesView(generics.ListCreateAPIView):
    serializer_class = VolunteerActivitySerializer
    paginate_by = 50
    permission_classes = (VolunteerActivitiesPermission,)

    def get_queryset(self):
        qset = VolunteerActivity.objects.all()
        org_id = self.request.GET.get('organization', None)
        if org_id:
            qset = qset.filter(organization=org_id)
        #FIXME ^^: add other required filters
        return qset


class VolunteerActivityTypesView(generics.ListCreateAPIView):
    serializer_class = VolunteerActivityTypeSerializer
    paginate_by = 50

    def create(self, request, *args, **kwargs):
        if not request.user.is_superuser:
            raise PermissionDenied()
        return super(VolunteerActivityTypesView, self).create(request, *args,
                                                              **kwargs)

    def get_queryset(self):
        return VolunteerActivityType.objects.all()


class VolunteerActivityTypeView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = VolunteerActivityTypeSerializer
    permission_classes = (permissions.IsAdmin,)
    paginate_by = 50
    model = VolunteerActivityType
