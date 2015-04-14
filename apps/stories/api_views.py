from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.conf import settings
from django.db.models import Q
from django.utils import timezone

from schools.models import School, SchoolDetails
from users.models import User
from .models import Question, Story, StoryImage, Answer, Questiongroup
from .serializers import (SchoolQuestionsSerializer, StorySerializer,
    StoryWithAnswersSerializer)

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from rest_framework.exceptions import (APIException, PermissionDenied,
    ParseError, MethodNotAllowed, AuthenticationFailed)
from rest_framework import authentication, permissions

import random
import datetime
from base64 import b64decode
from collections import Counter
from django.core.files.base import ContentFile
from PIL import Image
from dateutil.parser import parse as date_parse

class StoryInfoView(KLPAPIView):
    def get(self, request):
        return Response({
            'total_stories': Story.objects.all().count(),
            'total_verified_stories': Story.objects.filter(
                is_verified=True).count(),
            'total_images': StoryImage.objects.all().count()
        })


class StoryMetaView(KLPAPIView):
    """Returns:
    1. Total number of Stories for Primary or Pre school for a
    given source.
    2. Number of responses per month for Primary or Pre school
    for a given source, for a given Block/Project and/or
    Cluster/Circle.
    3. Questions and their corresponsing answers for
    Primary or Pre schools for a given source, for a given
    Block/Project and/or Cluster/Circle.

    source -- Source of data [web/ivrs].
    admin1 -- ID of the District to search inside.
    admin2 -- ID of the Block/Project to search inside.
    admin3 -- ID of the Cluster/Circle to search inside.
    school_type -- Type of School [Primary School/PreSchool].
    """

    def get(self, request):
        qset = Story.objects.filter()
        source = self.request.QUERY_PARAMS.get('source', None)
        admin1_id = self.request.QUERY_PARAMS.get('district', None)
        admin2_id = self.request.QUERY_PARAMS.get('block', None)
        admin3_id = self.request.QUERY_PARAMS.get('cluster', None)
        school_type = self.request.QUERY_PARAMS.get('school_type', 'Primary School')

        # if not source:
        #     raise APIException("Source (ivrs, web) not mentioned")

        # if not school_type:
        #     raise APIException("School Type (Primary School, PreSchool) not mentioned")

        response_json = {}

        if source:
            response_json[source] = self.get_count(source)
        else:
            # Total summary
            response_json['total'] = {}
            response_json['total']['schools'] = School.objects.all().count()
            response_json['total']['schools_with_stories'] = School.objects.filter(
                story__isnull=False
            ).count()
            response_json['total']['stories'] = Story.objects.all().count()

            sources = Source.objects.all().values_list('name', flat=True)
            for source in sources:
                response_json[source] = self.get_count(source)

        response_json['school_type'] = school_type

        question_group = Questiongroup.objects.get(
            source__name=source)

        # Number of Responses
        total_responses = qset.filter(
            group=question_group, school__admin3__type__name=school_type
        ).count()

        yesterday = timezone.now().date() - datetime.timedelta(days=1)

        responses_yesterday = qset.filter(
            group=question_group,
            school__admin3__type__name=school_type,
            date_of_visit=yesterday
        ).count()

        response_json['total_responses'] = total_responses
        response_json['responses_yesterday'] = responses_yesterday

        # Number of Responses per month
        if admin1_id:
            qset = qset.filter(school__schooldetails__admin1__id=admin1_id)

        if admin2_id:
            qset = qset.filter(school__schooldetails__admin2__id=admin2_id)

        if admin3_id:
            qset = qset.filter(school__schooldetails__admin3__id=admin3_id)

        story_dates = qset.filter(
            group=question_group, school__admin3__type__name=school_type
        ).values_list('date_of_visit', flat=True)

        per_month_responses = dict(Counter(
            [date.month for date in story_dates]))

        response_json['per_month_responses'] = per_month_responses

        # List of questions and their answer counts
        questions = Question.objects.filter(
            questiongroup=question_group,
            school_type__name=school_type,
        ).select_related(
            'question_type', 'school_type'
        ).prefetch_related('answer_set')

        response_json['questions'] = []

        for question in questions:
            j = {}
            j['question'] = question.text
            j['answers'] = {}
            j['answers']['question_type'] = question.question_type.name
            j['answers']['options'] = dict(
                Counter([a.text for a in question.answer_set.filter(story__in=qset)])
            )

            response_json['questions'].append(j)

        return Response(response_json)

    def get_count(self, source):
        json = {}
        json['schools'] = School.objects.filter(
            story__group__source__name=source).count()
        json['schools_with_stories'] = School.objects.filter(
            story__group__source__name=source,
            story__isnull=False
        ).count()
        json['stories'] = Story.objects.filter(
            group__source__name=source,
        ).count()
        if source == "web":
            json['verified_stories'] = Story.object.filter(
                group__source__name=source,
                is_verified=True,
            ).count()

        return json


