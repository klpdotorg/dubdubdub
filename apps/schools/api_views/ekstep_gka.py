import json
import os
from decimal import Decimal

from django.db.models import Count, Max

from rest_framework.exceptions import APIException

from common.utils import Date
from schools.models import AssessmentsV2, Boundary

# NOTE: For all the weird ['akshara.gka.'+str(number) for number in range(67, 88)]
# bits, ask / refer "the" CSV sheets.

class EkStepGKA(object):
    dir = os.path.dirname(__file__)
    filename = os.path.join(dir,'sub_qids.json') #this file has concepts to question ids mapping
    with open(filename) as f:
        sub_qids = json.load(f)

    def get_summary(self, assessments):
        assessment_aggregates = assessments.aggregate(
            assessment_count=Count('assess_uid'),
            schools_covered=Count('student_uid__school_code', distinct=True),
            children_count=Count('student_uid__student_id', distinct=True),
            last_assessment=Max('assessed_ts')
        )

        return {
            'count':assessment_aggregates['assessment_count'],
            'schools':assessment_aggregates['schools_covered'],
            'children':assessment_aggregates['children_count'],
            'last_assmt':assessment_aggregates['last_assessment'],
        }

    def get_score(self, assessments, question_key):
        question_ids = self.sub_qids[question_key]
        if question_key == 'Division':
            correct_score = Decimal('2.0')
        else:
            correct_score = Decimal('1.0')

        assessments = assessments.filter(question_id__in=question_ids)

        total_assessments = assessments.aggregate(
            assessment_count=Count('assess_uid'))['assessment_count']

        total_correct_assessments = assessments.filter(
            score=correct_score
        ).aggregate(
            correct_count=Count('assess_uid')
        )['correct_count']

        return {
            'total':total_assessments,
            'score':total_correct_assessments,
        }

    def get_scores(self, assessments):
        scores = {}
        scores['Subtraction'] = self.get_score(assessments, 'Subtraction')
        scores['Division'] = self.get_score(assessments, 'Division')
        scores['Double digit'] = self.get_score(assessments, 'Double digit')
        scores['Place value'] = self.get_score(assessments, 'Place value')
        scores['Division fact'] = self.get_score(assessments, 'Division fact')
        scores['Money'] = self.get_score(assessments, 'Money')
        scores['Carryover'] = self.get_score(assessments, 'Carryover')
        scores['Addition'] = self.get_score(assessments, 'Addition')
        scores['Decimals'] = self.get_score(assessments, 'Decimals')
        scores['Fractions'] = self.get_score(assessments, 'Fractions')
        scores['Word problems'] = self.get_score(assessments, 'Word problems')
        scores['Shapes'] = self.get_score(assessments, 'Shapes')
        scores['Area'] = self.get_score(assessments, 'Area')
	scores['Number Sense'] = self.get_score(assessments, 'Number Sense')
	scores['Multiplication'] = self.get_score(assessments, 'Multiplication')

        return scores
    
    def generate(self, request):
        response = {}

        admin1_id = request.QUERY_PARAMS.get('admin1', None)
        admin2_id = request.QUERY_PARAMS.get('admin2', None)
        admin3_id = request.QUERY_PARAMS.get('admin3', None)
        school_id = request.QUERY_PARAMS.get('school_id', None)
        start_date = request.QUERY_PARAMS.get('from', None)
        end_date = request.QUERY_PARAMS.get('to', None)

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
        
        assessments = AssessmentsV2.objects.values('assess_uid', 'student_uid__school_code')

        if admin1_id:
            boundary = Boundary.objects.get(id=admin1_id)
            assessments = assessments.filter(
                student_uid__district=boundary.name
            )

        if admin2_id:
            boundary = Boundary.objects.get(id=admin2_id)
            assessments = assessments.filter(
                student_uid__block=boundary.name
            )

        if admin3_id:
            boundary = Boundary.objects.get(id=admin3_id)
            assessments = assessments.filter(
                student_uid__cluster=boundary.name
            )

        if school_id:
            assessments = assessments.filter(
                student_uid__school_code=school_id
            )

        if start_date:
            assessments = assessments.filter(
                assessed_ts__gte=start_date,
            )

        if end_date:
            assessments = assessments.filter(
                assessed_ts__lte=end_date,
            )

        response['summary'] = self.get_summary(assessments)
        response['scores'] = self.get_scores(assessments)

        return response
