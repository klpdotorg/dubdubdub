from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.db.models import Q

from schools.models import School
from .models import Question
from .serializers import SchoolQuestionsSerializer

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from rest_framework.exceptions import APIException, PermissionDenied,\
    ParseError, MethodNotAllowed, AuthenticationFailed
from rest_framework import authentication, permissions


class StoryQuestionsView(KLPDetailAPIView):
    serializer_class = SchoolQuestionsSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('schooldetails__type',)
