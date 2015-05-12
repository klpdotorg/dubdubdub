from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse
from django.core.urlresolvers import resolve, Resolver404
from django.conf import settings
from django.db.models import Q, Count
from django.utils import timezone

from schools.models import School, SchoolDetails
from users.models import User
from .models import (Question, Story, StoryImage, Answer, Questiongroup,
                     UserType, Source)
from .serializers import (SchoolQuestionsSerializer, StorySerializer,
    StoryWithAnswersSerializer)

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView
from common.mixins import CacheMixin
from rest_framework.exceptions import (APIException, PermissionDenied,
    ParseError, MethodNotAllowed, AuthenticationFailed)
from rest_framework import authentication, permissions

import random
import calendar
import datetime
from base64 import b64decode
from collections import Counter, OrderedDict
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

class StoryVolumeView(KLPAPIView, CacheMixin):
    """Returns the number of stories per month per year.

    admin1 -- ID of the District.
    admin2 -- ID of the Block/Project.
    admin3 -- ID of the Cluster/Circle.
    school_id -- ID of the school.
    from -- YYYY-MM-DD from when the data should be filtered.
    to -- YYYY-MM-DD till when the data should be filtered.
    school_type -- Type of School [Primary School/PreSchool].
    """

    def get(self, request):
        admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
        admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
        admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
        school_id = self.request.QUERY_PARAMS.get('school_id', None)
        start_date = self.request.QUERY_PARAMS.get('from', None)
        end_date = self.request.QUERY_PARAMS.get('to', None)
        school_type = self.request.QUERY_PARAMS.get(
            'school_type', 'Primary School')

        if start_date:
            sane = self.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = self.get_datetime(start_date)

        if end_date:
            sane = self.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = self.get_datetime(end_date)

        response_json = {}

        stories_qset = Story.objects.filter(
            school__admin3__type__name=school_type)

        if admin1_id:
            stories_qset = stories_qset.filter(
                school__schooldetails__admin1__id=admin1_id)

        if admin2_id:
            stories_qset = stories_qset.filter(
                school__schooldetails__admin2__id=admin2_id)

        if admin3_id:
            stories_qset = stories_qset.filter(
                school__schooldetails__admin3__id=admin3_id)

        if school_id:
            stories_qset = stories_qset.filter(
                school=school_id)

        if start_date:
            stories_qset = stories_qset.filter(
                date_of_visit__gte=start_date)

        if end_date:
            stories_qset = stories_qset.filter(
                date_of_visit__lte=end_date)

        story_dates = stories_qset.values_list('date_of_visit', flat=True)

        json = {}
        for date in story_dates:
            if date.year in json:
                json[date.year].append(date.month)
            else:
                json[date.year] = []
                json[date.year].append(date.month)

        per_month_json = {}
        for year in json:
            per_month_json[year] = dict(Counter(
                [calendar.month_abbr[date] for date in json[year]])
            )

        ordered_per_month_json = {}
        months = "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split()
        for year in per_month_json:
            ordered_per_month_json[year] = OrderedDict()
            for month in months:
                ordered_per_month_json[year][month] = per_month_json[year].get(month, 0)

        response_json['volumes'] = ordered_per_month_json
        return Response(response_json)

        def get_datetime(self, date):
            return datetime.datetime.strptime(date, '%Y-%m-%d')

        def check_date_sanity(self, date):
            try:
                year = date.split("-")[0]
                month = date.split("-")[1]
                day = date.split("-")[2]
            except:
                return False

            if not self.is_day_correct(day):
                return False

            if not self.is_month_correct(month):
                return False

            if not self.is_year_correct(year):
                return False

            return True

        def is_day_correct(self, day):
            return int(day) in range(1,32)

        def is_month_correct(self, month):
            return int(month) in range(1,13)

        def is_year_correct(self, year):
            return (len(year) == 4 and int(year) <= timezone.now().year)


