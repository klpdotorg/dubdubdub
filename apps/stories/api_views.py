from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.db.models import Q

from schools.models import School
from .models import Question,  Story, StoryImage
from .serializers import SchoolQuestionsSerializer, StorySerializer, StoryWithAnswersSerializer

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from rest_framework.exceptions import APIException, PermissionDenied,\
    ParseError, MethodNotAllowed, AuthenticationFailed
from rest_framework import authentication, permissions

import random
from base64 import b64decode
from django.core.files.base import ContentFile


class StoryInfoView(KLPAPIView):
    def get(self, request):
        return Response({
            'total_stories': Story.objects.all().count(),
            'total_verified_stories': Story.objects.filter(is_verified=True).count(),
            'total_images': StoryImage.objects.all().count()
        })

class StoryQuestionsView(KLPDetailAPIView):
    serializer_class = SchoolQuestionsSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('schooldetails__type',)


class StoriesView(KLPListAPIView):
    bbox_filter_field = "school__instcoord__coord"

    def get_serializer_class(self):
        get_answers = self.request.GET.get('answers', 'no')

        if get_answers == 'yes':
            return StoryWithAnswersSerializer
        else:
            return StorySerializer

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


class ShareYourStoryView(KLPAPIView):
    def post(self, request, pk=None):
        name = request.POST.get('name', 'Anonymous User')
        email = request.POST.get('email', '')
        comments = request.POST.get('comments', '')

        try:
            school = School.objects.get(pk=pk)
        except Exception, e:
            return Response({
                'error': 'School not found'
            }, status=404)

        story = Story(
            email=email,
            name=name,
            school=school,
            group_id=1,
            comments=comments.strip()
        )
        story.save()

        for key in request.POST.keys():
            if not key.startswith('question_'):
                continue

            _, qid = key.split('_')
            try:
                question = Question.objects.get(qid=qid)
                answer = Answer(
                    story=story,
                    question=question,
                    text="Yes" if request.POST.get(key) in ["on", "Yes"] else "No"
                )
                answer.save()
            except Exception, e:
                pass

        images = request.POST.getlist('images[]')
        for image in images:
            image_type, data = image.split(',')
            image_data = b64decode(data)
            simage = StoryImage(
                story=story,
                image=ContentFile(image_data, '{}_{}.png'.format(school.id, random.randint(0, 999)))
            )
            simage.save()

        return Response({
            'success': 'Story has been saved'
        })
