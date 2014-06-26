from django.contrib.auth import login, authenticate, logout
from django.shortcuts import get_object_or_404
from .models import User, Organization, UserOrganization
from .serializers import UserSerializer, OrganizationSerializer, OrganizationUserSerializer
from common.utils import render_to_json_response
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authtoken.models import Token
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.exceptions import APIException, PermissionDenied, ParseError, MethodNotAllowed
from rest_framework import authentication, permissions
from rest_framework.decorators import api_view


class TestAuthenticatedView(APIView):
    authentication_classes = (authentication.TokenAuthentication, authentication.SessionAuthentication,)
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, format=None):
        return Response({
            'logged_in_as': request.user.email
        })


class UsersView(generics.ListCreateAPIView):
    serializer_class = UserSerializer
    paginate_by = 50

    def create(self, *args, **kwargs):
        #FIXME: move validation into serializer validate methods
        email = self.request.POST.get('email', None)
        mobile_no = self.request.POST.get('mobile_no', None)
        first_name = self.request.POST.get('first_name', None)
        last_name = self.request.POST.get('last_name', None)
        if not email or not mobile_no or not first_name or not last_name:
            raise ParseError("Insufficient data: required fields are email, mobile_no, first_name and last_name")
        if User.objects.filter(email=email).count() > 0:
            raise APIException("duplicate email")
        password = self.request.POST.get('password', '')
        if password == '':
            raise ParseError("No password supplied")
        super(UsersView, self).create(*args, **kwargs)

    def get_queryset(self):
        if not self.request.user.is_superuser:
            raise PermissionDenied()
        return User.objects.all()


class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer

    def get_object(self):
        if not self.request.user.is_authenticated():
            raise PermissionDenied("You need to be logged in to view / edit your profile")
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
    raise PermissionDenied("Username / password do not match")


class OrganizationsView(generics.ListCreateAPIView):
    serializer_class = OrganizationSerializer
    paginate_by = 50

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
            user_org = UserOrganization(user=admin_user, organization=obj, role=0)
            user_org.save()


class OrganizationView(generics.RetrieveUpdateAPIView):
    serializer_class = OrganizationSerializer

    def partial_update(self, request, pk=None):
        organization = get_object_or_404(Organization, pk=pk)
        if not organization.has_write_perms(request.user):
            raise PermissionDenied()
        return super(OrganizationView, self).update(request)

    def retrieve(self, request, pk=None):
        pk = self.kwargs['pk']
        organization = get_object_or_404(Organization, pk=pk)
        if not organization.has_read_perms(request.user):
            raise PermissionDenied()
        return super(OrganizationView, self).update(request)

    def get_object(self):
        pk = self.kwargs['pk']
        return get_object_or_404(Organization, pk=pk)


class OrganizationUsersView(generics.ListCreateAPIView):
    serializer_class = OrganizationUserSerializer
    paginate_by = 50

    def create(self, request, *args, **kwargs):
        org_id = self.kwargs['org_pk']
        request.DATA['organization'] = org_id
        return super(OrganizationUsersView, self).create(request, *args, **kwargs)


    def get_queryset(self):
        org_id = self.kwargs['org_pk']
        organization = get_object_or_404(Organization, pk=org_id)
        if not organization.has_read_perms(self.request.user):
            raise PermissionDenied()
        return organization.userorganization_set.all()


class OrganizationUserView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = OrganizationUserSerializer

    def get_object(self):
        organization_id = self.kwargs['org_pk']
        user_id = self.kwargs['user_pk']
        org_user = get_object_or_404(UserOrganization, user=user_id, organization=organization_id)
        #import pdb;pdb.set_trace()
        return org_user