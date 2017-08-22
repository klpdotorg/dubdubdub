import ast
import random
import calendar
import datetime
import json

from PIL import Image
from base64 import b64decode
from collections import Counter, OrderedDict
from dateutil.parser import parse as date_parse

from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import authentication, permissions
from rest_framework.exceptions import (
    APIException, PermissionDenied,
    ParseError, MethodNotAllowed,
    AuthenticationFailed
)

from django.conf import settings
from django.contrib.auth.models import Group
from django.core.files.base import ContentFile
from django.db.models import Q, Count, Max, Sum
from django.contrib.gis.geos import Point

from users.models import User

from schools.models import (
    AcademicYear, AssessmentsV2, Boundary,
    BoundaryType, BoundaryUsers, School,
    SchoolDetails, SchoolExtra, StudentGroup,
    Student, StudentStudentGroup, Programme, 
)

from common.utils import Date
from common.mixins import CacheMixin
from common.views import (
    KLPAPIView, KLPDetailAPIView,
    KLPListAPIView, KLPModelViewSet
)

from .gka import GKA
from .gp_contest import GPContest

from .models import (
    Question, Story, StoryImage,
    Answer, Questiongroup, UserType,
    Source, Survey, QuestiongroupQuestions
)
from .serializers import (
    SchoolQuestionsSerializer, StorySerializer, StorySyncSerializer,
    StoryWithAnswersSerializer, QuestiongroupSerializer,
    QuestionFullSerializer, SurveySerializer, SourceSerializer
)

from. filters import (
    SurveyFilter, QuestionFilter, QuestiongroupFilter
)


class SurveysViewSet(KLPModelViewSet):
    queryset = Survey.objects.all()
    serializer_class = SurveySerializer
    filter_class = SurveyFilter


class QuestiongroupsViewSet(KLPModelViewSet):
    serializer_class = QuestiongroupSerializer
    filter_class = QuestiongroupFilter

    def get_queryset(self):
        queryset = Questiongroup.objects.all().select_related(
            'source', 'survey__partner', 'school_type'
        ).prefetch_related('created_by')

        survey_id = self.kwargs.get('survey_pk', None)
        questiongroup_id = self.kwargs.get('pk', None)

        if survey_id:
            queryset = queryset.filter(survey_id=survey_id)

        if questiongroup_id:
            queryset = queryset.filter(id=questiongroup_id)

        return queryset

    def is_questiongroup_exists(self, survey, question_ids):
        questiongroups = survey.questiongroup_set.all()
        for questiongroup in questiongroups:
            questiongroup_question_ids = questiongroup.questions.all().values_list(
                'id',
                flat=True
            )
            if set(questiongroup_question_ids) == set(question_ids):
                group_id = questiongroup.id
                version = questiongroup.version
                message = "Questiongroup already exists. Group ID: " + \
                    str(group_id) + \
                    " and Version: " + \
                    str(version)
                raise APIException(message)
        else:
            return False

    def is_questions_exist(self, question_ids):
        return Question.objects.filter(id__in=question_ids).count() == len(question_ids)

    def create_questiongroup_question_relation(self, questiongroup_id, question_ids):
        questiongroup = Questiongroup.objects.get(id=questiongroup_id)
        questions = Question.objects.filter(id__in=question_ids)
        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=questiongroup,
                question=question,
                sequence=count+1
            )

    def create(self, request, *args, **kwargs):
        survey_id = kwargs.get('survey_pk')
        question_ids = request.DATA.get('question_ids', None)

        survey = Survey.objects.get(id=survey_id)

        if question_ids:
            question_ids = ast.literal_eval(question_ids)
            if not self.is_questions_exist(question_ids):
                raise APIException("Please select valid question ids")
            self.is_questiongroup_exists(survey, question_ids)
        else:
            raise APIException("Please select one or more questions")

        serializer = self.get_serializer(data=request.DATA)
        if serializer.is_valid():
            if survey.questiongroup_set.exists():
                latest_questiongroup = survey.questiongroup_set.latest('version')
                new_version = latest_questiongroup.version + 1
            else:
                new_version = 1
            serializer.object.version = new_version
            serializer.save()
            headers = self.get_success_headers(serializer.data)
            questiongroup_id = serializer.data['id']
            self.create_questiongroup_question_relation(questiongroup_id, question_ids)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        else:
            raise APIException(serializer.errors)


