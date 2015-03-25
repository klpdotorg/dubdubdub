from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import  Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with v2 Community Feedback questions
    
    ./manage.py populatecommunitydatav2"""
    
    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="community")[0]
        q = Questiongroup.objects.get_or_create(version=2, source=s)[0]
        school_type = BoundaryType.objects.get(name="Primary School")
        question_type = QuestionType.objects.get(name="checkbox")

        q1 = Question.objects.get_or_create(
            text="Are the teachers regular?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q2 = Question.objects.get_or_create(
            text="Do teacher take classes regularly?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q3 = Question.objects.get_or_create(
            text="Are the children getting the required academic attenction from the teachers?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q4 = Question.objects.get_or_create(
            text="Is there any concern pertaining to the mid day meal?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q5 = Question.objects.get_or_create(
            text="Are the SDMC members involved in the progress of the school?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q6 = Question.objects.get_or_create(
            text="Does the school have safe drinking water?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q7 = Question.objects.get_or_create(
            text="Does school has functioning toiltes for children?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q8 = Question.objects.get_or_create(
            text="Does the school has sufficient teacher?",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
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

        print "Community feedback data V2 populated."
