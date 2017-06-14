from decimal import Decimal

from django.db.models import Count, Max

from schools.models import AssessmentsV2

# NOTE: For all the weird ['akshara.gka.'+str(number) for number in range(67, 88)]
# bits, ask / refer "the" CSV sheets.

class EkStepGKA(object):
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

    def get_score(self, assessments, question_range):
        question_ids = ['akshara.gka.'+str(number) for number in question_range]
        assessments = assessments.filter(question_id__in=question_ids)

        if set(question_range) == set(range(23, 44)):
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
        scores['Subtraction'] = self.get_score(assessments, range(1, 23))
        scores['Division'] = self.get_score(assessments, range(23, 44))
        scores['Double digit'] = self.get_score(assessments, range(44, 49))
        scores['Place value'] = self.get_score(assessments, range(49, 54))
        scores['Division fact'] = self.get_score(assessments, range(54, 59))
        scores['Regrouping with money'] = self.get_score(assessments, range(59, 62))
        scores['Carryover'] = self.get_score(assessments, range(62, 67))
        scores['Addition'] = self.get_score(assessments, range(67, 88))
        scores['Decimals'] = self.get_score(assessments, range(88, 89))
        scores['Fractions'] = self.get_score(assessments, range(89, 90))
        scores['Word problems'] = self.get_score(assessments, range(90, 91))
        scores['Relationship between 3D shapes'] = self.get_score(assessments, range(91, 95))
        scores['Area of shape'] = self.get_score(assessments, range(95, 99))

        return scores
    
    def generate(self):
        response = {}

        assessments = AssessmentsV2.objects.all().values('assess_uid')

        response['summary'] = self.get_summary(assessments)
        response['scores'] = self.get_scores(assessments)

        return response
