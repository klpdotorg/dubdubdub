from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.db.models import Q
from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from rest_framework.exceptions import APIException, PermissionDenied,\
    ParseError, MethodNotAllowed, AuthenticationFailed
from rest_framework import authentication, permissions


class StoryQuestionsView(KLPAPIView):
    authentication_classes = (authentication.TokenAuthentication,
                              authentication.SessionAuthentication,)
    # permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, pk=None, format=None):
        print request.user.is_authenticated()
        return Response({'ok': 'ok'})