class QuestionsViewSet(KLPModelViewSet):
    serializer_class = QuestionFullSerializer
    filter_class = QuestionFilter

    def get_queryset(self):
        queryset = Question.objects.all().prefetch_related(
            'questiongroupquestions_set__questiongroup',
            'questiongroupquestions_set__questiongroup__source'
        ).select_related(
            'question_type',
            'school_type'
        )

        questiongroup_id = self.kwargs.get('group_pk', None)
        question_id = self.kwargs.get('pk', None)

        if questiongroup_id:
            queryset = queryset.filter(questiongroup__id=questiongroup_id)

        if question_id:
            queryset = queryset.filter(id=question_id)

        return queryset


class SourceListView(KLPListAPIView):
    queryset = Source.objects.all()
    serializer_class = SourceSerializer


class StoriesSyncView(KLPAPIView):
    """
    Expects a POST request with JSON body
    in the format - https://gist.github.com/iambibhas/fe26fbaa252d0a4f317542d650d4979f
    """
    authentication_classes = (authentication.TokenAuthentication,
                              authentication.SessionAuthentication,)
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, format=None):
        response = {
            'success': dict(),
            'failed': [],
            'error': None
        }
        try:
            stories = json.loads(request.body)
            print stories
        except ValueError as e:
            print e
            response['error'] = 'Invalid JSON data'

        if response['error'] is None:
            for story in stories.get('stories', []):
                timestamp = int(story.get('created_at'))/1000
                sysid = None

                try:
                    sysid = int(story.get('sysid'))
                except ValueError:
                    sysid = None

                try:
                    if story.get('respondent_type') not in dict(UserType.USER_TYPE_CHOICES).keys():
                        raise Exception("Invalid respondent type")
                    user_type = UserType.objects.get(name__iexact=story.get('respondent_type'))
                    new_story, created = Story.objects.get_or_create(
                        user=request.user,
                        school_id=story.get('school_id'),
                        group_id=story.get('group_id'),
                        user_type=user_type,
                        date_of_visit=datetime.datetime.fromtimestamp(timestamp)
                    )

                    if created:
                        new_story.sysid = sysid
                        new_story.is_verified = True
                        new_story.telephone = request.user.mobile_no
                        new_story.name = request.user.get_full_name()
                        new_story.email = request.user.email

                        # Save location info
                        if story.get('lat', None) is not None and story.get('lng', None) is not None:
                            new_story.location = Point(story.get('lat'), story.get('lng'))

                        new_story.save()

                    for answer in story.get('answers', []):
                        new_answer, created = Answer.objects.get_or_create(
                            text=answer.get('text'),
                            story=new_story,
                            question=Question.objects.get(pk=answer.get('question_id'))
                        )
                    response['success'][story.get('_id')] = new_story.id
                except Exception as e:
                    print "Error saving stories and answers:", e
                    response['failed'].append(story.get('_id'))
                    # price traceback
                    import traceback; traceback.print_exc();
        return Response(response)


class StoryInfoView(KLPAPIView):
    def get(self, request):
        school_type = BoundaryType.objects.get(name='Primary School')
        school_qset = School.objects.filter(
            admin3__type=school_type, status=2, id__gte=settings.STATE_STARTING_SCHOOL_ID
        ).order_by().values('id')
       
        stories_qset = Story.objects.select_related(
            'school', 'user'
        ).filter(
            school__in=school_qset
        )

        return Response({
            'total_stories': stories_qset.count(),
            'total_verified_stories': stories_qset.filter(
                is_verified=True).count(),
            'total_images': StoryImage.objects.filter(
                story__in=stories_qset
            ).count()
        })


