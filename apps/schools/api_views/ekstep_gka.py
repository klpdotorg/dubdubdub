from schools.models import AssessmentsV2

# NOTE: For all the weird ['akshara.gka.'+str(number) for number in range(67, 88)]
# bits, ask / refer the CSV sheets.

class EkStepGKA(object):
    def get_summary(self, assessments):
        number_of_assessments = assessments.distinct('assess_uid').count()
        number_of_children = assessments.distinct('student_uid').count()
        last_assessment_date = assessments.latest('assessed_ts').assessed_ts

        return {
            'count':number_of_assessments,
            'children':number_of_children,
            'last_assmt':last_assessment_date,
        }

    def get_addition_score(self, assessments):
        question_ids = ['akshara.gka.'+str(number) for number in range(67, 88)]
        assessments = assessments.filter(
            question_id__in=question_ids)
        # Calculate and return score.

    def get_scores(self, assessments):
        scores = {}
        scores['Addition'] = self.get_addition_score(assessments)
    
    def generate(self):
        response = {}

        assessments = AssessmentsV2.objects.all()

        response['summary'] = self.get_summary(assessments)
        response['scores'] = self.get_scores(assessments)

        return response