class StoryQuestionsView(KLPDetailAPIView):
    serializer_class = SchoolQuestionsSerializer

    def get_queryset(self):
        return School.objects.filter(status=2)\
            .select_related('schooldetails__type',)


class StoriesView(KLPListAPIView):
    """Returns the stories for a given school

    URL params:
    school_id   ID of the school whose stories are needed
    answers     [yes, no] if answers should be returned
    verified    [yes, no] if only verified or not-verified stories should be
                returned, if not mentioned, returns all
    limit       any positive integer, number of results needed
    """
    bbox_filter_field = "school__instcoord__coord"

    def get_serializer_class(self):
        get_answers = self.request.GET.get('answers', 'no')

        if get_answers == 'yes':
            return StoryWithAnswersSerializer
        elif get_answers == 'no':
            return StorySerializer
        else:
            raise ParseError("answers param must be either 'yes' or 'no'.")

    def get_queryset(self):
        qset = Story.objects.filter()
        school_id = self.request.GET.get('school_id', '')
        if school_id:
            qset = qset.filter(school__id=school_id)

        verified = self.request.GET.get('verified', None)
        if verified:
            if verified == 'yes':
                qset = qset.filter(is_verified=True)
            elif verified == 'no':
                qset = qset.filter(is_verified=False)
            else:
                raise ParseError("verified param must be either 'yes' or 'no' if provided.")

        source = self.request.GET.get('source', '')
        if source:
            qset = qset.filter(group__source__name=source)

        admin1_id = self.request.GET.get('admin1', '')
        if admin1_id:
            qset = qset.filter(school__schooldetails__admin1__id=admin1_id)

        admin2_id = self.request.GET.get('admin2', '')
        if admin2_id:
            qset = qset.filter(school__schooldetails__admin2__id=admin2_id)

        admin3_id = self.request.GET.get('admin3', '')
        if admin3_id:
            qset = qset.filter(school__schooldetails__admin3__id=admin3_id)

        try:
            limit = int(self.request.GET.get('limit', 10))
        except:
            limit = 10

        qset = qset.prefetch_related(
            'storyimage_set').select_related('school')[:limit]

        return qset


class ShareYourStoryView(KLPAPIView):
    def post(self, request, pk=None):
        name = request.POST.get('name', 'Anonymous User')
        email = request.POST.get('email', '')
        comments = request.POST.get('comments', '')
        telephone = request.POST.get('telephone', '')
        date_of_visit = date_parse(request.POST.get('date_of_visit', ''), yearfirst=True)

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
            telephone=telephone,
            date_of_visit=date_of_visit,
            group_id=1,
            comments=comments.strip()
        )
        story.save()

        try:
            user = User.objects.get(email=email)
            story.user = user
            story.save()
        except Exception, e:
            pass

        for key in request.POST.keys():
            if not key.startswith('question_'):
                continue

            _, qid = key.split('_')
            try:
                question = Question.objects.get(
                    qid=qid,
                    school_type=school.schooldetails.type,
                    is_active=True
                )
                print question
                answer = Answer(
                    story=story,
                    question=question,
                    text=request.POST.get(key)
                )
                answer.save()
            except Exception, e:
                print e

        images = request.POST.getlist('images[]')
        for image in images:
            image_type, data = image.split(',')
            image_data = b64decode(data)
            file_name = '{}_{}.png'.format(school.id, random.randint(0, 9999))

            simage = StoryImage(
                story=story,
                filename=file_name,
                image=ContentFile(image_data, file_name)
            )
            simage.save()

            try:
                import os
                pil_image = Image.open(simage.image)
                pil_image.thumbnail((128, 128), )

                thumb_path = os.path.join(
                    settings.MEDIA_ROOT, 'sys_images', 'thumb', file_name)
                pil_image.save(open(thumb_path, 'w'))
            except Exception as e:
                print e

        return Response({
            'success': 'Story has been saved'
        })