class StoryVolumeView(KLPAPIView, CacheMixin):
    """Returns the number of stories per month per year.

    survey -- Survey which the data belongs to 
              [Ganitha Kalika Andolana/GP Contest]
    source -- Source of data [web/ivrs].
    version -- Questiongroup versions. eg: ?version=2&version=3
    admin1 -- ID of the District.
    admin2 -- ID of the Block/Project.
    admin3 -- ID of the Cluster/Circle.
    school_id -- ID of the school.
    mp_id -- ID of the MP constituency.
    mla_id -- ID of the MLA constituency.
    from -- YYYY-MM-DD from when the data should be filtered.
    to -- YYYY-MM-DD till when the data should be filtered.
    school_type -- Type of School [Primary School/PreSchool].
    response_type - What volume to calculate [call_volume/gka]
    """

    def get(self, request):
        survey = self.request.QUERY_PARAMS.get('survey', None)
        source = self.request.QUERY_PARAMS.get('source', None)
        versions = self.request.QUERY_PARAMS.getlist('version', None)
        admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
        admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
        admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
        school_id = self.request.QUERY_PARAMS.get('school_id', None)
        mp_id = self.request.QUERY_PARAMS.get('mp_id', None)
        mla_id = self.request.QUERY_PARAMS.get('mla_id', None)
        start_date = self.request.QUERY_PARAMS.get('from', None)
        end_date = self.request.QUERY_PARAMS.get('to', None)
        school_type = self.request.QUERY_PARAMS.get(
            'school_type', 'Primary School')
        response_type = self.request.QUERY_PARAMS.get(
            'response_type', 'call_volume')

        if 'Primary' in school_type:
            school_type = 'Primary School'

        date = Date()
        if start_date:
            sane = date.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = date.get_datetime(start_date)

        if end_date:
            sane = date.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = date.get_datetime(end_date)

        response_json = {}
        response_json['user_groups'] = {}

        school_type = BoundaryType.objects.get(name=school_type)
        school_qset = School.objects.filter(
            admin3__type=school_type, status=2, id__gte=settings.STATE_STARTING_SCHOOL_ID
        ).order_by().values('id')
       
        stories_qset = Story.objects.select_related(
            'school', 'user'
        ).filter(
            school__in=school_qset
        )
        assessments_qset = AssessmentsV2.objects.filter(
            student_uid__school_code__gte=settings.STATE_STARTING_SCHOOL_ID
        )

        if survey:
            stories_qset = stories_qset.filter(
                group__survey__name=survey)

        if source:
            stories_qset = stories_qset.filter(
                group__source__name=source)

        if versions:
            versions = map(int, versions)
            stories_qset = stories_qset.filter(
                group__version__in=versions)

        if admin1_id:
            stories_qset = stories_qset.filter(
                school__schooldetails__admin1__id=admin1_id)
            boundary = Boundary.objects.get(id=admin1_id)
            assessments_qset = assessments_qset.filter(
                student_uid__district=boundary.name
            )

        if admin2_id:
            stories_qset = stories_qset.filter(
                school__schooldetails__admin2__id=admin2_id)
            boundary = Boundary.objects.get(id=admin2_id)
            assessments_qset = assessments_qset.filter(
                student_uid__block=boundary.name
            )

        if admin3_id:
            stories_qset = stories_qset.filter(
                school__schooldetails__admin3__id=admin3_id)
            boundary = Boundary.objects.get(id=admin3_id)
            assessments_qset = assessments_qset.filter(
                student_uid__cluster=boundary.name
            )

        if school_id:
            stories_qset = stories_qset.filter(
                school=school_id)
            assessments_qset = assessments_qset.filter(
                student_uid__school_code=school_id
            )

        if mp_id:
            stories_qset = stories_qset.filter(
                school__electedrep__mp_const__id=mp_id)

        if mla_id:
            stories_qset = stories_qset.filter(
                school__electedrep__mla_const__id=mla_id)

        if start_date:
            stories_qset = stories_qset.filter(
                date_of_visit__gte=start_date)
            assessments_qset = assessments_qset.filter(
                assessed_ts__gte=start_date,
            )

        if end_date:
            stories_qset = stories_qset.filter(
                date_of_visit__lte=end_date)
            assessments_qset = assessments_qset.filter(
                assessed_ts__lte=end_date,
            )

        if response_type == 'call_volume':
            dates = stories_qset.values_list('date_of_visit', flat=True).order_by()
            groups = Group.objects.all()
            for group in groups:
                response_json['user_groups'][group.name] = stories_qset.filter(
                    user__in=group.user_set.all()
                ).count()
        else:
            dates = assessments_qset.values_list('assessed_ts', flat=True)
            response_json['user_groups'] = {}

        response_json['volumes'] = self.get_call_volume(dates)

        return Response(response_json)

    def get_call_volume(self, dates):
        months = "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split()
        json = {}
        for date in dates:
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
        for year in per_month_json:
            ordered_per_month_json[year] = OrderedDict()
            for month in months:
                ordered_per_month_json[year][month] = per_month_json[year].get(month, 0)

        return ordered_per_month_json