class StoryDetailView(KLPAPIView, CacheMixin):
    """Returns questions and their corresponding answers.

    source -- Source of data [web/ivrs].
    admin1 -- ID of the District.
    admin2 -- ID of the Block/Project.
    admin3 -- ID of the Cluster/Circle.
    school_id -- ID of the school.
    from -- YYYY-MM-DD from when the data should be filtered.
    to -- YYYY-MM-DD till when the data should be filtered.
    school_type -- Type of School [Primary School/PreSchool].
    """

    def get(self, request):
        source = self.request.QUERY_PARAMS.get('source', None)
        admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
        admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
        admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
        school_id = self.request.QUERY_PARAMS.get('school_id', None)
        start_date = self.request.QUERY_PARAMS.get('from', None)
        end_date = self.request.QUERY_PARAMS.get('to', None)
        school_type = self.request.QUERY_PARAMS.get(
            'school_type', 'Primary School')

        if start_date:
            sane = self.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = self.get_datetime(start_date)

        if end_date:
            sane = self.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = self.get_datetime(end_date)

        stories = Story.objects.all()

        if source:
            stories = stories.filter(group__source__name=source)

        if school_type:
            stories = stories.filter(school__admin3__type__name=school_type)

        if admin1_id:
            stories = stories.filter(
                school__schooldetails__admin1__id=admin1_id
            )

        if admin2_id:
            stories = stories.filter(
                school__schooldetails__admin2__id=admin2_id
            )

        if admin3_id:
            stories = stories.filter(
                school__schooldetails__admin3__id=admin3_id
            )

        if school_id:
            stories = stories.filter(school__id=school_id)

        if start_date:
            stories = stories.filter(date_of_visit__gte=start_date)

        if end_date:
            stories = stories.filter(date_of_visit__lte=end_date)

        response_json = {}

        # Sources and filters
        if source:
            response_json[source] = self.get_que_and_ans(
                stories, source, school_type)
        else:
            sources = Source.objects.all().values_list('name', flat=True)
            for source in sources:
                response_json[source] = self.get_que_and_ans(
                    stories, source, school_type)

        return Response(response_json)

    def get_datetime(self, date):
        return datetime.datetime.strptime(date, '%Y-%m-%d')

    def check_date_sanity(self, date):
        try:
            year = date.split("-")[0]
            month = date.split("-")[1]
            day = date.split("-")[2]
        except:
            return False

        if not self.is_day_correct(day):
            return False

        if not self.is_month_correct(month):
            return False

        if not self.is_year_correct(year):
            return False

        return True

    def is_day_correct(self, day):
        return int(day) in range(1,32)

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)

    def get_que_and_ans(self, stories, source, school_type):
        response_list = []

        questions = Question.objects.filter(
            is_featured=True).select_related(
                'question_type', 'school_type'
            )

        if source:
            questions = questions.filter(
                questiongroup__source__name=source)

        if school_type:
            questions = questions.filter(
                school_type__name=school_type)

        for question in questions.distinct('id'):
            j = {}
            j['question'] = {}
            j['question']['key'] = question.key
            j['question']['text'] = question.text
            j['question']['display_text'] = question.display_text
            j['answers'] = {}
            j['answers']['question_type'] = question.question_type.name
            answer_counts = question.answer_set.filter(story__in=stories).values('text').annotate(answer_count=Count('text'))
            options = {}
            for count in answer_counts:
                options[count['text']] = count['answer_count']
            j['answers']['options'] = options
            # j['answers']['options'] = dict(
            #     Counter(
            #         [a.text for a in question.answer_set.filter(
            #             story__in=stories)]
            #     )
            # )

            response_list.append(j)

        return response_list

