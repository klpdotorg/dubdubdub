from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.db.models import Q

from schools.models import School
from .models import Question,  Story
from .serializers import SchoolQuestionsSerializer, StorySerializer

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from rest_framework.exceptions import APIException, PermissionDenied,\
    ParseError, MethodNotAllowed, AuthenticationFailed
from rest_framework import authentication, permissions


class StoryQuestionsView(KLPDetailAPIView):
    serializer_class = SchoolQuestionsSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('schooldetails__type',)


class StoriesView(KLPListAPIView):
    serializer_class = StorySerializer
    bbox_filter_field = "school__instcoord__coord"

    def get_queryset(self):
        qset = Story.objects.filter()
        school_id = self.request.GET.get('school_id', '')
        if school_id:
            qset = qset.filter(school__id=school_id)

        verified = self.request.GET.get('verified', '')
        if verified == 'yes':
            qset = qset.filter(is_verified=True)
        elif verified == 'no':
            qset = qset.filter(is_verified=False)

        return qset