class StoryDetailView(KLPAPIView, CacheMixin):
    """Returns questions and their corresponding answers.

    gka_comparison -- Generates a GKA comparison.
    survey -- Survey which the data belongs to 
              [Ganitha Kalika Andolana/GP Contest]p
    source -- Source of data [web/ivrs].
    version -- Questiongroup versions. eg: ?version=2&version=3
    admin1 -- ID of the District.
    admin2 -- ID of the Block/Project.
    admin3 -- ID of the Cluster/Circle.
    school_id -- ID of the school.
    mp_id -- ID of the MP constituency.
    mla_id -- ID of the MLA constituency.
    from -- YYYY-MM-DD from when the data should be filtered.
    to -- YYYY-MM-DD till when the data should be filtered.
    school_type -- Type of School [Primary School/PreSchool].
    """

    def get(self, request):
        gka_comparison = self.request.QUERY_PARAMS.get('gka_comparison', None)
        survey = self.request.QUERY_PARAMS.get('survey', None)
        source = self.request.QUERY_PARAMS.get('source', None)
        versions = self.request.QUERY_PARAMS.getlist('version', None)
        admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
        admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
        admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
        school_id = self.request.QUERY_PARAMS.get('school_id', None)
        mp_id = self.request.QUERY_PARAMS.get('mp_id', None)
        mla_id = self.request.QUERY_PARAMS.get('mla_id', None)
        start_date = self.request.QUERY_PARAMS.get('from', None)
        end_date = self.request.QUERY_PARAMS.get('to', None)
        school_type = self.request.QUERY_PARAMS.get(
            'school_type', 'Primary School')

        if 'Primary' in school_type:
            school_type = 'Primary School'

        date = Date()
        if start_date:
            sane = date.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = date.get_datetime(start_date)

        if end_date:
            sane = date.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = date.get_datetime(end_date)

        chosen_boundary = None
        chosen_school = None

        school_type = BoundaryType.objects.get(name=school_type)
        school_qset = School.objects.filter(
            admin3__type=school_type, status=2, id__gte=settings.STATE_STARTING_SCHOOL_ID
        ).order_by().values('id')
       
        stories = Story.objects.filter(school__in=school_qset).select_related('school').order_by().all().values('id')

        if survey:
            stories = stories.filter(group__survey__name=survey)
        
        if source:
            stories = stories.filter(group__source__name=source)

        if versions:
            versions = map(int, versions)
            stories = stories.filter(group__version__in=versions)

        if school_type:
            stories = stories.filter(school__admin3__type=school_type)

        if admin1_id:
            stories = stories.filter(
                school__schooldetails__admin1__id=admin1_id
            )
            boundary = Boundary.objects.get(id=admin1_id)
            chosen_boundary = boundary

        if admin2_id:
            stories = stories.filter(
                school__schooldetails__admin2__id=admin2_id
            )
            boundary = Boundary.objects.get(id=admin2_id)
            chosen_boundary = boundary

        if admin3_id:
            stories = stories.filter(
                school__schooldetails__admin3__id=admin3_id
            )
            boundary = Boundary.objects.get(id=admin3_id)
            chosen_boundary = boundary

        if school_id:
            stories = stories.filter(school__id=school_id)
            school = School.objects.get(id=school_id)
            chosen_school = school

        if mp_id:
            stories = stories.filter(
                school__electedrep__mp_const__id=mp_id)

        if mla_id:
            stories = stories.filter(
                school__electedrep__mla_const__id=mla_id)

        if start_date:
            stories = stories.filter(date_of_visit__gte=start_date)

        if end_date:
            stories = stories.filter(date_of_visit__lte=end_date)

        response_json = {}
        
        if gka_comparison:
            gka = GKA(start_date, end_date)
            response_json = gka.generate_report(
                chosen_boundary, chosen_school)
        elif survey == "GP Contest":
            gp_contest = GPContest()
            response_json = gp_contest.generate_report(stories)
        # Sources and filters
        elif source:
            response_json[source] = get_que_and_ans(
                stories, source, school_type, versions)
        else:
            sources = Source.objects.all().values_list('name', flat=True)
            for source in sources:
                response_json[source] = get_que_and_ans(
                    stories, source, school_type, versions)

        return Response(response_json)


