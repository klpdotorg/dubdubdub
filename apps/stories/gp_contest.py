from django.db.models import Count

from .models import Survey, Questiongroup

class GPContest(object):

    def __init__(self):
        self.class_questiongroup_version_mapping = {
            '4':1,
            '5':2,
            '6':3
        }
        self.survey = Survey.objects.get(name="GP Contest")
        self.questiongroups = self.survey.questiongroup_set.all()        

    def generate_report(self, stories):
        response = {}
        response['summary'] = self.get_meta_summary(stories)
        classes = ['4', '5', '6']
        for class_std in classes:
            response[class_std] = self.get_classwise_summary(class_std, stories)

        return response

    def get_meta_summary(self, stories):
        counts = stories.aggregate(
            school_count=Count('school', distinct=True),
            students_count=Count('name', distinct=True),
            gp_count=Count('school__electedrep__gram_panchayat', distinct=True)
        )

        return {
            'schools':counts['school_count'],
            'students':counts['students_count'],
            'gps':counts['gp_count'],
            'contests':counts['gp_count']
        }

    def get_classwise_summary(self, class_std, stories):
        questiongroup = self.questiongroups.get(
            version=self.class_questiongroup_version_mapping[class_std],
        )
        questions = questiongroup.questions.all(
        ).order_by('questiongroupquestions__sequence')[:20]
        class_stories = stories.filter(answer__text=class_std)
        
        male_stories = class_stories.filter(answer__text="Male")
        female_stories = class_stories.filter(answer__text="Female")

        number_of_males = male_stories.count()
        number_of_females = female_stories.count()

        # Gets the number of rows having 20 "Yes"s - Meaning that they
        # answered every question correctly.
        males_with_perfect_score = male_stories.filter(
            answer__text="Yes"
        ).annotate(yes_count=Count('answer')).filter(yes_count=20).count()

        females_with_perfect_score = female_stories.filter(
            answer__text="Yes"
        ).annotate(yes_count=Count('answer')).filter(yes_count=20).count()

        competencies = {}
        for question in questions:
            list_of_answers = question.answer_set.filter(
                story__in=class_stories
            ).values('text').annotate(answer_count=Count('text'))
            
            competencies[question.text] = {
                answer['text']:answer['answer_count'] for answer in list_of_answers
            }

        return {
            'males':number_of_males,
            'females':number_of_females,
            'males_score':males_with_perfect_score,
            'females_score':females_with_perfect_score,
            'competancies':competencies
        }
