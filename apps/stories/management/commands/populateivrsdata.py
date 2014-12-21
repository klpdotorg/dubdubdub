from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import  Question, Questiongroup, QuestionType, QuestiongroupQuestions, Source

class Command(BaseCommand):
    args = ""
    help = """Populate DB with IVRS questions
    
    ./manage.py populateivrsdata"""

    def handle(self, *args, **options):
        s = Source.objects.get(name = "ivrs")
        q = Questiongroup.objects.get_or_create(version = 1, source = s)[0]
        b = BoundaryType.objects.all()
        QuestionType.objects.get_or_create(name = "numeric")
        qtypes = QuestionType.objects.all()
    
        q21 = Question.objects.get_or_create(
            text="Was the center open?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[1])[0]
        q22 = Question.objects.get_or_create(
            text="Was anganwadi worker present in the center?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[1])[0]
        q23 = Question.objects.get_or_create(
            text="Was the worker conducting activities for the children?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[1])[0]
        q24 = Question.objects.get_or_create(
            text="Was the teaching and learning materials placed at eye level for the children?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[1])[0]
        q25 = Question.objects.get_or_create(
            text="Approximately how many children were there?",
            data_type=1,
            question_type=qtypes[2],
            school_type=b[1])[0]
        q26 = Question.objects.get_or_create(
            text="Is this a A, B or C grade anganwadi based on your observations?",
            data_type=1,
            question_type=qtypes[2],
            school_type=b[1])[0]

        q11 = Question.objects.get_or_create(
            text="Was the school open?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[0])[0]
        q12 = Question.objects.get_or_create(
            text="Was the headmaster present?",
            data_type=1, question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[0])[0]
        q13 = Question.objects.get_or_create(
            text="Were all the teachers present?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[0])[0]
        q14 = Question.objects.get_or_create(
            text="Were the toilets for children in good condition?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[0])[0]
        q15 = Question.objects.get_or_create(
            text="Were classes being conducted properly?",
            data_type=1,
            question_type=qtypes[1],
            options="{Yes,No}",
            school_type=b[0])[0]
        q16 = Question.objects.get_or_create(
            text="Is this a A, B or C grade school based on your observations?",
            data_type=1,
            question_type=qtypes[2],
            school_type=b[0])[0]

        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q21, sequence=1)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q22, sequence=2)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q23, sequence=3)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q24, sequence=4)     
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q25, sequence=5)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q26, sequence=6)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q11, sequence=1)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q12, sequence=2)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q13, sequence=3)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q14, sequence=4)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q15, sequence=5)
        QuestiongroupQuestions.objects.get_or_create(
            questiongroup=q, question=q16, sequence=6)
     
        print "IVRS data populated."