def get_que_and_ans(stories, source, school_type, versions):
    response_list = []

    questions = Question.objects.filter(
        is_featured=True).select_related(
            'question_type', 'school_type'
        )

    if source:
        questions = questions.filter(
            questiongroup__source__name=source)

    if versions:
        questions = questions.filter(
            questiongroup__version__in=versions)

    if school_type:
        questions = questions.filter(
            school_type__name=school_type)

    answers = Answer.objects.filter(story__in=stories)
    answer_counts = answers.values('question', 'text').annotate(Count('text'))

    question_dict = {}
    question_ids = questions.values_list('id', flat=True).order_by().distinct('id')
    for entry in answer_counts:
        if entry['question'] in question_ids:
            if entry['question'] in question_dict:
                question_dict[
                    entry['question']
                ]['answers']['options'][entry['text']] = entry['text__count']
            else:
                question = Question.objects.get(id=entry['question'])
                question_dict[question.id] = {}
                question_dict[question.id]['question'] = {}
                question_dict[question.id]['question']['key'] = question.key
                question_dict[question.id]['question']['text'] = question.text
                question_dict[question.id]['question']['display_text'] = question.display_text
                question_dict[question.id]['answers'] = {}
                question_dict[question.id]['answers']['question_type'] = question.question_type.name
                question_dict[question.id]['answers']['options'] = {}
                question_dict[question.id]['answers']['options'][entry['text']] = entry['text__count']
        else:
            continue

    for question in questions.distinct('id'):
        j = {}
        if question.id not in question_dict:
            j['question'] = {}
            j['question']['key'] = question.key
            j['question']['text'] = question.text
            j['question']['display_text'] = question.display_text
            j['answers'] = {}
            j['answers']['question_type'] = question.question_type.name
            j['answers']['options'] = {}
        else:
            j = question_dict[question.id]
        response_list.append(j)

    return response_list


