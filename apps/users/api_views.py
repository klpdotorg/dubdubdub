from django.contrib.auth import login, authenticate, logout
from .models import User
from .serializers import UserSerializer
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
