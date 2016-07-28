from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from collections import defaultdict
import os
from datetime import datetime

from common.utils import Date
from schools.models import (
    School, Boundary)
from stories.models import (
    Question, Questiongroup, QuestionType, 
    QuestiongroupQuestions, Source, UserType,
    Story, Answer)

from rest_framework.exceptions import (
    APIException, PermissionDenied,
    ParseError, MethodNotAllowed,
    AuthenticationFailed
)
from django.db.models import Q, Count



# class StoryMetaView(KLPAPIView, CacheMixin):
#     """Returns total number of stories and schools with stories
#     along with respondent types.

#     source -- Source of data [web/ivrs].
#     version -- Questiongroup versions. eg: ?version=2&version=3
#     admin1 -- ID of the District.
#     admin2 -- ID of the Block/Project.
#     admin3 -- ID of the Cluster/Circle.
#     school_id -- ID of the school.
#     mp_id -- ID of the MP constituency.
#     mla_id -- ID of the MLA constituency.
#     from -- YYYY-MM-DD from when the data should be filtered.
#     to -- YYYY-MM-DD till when the data should be filtered.
#     school_type -- Type of School [Primary School/PreSchool].
#     """

#     def get(self, request):
#         source = self.request.QUERY_PARAMS.get('source', None)
#         versions = self.request.QUERY_PARAMS.getlist('version', None)
#         admin1_id = self.request.QUERY_PARAMS.get('admin1', None)
#         admin2_id = self.request.QUERY_PARAMS.get('admin2', None)
#         admin3_id = self.request.QUERY_PARAMS.get('admin3', None)
#         school_id = self.request.QUERY_PARAMS.get('school_id', None)
#         mp_id = self.request.QUERY_PARAMS.get('mp_id', None)
#         mla_id = self.request.QUERY_PARAMS.get('mla_id', None)
#         start_date = self.request.QUERY_PARAMS.get('from', None)
#         end_date = self.request.QUERY_PARAMS.get('to', None)
#         school_type = self.request.QUERY_PARAMS.get(
#             'school_type', 'Primary School')
#         date = Date()
#         if start_date:
#             sane = date.check_date_sanity(start_date)
#             if not sane:
#                 raise APIException("Please enter `from` in the format YYYY-MM-DD")
#             else:
#                 start_date = date.get_datetime(start_date)

#         if end_date:
#             sane = date.check_date_sanity(end_date)
#             if not sane:
#                 raise APIException("Please enter `to` in the format YYYY-MM-DD")
#             else:
#                 end_date = date.get_datetime(end_date)

#         school_qset = School.objects.filter(
#             admin3__type__name=school_type, status=2)
#         stories_qset = Story.objects.filter(
#             school__admin3__type__name=school_type)

#         if admin1_id:
#             school_qset = school_qset.filter(
#                 schooldetails__admin1__id=admin1_id)
#             stories_qset = stories_qset.filter(
#                 school__schooldetails__admin1__id=admin1_id)

#         if admin2_id:
#             school_qset = school_qset.filter(
#                 schooldetails__admin2__id=admin2_id)
#             stories_qset = stories_qset.filter(
#                 school__schooldetails__admin2__id=admin2_id)

#         if admin3_id:
#             school_qset = school_qset.filter(
#                 schooldetails__admin3__id=admin3_id)
#             stories_qset = stories_qset.filter(
#                 school__schooldetails__admin3__id=admin3_id)

#         if school_id:
#             school_qset = school_qset.filter(id=school_id)
#             stories_qset = stories_qset.filter(
#                 school=school_id)

#         if mp_id:
#             school_qset = school_qset.filter(
#                 electedrep__mp_const__id=mp_id)
#             stories_qset = stories_qset.filter(
#                 school__electedrep__mp_const__id=mp_id)

#         if mla_id:
#             school_qset = school_qset.filter(
#                 electedrep__mla_const__id=mla_id)
#             stories_qset = stories_qset.filter(
#                 school__electedrep__mla_const__id=mla_id)

#         # We need the stories qset with all filters except
#         # the date filter applied on it to calculate the
#         # last story date for each source.
#         last_date_stories_qset = stories_qset

#         if start_date:
#             #school_qset = school_qset.filter(
#             #    story__date_of_visit__gte=start_date)
#             stories_qset = stories_qset.filter(
#                 date_of_visit__gte=start_date)

#         if end_date:
#             # school_qset = school_qset.filter(
#             #     story__date_of_visit__lte=end_date)
#             stories_qset = stories_qset.filter(
#                 date_of_visit__lte=end_date)

#         response_json = {}

#         response_json['total'] = {}
#         response_json['total']['schools'] = school_qset.count()
#         response_json['total']['stories'] = stories_qset.count()
#         response_json['total']['schools_with_stories'] = stories_qset.distinct('school').count()

#         if source:
#             stories_qset = self.source_filter(
#                 source,
#                 stories_qset
#             )

#             last_date_stories_qset = self.source_filter(
#                 source,
#                 last_date_stories_qset,
#             )

#             if versions:
#                 versions = map(int, versions)
#                 stories_qset = stories_qset.filter(
#                     group__version__in=versions
#                 )
#                 last_date_stories_qset = last_date_stories_qset.filter(
#                     group__version__in=versions
#                 )

#             response_json[source] = self.get_json(
#                 source,
#                 stories_qset,
#                 last_date_stories_qset,
#             )
#         else:
#             sources = Source.objects.all().values_list('name', flat=True)
#             for source in sources:
#                 stories = self.source_filter(
#                     source,
#                     stories_qset
#                 )
#                 last_date_stories = self.source_filter(
#                     source,
#                     last_date_stories_qset,
#                 )
#                 response_json[source] = self.get_json(
#                     source,
#                     stories,
#                     last_date_stories,
#                 )