class StoryMetaView(KLPAPIView, CacheMixin):
    """Returns total number of stories and schools with stories
    along with respondent types.

    source -- Source of data [web/ivrs].
    admin1 -- ID of the District.
    admin2 -- ID of the Block/Project.
    admin3 -- ID of the Cluster/Circle.
    school_id -- ID of the school.
    from -- YYYY-MM-DD from when the data should be filtered.
    to -- YYYY-MM-DD till when the data should be filtered.
    school_type -- Type of School [Primary School/PreSchool].
    """

    def get(self, request):
        source = self.request.QUERY_PARAMS.get('source', None)
        admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
        admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
        admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
        school_id = self.request.QUERY_PARAMS.get('school_id', None)
        start_date = self.request.QUERY_PARAMS.get('from', None)
        end_date = self.request.QUERY_PARAMS.get('to', None)
        school_type = self.request.QUERY_PARAMS.get(
            'school_type', 'Primary School')

        if start_date:
            sane = self.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = self.get_datetime(start_date)

        if end_date:
            sane = self.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = self.get_datetime(end_date)

        school_qset = School.objects.filter(
            admin3__type__name=school_type, status=2)
        stories_qset = Story.objects.filter(
            school__admin3__type__name=school_type)

        if admin1_id:
            school_qset = school_qset.filter(
                schooldetails__admin1__id=admin1_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin1__id=admin1_id)

        if admin2_id:
            school_qset = school_qset.filter(
                schooldetails__admin2__id=admin2_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin2__id=admin2_id)

        if admin3_id:
            school_qset = school_qset.filter(
                schooldetails__admin3__id=admin3_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin3__id=admin3_id)

        if school_id:
            school_qset = school_qset.filter(id=school_id)
            stories_qset = stories_qset.filter(
                school=school_id)

        response_json = {}

        response_json['total'] = {}
        response_json['total']['schools'] = school_qset.count()
        response_json['total']['schools_with_stories'] = school_qset.filter(
            story__isnull=False
        ).distinct('id').count()
        response_json['total']['stories'] = stories_qset.count()

        if source:
             response_json[source] = self.get_count(
                 source, admin1_id, admin2_id, admin3_id, school_id,
                 start_date, end_date, school_type,
             )
        else:
            sources = Source.objects.all().values_list('name', flat=True)
            for source in sources:
                response_json[source] = self.get_count(
                    source, admin1_id, admin2_id, admin3_id, school_id,
                    start_date, end_date, school_type,
                )

        response_json['respondents'] = self.get_respondents(school_type, stories_qset)

        return Response(response_json)

    def get_respondents(self, school_type, stories_qset):
        usertypes = {
            'PR' : 'PARENTS',
            'TR' : 'TEACHERS',
            'VR' : 'VOLUNTEER',
            'CM' : 'CBO_MEMBER',
            'HM' : 'HEADMASTER',
            'SM' : 'SDMC_MEMBER',
            'LL' : 'LOCAL_LEADER',
            'AS' : 'AKSHARA_STAFF',
            'EY' : 'EDUCATED_YOUTH',
            'EO' : 'EDUCATION_OFFICIAL',
            'ER' : 'ELECTED_REPRESENTATIVE',
        }
        user_counts = UserType.objects.filter(
            story__in=stories_qset
        ).annotate(
            story_count=Count('story')
        )
        return {usertypes[user.name]: user.story_count for user in user_counts}

    def get_datetime(self, date):
        return datetime.datetime.strptime(date, '%Y-%m-%d')

    def check_date_sanity(self, date):
        try:
            year = date.split("-")[0]
            month = date.split("-")[1]
            day = date.split("-")[2]
        except:
            return False

        if not self.is_day_correct(day):
            return False

        if not self.is_month_correct(month):
            return False

        if not self.is_year_correct(year):
            return False

        return True

    def is_day_correct(self, day):
        return int(day) in range(1,32)

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)

    def get_count(self, *args):
        source = args[0]
        admin1_id = args[1]
        admin2_id = args[2]
        admin3_id = args[3]
        school_id = args[4]
        start_date = args[5]
        end_date = args[6]
        school_type = args[7]

        school_qset = School.objects.filter(
            admin3__type__name=school_type, status=2)
        stories_qset = Story.objects.filter(
            school__admin3__type__name=school_type)

        if source:
            school_qset = school_qset.filter(
                story__group__source__name=source)
            stories_qset = stories_qset.filter(
                group__source__name=source)

        if admin1_id:
            school_qset = school_qset.filter(
                schooldetails__admin1__id=admin1_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin1__id=admin1_id)

        if admin2_id:
            school_qset = school_qset.filter(
                schooldetails__admin2__id=admin2_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin2__id=admin2_id)

        if admin3_id:
            school_qset = school_qset.filter(
                schooldetails__admin3__id=admin3_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin3__id=admin3_id)

        if school_id:
            school_qset = school_qset.filter(id=school_id)
            stories_qset = stories_qset.filter(school__id=school_id)

        if start_date:
            school_qset = school_qset.filter(
                story__date_of_visit__gte=start_date)
            stories_qset = stories_qset.filter(
                date_of_visit__gte=start_date)

        if end_date:
            school_qset = school_qset.filter(
                story__date_of_visit__lte=end_date)
            stories_qset = stories_qset.filter(
                date_of_visit__lte=end_date)

        json = {}
        json['schools'] = school_qset.filter(
            story__isnull=False
        ).distinct('id').count()
        json['stories'] = stories_qset.count()
        if source == "web":
            json['verified_stories'] = stories_qset.filter(
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
