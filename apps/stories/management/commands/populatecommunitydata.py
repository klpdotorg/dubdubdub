from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType, 
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Community Feedback questions
    
    ./manage.py populateivrsdata"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="community")[0]
        q = Questiongroup.objects.get_or_create(version=1, source=s)[0]
        question_type = QuestionType.objects.get(name="checkbox")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        q1 = Question.objects.get_or_create(
            text="Are the Parents involved in the progess of the school?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q2 = Question.objects.get_or_create(
            text="Are the SDMC Members involved in the progress of the school?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q3 = Question.objects.get_or_create(
            text="Are the Community members involved in the progress of the school?",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q4 = Question.objects.get_or_create(
            text="Are the teachers involved in the progress of the school? ",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q5 = Question.objects.get_or_create(
            text="Is the TLM in the school sufficient?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q6 = Question.objects.get_or_create(
            text="Is the teacher overloaded with work?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q7 = Question.objects.get_or_create(
            text="Do the teachers need re-training/extra classes?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q8 = Question.objects.get_or_create(
            text="Is there a healthy relationship/understanding between the teacher and the school board(HM)?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q9 = Question.objects.get_or_create(
            text="Is the school board (HM) running the school efficiently?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q10 = Question.objects.get_or_create(
            text="Are the teachers consistent in their presence in school and do they take classes regularly?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q11 = Question.objects.get_or_create(
            text="Are the children getting the required academic attention in school by the teacher?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q12 = Question.objects.get_or_create(
            text="Is there any concern pertaining to the food served to the children in school?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q13 = Question.objects.get_or_create(
            text="Are the teachers in the school qualified/trained/motivated to teach?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]
        q14 = Question.objects.get_or_create(
            text="Is the student to teacher ratio high?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]        
        q15 = Question.objects.get_or_create(
            text="Is the government actively involved in the school's development?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]        
        q16 = Question.objects.get_or_create(
            text="Does the school have good infrastructure and is the location of the school safe for children?",
            data_type=1,
            question_type=question_type,
            options="{Yes,No}",
        )[0]        

        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q1, sequence=1)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q2, sequence=2)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q3, sequence=3)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q4, sequence=4)     
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q5, sequence=5)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q6, sequence=6)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q7, sequence=7)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q8, sequence=8)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q9, sequence=9)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q10, sequence=10)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q11, sequence=11)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q12, sequence=12)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q13, sequence=13)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q14, sequence=14)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q15, sequence=15)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q16, sequence=16)
      
        print "Community feedback data populated."