#         response_json['respondents'] = self.get_respondents(stories_qset)

#         return Response(response_json)

#     def get_respondents(self, stories_qset):
#         usertypes = {
#             'PR' : 'PARENTS',
#             'TR' : 'TEACHERS',
#             'VR' : 'VOLUNTEER',
#             'CM' : 'CBO_MEMBER',
#             'HM' : 'HEADMASTER',
#             'SM' : 'SDMC_MEMBER',
#             'LL' : 'LOCAL_LEADER',
#             'AS' : 'AKSHARA_STAFF',
#             'EY' : 'EDUCATED_YOUTH',
#             'EO' : 'EDUCATION_OFFICIAL',
#             'ER' : 'ELECTED_REPRESENTATIVE',
#         }
#         user_counts = UserType.objects.filter(
#             story__in=stories_qset
#         ).annotate(
#             story_count=Count('story')
#         )
#         return {usertypes[user.name]: user.story_count for user in user_counts}

#     def source_filter(self, source, stories_qset):
#         stories_qset = stories_qset.filter(
#             group__source__name=source)

#         return stories_qset

#     def get_json(self, source, stories_qset, last_date_qset):
#         json = {}
#         json['stories'] = stories_qset.count()
#         json['schools'] = stories_qset.distinct('school').count()
#         if last_date_qset:
#             json['last_story'] = last_date_qset.latest('date_of_visit').date_of_visit
#         else:
#             json['last_story'] = None
#         if source == "web":
#             json['verified_stories'] = stories_qset.filter(
#                 is_verified=True,
#             ).count()

#         return json

class Command(BaseCommand):
    help = 'Generates a report on SMS data'
    def get_json(self, source, stories_qset):
        json = {}
        json['stories'] = stories_qset.count()
        json['schools'] = stories_qset.distinct('school').count()
        return json


    def source_filter(self, source, stories_qset):
        stories_qset = stories_qset.filter(
            group__source__name=source)

        return stories_qset
    
    def get_story_meta(self, boundary_id, boundary_type, start_date, end_date):
        source = 'sms'
        admin2_id = None
        admin1_id = None
        if boundary_type == 'block':
            admin2_id = boundary_id
        if boundary_type == 'district':
            admin1_id = boundary_id
        
        school_type = 'Primary School'

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
        
        if start_date:
            stories_qset = stories_qset.filter(
                date_of_visit__gte=start_date)

        if end_date:
            stories_qset = stories_qset.filter(
                date_of_visit__lte=end_date)
        
        if source:
            stories_qset = self.source_filter(
                source,
                stories_qset
            )
        #print stories_qset.count()

        response_json = {}
        response_json['schools'] = school_qset.count()
        response_json['stories'] = stories_qset.count()
        response_json['schools_with_stories'] = stories_qset.distinct('school').count()

        #print response_json
        return response_json
    
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

        #print questions.count()
        for question in questions.distinct('id'):
            j = {}
            j['question'] = {}
            j['question']['key'] = question.key
            j['question']['text'] = question.text
            j['question']['display_text'] = question.display_text
            j['answers'] = {}
            j['answers']['question_type'] = question.question_type.name

            answer_counts = question.answer_set.filter(
                story__in=stories
            ).values('text').annotate(answer_count=Count('text'))

            options = {}
            for count in answer_counts:
                options[count['text']] = count['answer_count']
            j['answers']['options'] = options
            response_list.append(j)

        return response_list


    def get_story_details(self, boundary_id, boundary_type, start_date, end_date):
        source = 'sms'
        admin1_id = None
        admin2_id = None
        school_type = 'Primary School'
        if boundary_type == 'block':
            admin2_id = boundary_id
        if boundary_type == 'district':
            admin1_id = boundary_id

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

        if start_date:
            stories = stories.filter(date_of_visit__gte=start_date)

        if end_date:
            stories = stories.filter(date_of_visit__lte=end_date)
        response_json = {}
        response_json[source] = self.get_que_and_ans(stories, source, school_type)
        return response_json


    def handle(self, *args, **options):
        gka_district_ids = [424, 417, 416, 419, 418, 445]
        gka_district_ids = [ 418]
        
        #bellary, bidar, gulbarga, koppal, raichur, yadgiri
        
        start_date = args[0]
        end_date = args[1]
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
        districts = []
        for district_id in gka_district_ids:
            
            district = Boundary.objects.get(id=district_id)
            admin1_json = { 'name': district.name, 'id': district.id}
            admin1_json['sms'] = self.get_story_meta(district.id,'district',start_date, end_date)
            admin1_json['details'] = self.get_story_details(district.id,'district',start_date, end_date)
            admin1_json['blocks'] = []
            #print admin1_json   
            blocks = (Boundary.objects.all_active().filter(
                parent_id=district_id, 
                type=district.type
            ).select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name'))
            for block in blocks:
                admin2_json = { 'name': block.name, 'id': block.id}
                admin2_json['sms'] = self.get_story_meta(block.id,'block', start_date, end_date)
                admin2_json['details'] = self.get_story_details(block.id,'block', start_date, end_date)    
                admin1_json['blocks'].append(admin2_json)
            districts.append(admin1_json)
        print districts


        # self.check_data_files()

        # count = 0
        # with open(self.file_path, 'r') as statusidfile:
        #     reader = DictReader(statusidfile)
        #     for ems_school in reader:
        #         try:
        #             school = School.objects.get(id=ems_school['id'])

        #             if school.status == int(ems_school['active']):
        #                 continue

        #             log('Found school with different status: ' + str(school.id))
        #             school.status = ems_school['active']
        #             school.save()
        #             count += 1
        #         except Exception, e:
        #             log('Could not find school: ' + str(school.id))

