from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.conf import settings
from django.db.models import Q

from schools.models import School, SchoolDetails
from users.models import User
from .models import Question, Story, StoryImage, Answer, Questiongroup
from .serializers import (SchoolQuestionsSerializer, StorySerializer,
    StoryWithAnswersSerializer)

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from rest_framework.exceptions import (APIException, PermissionDenied,
    ParseError, MethodNotAllowed, AuthenticationFailed)
from rest_framework import authentication, permissions

import json
import random
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
    def get(self, request):
        source = self.request.QUERY_PARAMS.get('source', None)
        district_id = self.request.QUERY_PARAMS.get('district', None)
        block_id = self.request.QUERY_PARAMS.get('block', None)

        A = '1'
        B = '2'
        C = '3'
        NO = '0'
        YES = '1'

        source = "ivrs"

        A = '1'
        B = '2'
        C = '3'
        NO = '0'
        YES = '1'

        response_json = {}
        response_json['Primary School'] = {}
        response_json['PreSchool'] = {}

        question_group = Questiongroup.objects.get(
            source__name=source)

        # Number of Responses
        total_response_primary = Story.objects.filter(
            group=question_group, school__admin3__type__name="Primary School").count()
        total_response_pre = Story.objects.filter(
            group=question_group, school__admin3__type__name="PreSchool").count()
        total_responses = Story.objects.filter(
            group=question_group).count()

        response_json['Primary School']['total_responses'] = total_response_primary
        response_json['PreSchool']['total_responses'] = total_response_pre

        # Number of Responses per month
        primary_school_story_dates = Story.objects.filter(
            group=question_group, school__admin3__type__name="Primary School"
        ).values_list('date', flat=True)
        pre_school_story_dates = Story.objects.filter(
            group=question_group, school__admin3__type__name="PreSchool"
        ).values_list('date', flat=True)
        per_month_primary_response = json.dumps(Counter(
            [date.split()[0].split("-")[1] for date in primary_school_story_dates]))
        per_month_pre_response = json.dumps(Counter(
            [date.split()[0].split("-")[1] for date in pre_school_story_dates]))

        response_json['Primary School']['per_month_responses'] = per_month_primary_response
        response_json['PreSchool']['per_month_responses'] = per_month_pre_response

        # List of questions and their answer counts
        questions = Question.objects.filter(
            questiongroup__source__name="ivrs"
        )

        response_json['Primary School']['questions'] = []
        response_json['PreSchool']['questions'] = []

        for question in questions:
            j = {}
            j['question'] = question.text
            j['answers'] = {}
            if question.question_type.name == "checkbox":
                j['answers']['Yes'] = Counter(
                    question.answer_set.all().values_list('text', flat=True))[YES]
                j['answers']['No'] = Counter(
                    question.answer_set.all().values_list('text', flat=True))[NO]
            elif "Approximately how many" in question.text:
                answers = question.answer_set.all().values_list('text', flat=True)
                j['answers']['1-30'] = self.get_count(answers, start=0, end=30)
                j['answers']['31-60'] = self.get_count(answers, start=31, end=60)
                j['answers']['61+'] = self.get_count(answers, start=61)
            else:
                j['answers']['A'] = Counter(
                    question.answer_set.all().values_list('text', flat=True))[A]
                j['answers']['B'] = Counter(
                    question.answer_set.all().values_list('text', flat=True))[B]
                j['answers']['C'] = Counter(
                    question.answer_set.all().values_list('text', flat=True))[C]

            response_json[question.school_type.name]['questions'].append(j)

        return Response(response_json)

    def get_count(self, answers, start=None, end=None):
        count = 0
        if end:
            for answer in answers:
                if int(answer) in range(start, end):
                    count += 1
        else:
            for answer in answers:
                if int(answer) > start:
                    count += 1
        return count

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
                question = Question.objects.get(qid=qid)
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
