from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with V3 GKA IVRS questions

    ./manage.py populatev3gkaivrsquestions"""

    def handle(self, *args, **options):
        s = Source.objects.get(name="ivrs")
        q = Questiongroup.objects.get_or_create(version=5, source=s)[0]
        b = BoundaryType.objects.get(name='Primary School')
        qtype_checkbox = QuestionType.objects.get(name='checkbox')
        qtype_numeric = QuestionType.objects.get(name='numeric')

        q1 = Question.objects.get(
            text="Was the school open?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q2 = Question.objects.get(
            text="Class visited",
            data_type=1,
            question_type=qtype_numeric,
            options="{1, 2, 3, 4, 5, 6, 7, 8}",
            school_type=b
        )
        q3 = Question.objects.get_or_create(
            text="Were the class 4 and 5 math teachers trained in GKA methodology in the school you have visited?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q4 = Question.objects.get(
            text="Was Math class happening on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q5 = Question.objects.get(
            text="Did you see children using the Ganitha Kalika Andolana TLM?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q6 = Question.objects.get(
            text="Which Ganitha Kalika Andolana TLM was being used by teacher?",
            data_type=1,
            question_type=qtype_numeric,
            options="{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21}",
            school_type=b
        )
        q7 = Question.objects.get_or_create(
            text="Did you see representational stage being practiced during the class?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q8 = Question.objects.get(
            text="Was group work happening in the class on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q9 = Question.objects.get(
            text="Does the school have a separate functional toilet for girls?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )

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
                
   
        print "V3 GKA questions populated"
