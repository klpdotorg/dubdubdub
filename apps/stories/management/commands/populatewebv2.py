from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import  Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Web v2 questions

    ./manage.py populatewebv2"""

    def handle(self, *args, **options):
        s = Source.objects.get(name="web")
        q = Questiongroup.objects.get_or_create(version=2, source=s)[0]
        b = BoundaryType.objects.get(name='Primary School')
        qtype_radio = QuestionType.objects.get(name='radio')
        existing_question_keys = ["webs-teachers-present",
                                  "webs-number-classrooms",
                                  "webs-50percent-present",
                                  "webs-headmaster-office",
                                  "webs-boundary-wall",
                                  "webs-access-disability",
                                  "webs-playground",
                                  "webs-play-material",
                                  "webs-separate-toilets",
                                  "webs-drinking-water",
                                  "webs-food-being-cooked",
                                  "webs-separate-food-store",
                                  "webs-tlm","webs-library",
                                  "webs-designated-librarian"]
        questions = []
        for key in existing_question_keys:
            try:
                question = Question.objects.get(key=key)
                questions.append(question)
            except:
                print "MISSING QUESTION: " + key

        new_q1 = Question.objects.get_or_create(
            text="Was the school open?",
            data_type=1,
            question_type=qtype_radio,
            options="{'Yes', 'No', 'Unknown'}",
            school_type=b,
            key='webs-school-open'
        )[0]
        questions.append(new_q1)

        new_q2 = Question.objects.get_or_create(
            text="Are all the toilets in the school functional?",
            data_type=1,
            question_type=qtype_radio,
            options="{'Yes', 'No', 'Unknown'}",
            school_type=b,
            key='webs-all-toilets-functional'
        )[0]
        questions.append(new_q2)

        for index, question in enumerate(questions, start=1):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=q, question=question, sequence=index)



