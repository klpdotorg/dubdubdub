from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import  Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with GKA IVRS questions

    ./manage.py populategkaivrsdata"""

    def handle(self, *args, **options):
        s = Source.objects.get(name="ivrs")
        q = Questiongroup.objects.get_or_create(version=2, source=s)[0]
        b = BoundaryType.objects.get(name='Primary School')
        qtype_checkbox = QuestionType.objects.get(name='checkbox')
        qtype_numeric = QuestionType.objects.get(name='numeric')

        q1 = Question.objects.get_or_create(
            text="Was the school open?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{Yes,No}",
            school_type=b
        )[0]
        q2 = Question.objects.get_or_create(
            text="Class visited",
            data_type=1,
            question_type=qtype_numeric,
            school_type=b
        )[0]
        q3 = Question.objects.get_or_create(
            text="Was Math class happening on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{Yes,No}",
            school_type=b
        )[0]
        q4 = Question.objects.get_or_create(
            text="Which chapter of the textbook was taught?",
            data_type=1,
            question_type=qtype_numeric,
            school_type=b
        )[0]
        q5 = Question.objects.get_or_create(
            text="Which Ganitha Kalika Andolana TLM was being used by teacher?",
            data_type=1,
            question_type=qtype_numeric,
            school_type=b
        )[0]
        q6 = Question.objects.get_or_create(
            text="Did you see children using the Ganitha Kalika Andolana TLM?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
        )[0]
        q7 = Question.objects.get_or_create(
            text="Was group work happening in the class on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
        )[0]
        q8 = Question.objects.get_or_create(
            text="Were children using square line book during math class?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
        )[0]
        q9 = Question.objects.get_or_create(
            text="Are all the toilets in the school functional?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
        )[0]
        q10 = Question.objects.get_or_create(
            text="Does the school have a separate functional toilet for girls?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
        )[0]
        q11 = Question.objects.get_or_create(
            text="Does the school have drinking water?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
        )[0]
        q12 = Question.objects.get_or_create(
            text="Is a Mid Day Meal served in the school?",
            data_type=1,
            question_type=qtype_checkbox,
            school_type=b
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

        print "GKA questions populated"
