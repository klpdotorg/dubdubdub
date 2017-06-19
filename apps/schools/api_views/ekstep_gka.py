from decimal import Decimal

from django.db.models import Count, Max

from rest_framework.exceptions import APIException

from common.utils import Date
from schools.models import AssessmentsV2, Boundary

# NOTE: For all the weird ['akshara.gka.'+str(number) for number in range(67, 88)]
# bits, ask / refer "the" CSV sheets.

class EkStepGKA(object):

    sub_qids = {
        'Subtraction': [
            "do_30085843", "do_30085847", "do_30085879", "do_30086987", "do_30086989",
            "do_30086990", "do_30086991", "do_30086992", "do_30086993", "do_30086994",
            "do_30086995", "do_30086996", "do_30086997", "do_30086998", "do_30086999",
            "do_30087000", "do_30087005", "do_30087006", "do_30087007", "do_30087008",
            "do_30087009", "do_30087010", "do_30087012"
        ],
        'Division': [
            "do_30086574", "do_30086616", "do_30086618", "do_30087104", "do_30087106",
            "do_30087110", "do_30087119", "do_30087121", "do_30087122", "do_30087123",
            "do_30087124", "do_30087127", "do_30087128", "do_30087132", "do_30087135",
            "do_30087139", "do_30087237", "do_30087238", "do_30087239", "do_30087240",
            "do_30087241"
        ],
        'Double digit': [
            "do_30086205", "do_30086209", "do_30086214", "do_30086217", "do_30086221"
        ],
        'Place value': [
            "do_30086661", "do_30086824", "do_30086828", "do_30086842", "do_30086844"
        ],
        'Division fact': [
            "do_30087482", "do_30086887", "do_30086888", "do_30086890", "do_30086893"
        ],
        'Regrouping with money': [
            "do_30086910", "do_30086913", "do_30086916"
        ],
        'Carryover': [
            "do_30087687", "do_30087693", "do_30087697", "do_30087705", "do_30087712"
        ],
        'Addition': [
            "do_30087336", "do_30087334", "do_30087321", "do_30087331", "do_30087357", "do_30087359",
            "do_30087362", "do_30087364", "do_30087366", "do_30087368", "do_30087371", "do_30087373",
            "do_30087375", "do_30087377", "do_30087379", "do_30087381", "do_30087384", "do_30087386",
            "do_30087388", "do_30087391", "do_30087393"
        ],
        'Decimals': ["do_30086249"],
        'Fractions': ["do_30086272"],
        'Word problems': ["do_30087014"],
        'Relationship between 3D shapes': [
            "do_30086288", "do_30086329", "do_30086341", "do_30086346"
        ],
        'Area of shape': [
            "do_30087017", "do_30087029", "do_30087060"
        ]
    }

    def get_summary(self, assessments):
        assessment_aggregates = assessments.aggregate(
            assessment_count=Count('assess_uid'),
            children_count=Count('student_uid', distinct=True),
            last_assessment=Max('assessed_ts')
        )

        return {
            'count':assessment_aggregates['assessment_count'],
            'children':assessment_aggregates['children_count'],
            'last_assmt':assessment_aggregates['last_assessment'],
        }

    def get_score(self, assessments, question_key):
        question_ids = self.sub_qids[question_key]
        assessments = assessments.filter(question_id__in=question_ids)

        if question_key == 'Division':
            correct_score = Decimal('2.0')
        else:
            correct_score = Decimal('1.0')

        total_assessments = assessments.count()
        total_correct_assessments = assessments.filter(
            score=correct_score
        ).count()

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
        scores['Regrouping with money'] = self.get_score(assessments, 'Regrouping with money')
        scores['Carryover'] = self.get_score(assessments, 'Carryover')
        scores['Addition'] = self.get_score(assessments, 'Addition')
        scores['Decimals'] = self.get_score(assessments, 'Decimals')
        scores['Fractions'] = self.get_score(assessments, 'Fractions')
        scores['Word problems'] = self.get_score(assessments, 'Word problems')
        scores['Relationship between 3D shapes'] = self.get_score(assessments, 'Relationship between 3D shapes')
        scores['Area of shape'] = self.get_score(assessments, 'Area of shape')

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

        assessments = AssessmentsV2.objects.values('assess_uid')

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