class StoryMetaView(KLPAPIView, CacheMixin):
    """Returns total number of stories and schools with stories
    along with respondent types.
    survey -- Survey which the data belongs to 
              [Ganitha Kalika Andolana/GP Contest]p
    source -- Source of data [web/ivrs].
    version -- Questiongroup versions. eg: ?version=2&version=3
    admin1 -- ID of the District.
    admin2 -- ID of the Block/Project.
    admin3 -- ID of the Cluster/Circle.
    school_id -- ID of the school.
    mp_id -- ID of the MP constituency.
    mla_id -- ID of the MLA constituency.
    from -- YYYY-MM-DD from when the data should be filtered.
    to -- YYYY-MM-DD till when the data should be filtered.
    school_type -- Type of School [Primary School/PreSchool].
    """

    def get(self, request):
        survey = self.request.QUERY_PARAMS.get('survey', None)
        source = self.request.QUERY_PARAMS.get('source', None)
        versions = self.request.QUERY_PARAMS.getlist('version', None)
        admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
        admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
        admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
        school_id = self.request.QUERY_PARAMS.get('school_id', None)
        mp_id = self.request.QUERY_PARAMS.get('mp_id', None)
        mla_id = self.request.QUERY_PARAMS.get('mla_id', None)
        start_date = self.request.QUERY_PARAMS.get('from', None)
        end_date = self.request.QUERY_PARAMS.get('to', None)
        school_type = self.request.QUERY_PARAMS.get(
            'school_type', 'Primary School')
        top_summary = self.request.QUERY_PARAMS.get('top_summary', None)
        date = Date()

        if 'Primary' in school_type:
            school_type = 'Primary School'

        if start_date:
            sane = date.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = date.get_datetime(start_date)

        if end_date:
            sane = date.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = date.get_datetime(end_date)

        school_type = BoundaryType.objects.get(name=school_type)
        school_qset = School.objects.filter(
            admin3__type=school_type, status=2, id__gte=settings.STATE_STARTING_SCHOOL_ID).order_by().values('id')
        stories_qset = Story.objects.select_related('school').filter(
            school__in=school_qset).order_by().values('id')

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

        if mp_id:
            school_qset = school_qset.filter(
                electedrep__mp_const__id=mp_id)
            stories_qset = stories_qset.filter(
                school__electedrep__mp_const__id=mp_id)

        if mla_id:
            school_qset = school_qset.filter(
                electedrep__mla_const__id=mla_id)
            stories_qset = stories_qset.filter(
                school__electedrep__mla_const__id=mla_id)

        if start_date:
            stories_qset = stories_qset.filter(
                date_of_visit__gte=start_date)

        if end_date:
            stories_qset = stories_qset.filter(
                date_of_visit__lte=end_date)

        response_json = {}

        total_schools = school_qset.count()
        
        response_json['total'] = {}
        response_json['total']['schools'] = total_schools
        response_json['total']['stories'] = stories_qset.count()
        response_json['total']['schools_with_stories'] = stories_qset.distinct('school').count()

        if top_summary:
            response_json['top_summary'] = self.get_total_summary(total_schools, school_qset, admin1_id)
            return Response(response_json)

        if survey:
            stories_qset = stories_qset.filter(
                group__survey__name=survey
            )
    
        if source:
            stories_qset = self.source_filter(
                source,
                stories_qset
            )

            unique_schools_counts_per_source = [
                {
                    'group__source__name':source,
                    'school_count':stories_qset.aggregate(
                        Count('school', distinct=True)
                    )['school__count']
                }
            ]

            if versions:
                versions = map(int, versions)
                stories_qset = stories_qset.filter(
                    group__version__in=versions
                )

            response_json[source] = self.get_json(
                source,
                stories_qset,
                unique_schools_counts_per_source,
            )
        else:
            sources = Source.objects.all().values_list('name', flat=True)
            
            unique_schools_counts_per_source = stories_qset.values(
                'group__source__name'
            ).order_by(
            ).annotate(
                school_count=Count(
                    'school',
                    distinct=True
                )
            )

            for source in sources:
                stories = self.source_filter(
                    source,
                    stories_qset
                )
                response_json[source] = self.get_json(
                    source,
                    stories,
                    unique_schools_counts_per_source,
                )

        response_json['respondents'] = self.get_respondents(stories_qset)
        response_json['users'] = self.get_users(stories_qset)

        return Response(response_json)

    def get_total_summary(self, total_schools, school_qset, admin1_id=None, admin2_id=None, admin3_id=None):
        programme = Programme.objects.get(name='Ganitha Kanika Andolana')
        gka_school_q = school_qset.filter(programmes=programme)
        gka_districts = gka_school_q.values_list(
            'admin3__parent__parent',
            flat=True
        ).distinct(
            'admin3__parent__parent'
        )

        admin1 = None
        if admin1_id:
            admin1 = Boundary.objects.get(hierarchy__name='district', id=admin1_id)
        elif admin2_id:
            admin1 = Boundary.objects.get(hierarchy__name='block', id=admin2_id).parent
        elif admin3_id:
            admin1 = Boundary.objects.get(hierarchy__name='cluster', id=admin3_id).parent.parent

        edu_vol_group = Group.objects.get(name="EV")
        edu_volunteers = BoundaryUsers.objects.filter(
            boundary__in=gka_districts,
            user__groups=edu_vol_group
        )
        if admin1:
            edu_volunteers = edu_volunteers.filter(boundary=admin1)

        academic_year = AcademicYear.objects.latest('id')
        num_boys = SchoolExtra.objects.filter(
            academic_year=academic_year,
            school__in=gka_school_q
        ).aggregate(Sum('num_boys'))['num_boys__sum']
        num_girls = SchoolExtra.objects.filter(
            academic_year=academic_year,
            school__in=gka_school_q
        ).aggregate(Sum('num_girls'))['num_girls__sum']
        
        if not num_boys:
            num_boys = 0

        if not num_girls:
            num_girls = 0

        return {
            'total_schools': total_schools,
            'gka_schools': gka_school_q.count(),
            'children_impacted': num_boys + num_girls,
            'education_volunteers': edu_volunteers.count()
        }

    def get_users(self, stories_qset):
        users = {}
        groups = Group.objects.all()
        for group in groups:
            group_users = group.user_set.all()
            users[group.name] = stories_qset.filter(user__in=group_users).count()

        return users
    
    def get_respondents(self, stories_qset):
        respondents = {}

        respondent_type_with_counts = stories_qset.values(
            'user_type__name').order_by().annotate(Count('user_type'))

        for respondent in respondent_type_with_counts:
            if not respondent['user_type__name']:
                continue
            else:
                respondents[
                    UserType.objects.get(
                        name=respondent['user_type__name']
                    ).get_name_display()
                ] = respondent['user_type__count']

        return respondents

    def source_filter(self, source, stories_qset):
        source = Source.objects.get(name=source)
        groups = Questiongroup.objects.filter(source=source)
        stories_qset = stories_qset.filter(
            group__in=groups)

        return stories_qset

    def get_json(self, source, stories_qset, school_counts):
        json = {}

        for i in school_counts:
            if i['group__source__name'] == source:
                school_count = i['school_count']
                break
            else:
                school_count = 0
                continue

        json['stories'] = stories_qset.count()
        json['schools'] = school_count
        if stories_qset:
            json['last_story'] = stories_qset.aggregate(
                Max('date_of_visit'))['date_of_visit__max']
        else:
            json['last_story'] = None
        if source == "web":
            json['verified_stories'] = stories_qset.filter(
                is_verified=True,
            ).count()
        if source == "sms":
            gka_districts_queryset = Story.objects.filter(
                group__source__name="sms"
            ).order_by(
            ).distinct(
                'school__admin3__parent__parent'
            ).values(
                'school__admin3__parent__parent__id',
                'school__admin3__parent__parent__name'
            )
            old_id_key = 'school__admin3__parent__parent__id'
            old_name_key = 'school__admin3__parent__parent__name'

            # json['gka_districts'] = [
            #     {
            #         'id': item[old_id_key],
            #         'name': item[old_name_key]
            #     }
            #     for item in gka_districts_queryset
            # ]

            json['gka_districts'] = [
                {
                    'id':15700,
                    'name':'rayagada'
                },
                {
                    'id':11725,
                    'name':'bolangir'
                }
            ]

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
    """
    bbox_filter_field = "school__instcoord__coord"
    authentication_classes = (authentication.TokenAuthentication,
                              authentication.SessionAuthentication,)

    def get_serializer_class(self):
        is_sync = self.request.GET.get('is_sync', 'no')
        if is_sync == 'yes':
            return StorySyncSerializer

        get_answers = self.request.GET.get('answers', 'no')

        if get_answers == 'yes':
            return StoryWithAnswersSerializer
        elif get_answers == 'no':
            return StorySerializer
        else:
            raise ParseError("answers param must be either 'yes' or 'no'.")

    def get_queryset(self):
        school_type = BoundaryType.objects.get(name='Primary School')
        school_qset = School.objects.filter(
            admin3__type=school_type, status=2, id__gte=settings.STATE_STARTING_SCHOOL_ID
        ).order_by().values('id')
       
        qset = Story.objects.select_related(
            'school', 'user'
        ).filter(
            school__in=school_qset
        )
 
        school_id = self.request.GET.get('school_id', '')
        if school_id:
            qset = qset.filter(school__id=school_id)

        if self.request.GET.get('answers', 'no') == 'yes':
            qset = qset.prefetch_related(
                'answer_set', 'answer_set__question',
                'answer_set__question__question_type',
                'answer_set__question__school_type',
                'answer_set__question__questiongroupquestions_set',
                'answer_set__question__questiongroupquestions_set__questiongroup__source',
            )

        verified = self.request.GET.get('verified', '')
        if verified:
            if verified == 'yes':
                qset = qset.filter(is_verified=True)
            elif verified == 'no':
                qset = qset.filter(is_verified=False)
            else:
                raise ParseError("verified param must be either 'yes' or 'no' if provided.")

        sources = self.request.GET.getlist('source', [])
        if sources:
            qset = qset.filter(group__source__name__in=sources).prefetch_related('group', 'group__source')

        # removing it for now. need better implementation
        # since_id = self.request.GET.get('since_id', 0)
        # if since_id > 0:
        #     qset = qset.filter(id__gt=since_id)

        admin1_id = self.request.GET.get('admin1', '')
        if admin1_id:
            qset = qset.filter(school__schooldetails__admin1__id=admin1_id)

        admin2_id = self.request.GET.get('admin2', '')
        if admin2_id == 'detect':
            # this is a special case when Konnect user is syncing
            # and we need to send the user the stories and answers from
            # the block the user usually operates in and neighboring blocks
            if not self.request.user.is_anonymous():
                qset = qset.prefetch_related(
                    'school', 'school__schooldetails',
                    'school__schooldetails__admin2'
                )
                # Looking for blocks the current user already has stories for
                existing_block_ids = list(set(
                    Story.objects.filter(
                        user=self.request.user
                    ).values_list('school__admin3__parent__id', flat=True)))

                if not existing_block_ids:
                    # special case
                    # if the client demands `admin2=detect`
                    # and there isn't any existing block ids, return empty
                    return Story.objects.none()

                qset = qset.filter(
                    school__schooldetails__admin2__id__in=existing_block_ids
                )
            else:
                # anon can't request detect
                raise APIException('Anonymous user cannot request admin2 detection')
        elif admin2_id:
            qset = qset.filter(school__schooldetails__admin2__id=admin2_id)

        admin3_id = self.request.GET.get('admin3', '')
        if admin3_id:
            qset = qset.filter(school__schooldetails__admin3__id=admin3_id)

        qset = qset.prefetch_related('storyimage_set').select_related('school', 'user_type')
        return qset


class ShareYourStoryView(KLPAPIView):
    def post(self, request, pk=None):
        name = request.POST.get('name', 'Anonymous User')
        email = request.POST.get('email', '')
        comments = request.POST.get('comments', '')
        telephone = request.POST.get('telephone', '')
        date_of_visit = date_parse(request.POST.get('date_of_visit', ''), yearfirst=True)
        question_group = Questiongroup.objects.get(source__name='web', version=2)
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
            group=question_group,
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

            qkey = key.replace("question_", "")
            try:
                question = Question.objects.get(
                    key=qkey,
                    school_type=school.schooldetails.type,
                    is_active=True
                )
                #print question
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
