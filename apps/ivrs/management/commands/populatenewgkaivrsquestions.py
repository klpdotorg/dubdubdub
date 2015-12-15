from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with New GKA IVRS questions

    ./manage.py populatenewgkaivrsdata"""

    def handle(self, *args, **options):
        s = Source.objects.get(name="ivrs")
        q = Questiongroup.objects.get_or_create(version=4, source=s)[0]
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
            options="{4,5}",
            school_type=b
        )
        q2.options="{1, 2, 3, 4, 5, 6, 7, 8}"
        q2.save()
        q3 = Question.objects.get(
            text="Was Math class happening on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q4 = Question.objects.get(
            text="Did you see children using the Ganitha Kalika Andolana TLM?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q5 = Question.objects.get(
            text="Are all the toilets in the school functional?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q6 = Question.objects.get(
            text="Does the school have a separate functional toilet for girls?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q7 = Question.objects.get(
            text="Does the school have drinking water?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )
        q8 = Question.objects.get(
            text="Is a Mid Day Meal served in the school?",
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
   
        print "New GKA questions populated"
