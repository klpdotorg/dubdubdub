from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with V1 GKA SMS questions

    ./manage.py populatev1gkasmsquestions"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name='sms')
        q = Questiongroup.objects.get_or_create(version=1, source=s)[0]
        b = BoundaryType.objects.get(name='Primary School')
        qtype_checkbox = QuestionType.objects.get(name='checkbox')
        qtype_numeric = QuestionType.objects.get(name='numeric')

        q1 = Question.objects.get(
            text="Were the class 4 and 5 math teachers trained in GKA methodology in the school you have visited?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )

        q2 = Question.objects.get_or_create(
            text="Was Math class happening on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q2.text = "Did you observe the math class happening in class 4 or 5 at the time of your visit?"
        q2.save()

        q3 = Question.objects.get_or_create(
            text="Did you see children using the Ganitha Kalika Andolana TLM?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q3.text = "Did you see the Ganitha Kalika Andolana TLM being used in class 4 or 5 at the time of your visit?"
        q3.save()

        q4 = Question.objects.get_or_create(
            text="Did you see representational stage being practiced during the class?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q4.text = "Did you see representational stage being practiced during Math classes in class 4 and 5 at the time of your visit?"
        q4.save()

        q5 = Question.objects.get_or_create(
            text="Was group work happening in the class on the day of your visit?",
            data_type=1,
            question_type=qtype_checkbox,
            options="{'Yes','No'}",
            school_type=b
        )[0]
        q5.text = "Was group work happening during Math classes in class 4 and 5 at the time of your visit?"
        q5.save()
      
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

        print "V1 GKA SMS questions populated"
