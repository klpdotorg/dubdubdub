from datetime import datetime

from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import (
    BoundaryType,
    Partner,
    School
)
from stories.models import (
    Question,
    QuestionType,
    Questiongroup,
    QuestiongroupQuestions,
    Survey,
    Source,
    UserType
)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with GP Contest class 4,5 and 6 questions

    ./manage.py populategpcontestquestions"""

    @transaction.atomic
    def handle(self, *args, **options):
        partner = Partner.objects.get(
            name="Akshara Foundation"
        )
        survey, created = Survey.objects.get_or_create(
            name="GP Contest",
            partner=partner
        )
        source, created = Source.objects.get_or_create(
            name="csv"
        )

        start_date = datetime.strptime('2016-12-01', '%Y-%m-%d')

        question_group, created = Questiongroup.objects.get_or_create(
            version=1,
            source=source,
            survey=survey,
            start_date=start_date,
            status=Questiongroup.ACTIVE_STATUS
        )

        question_type = QuestionType.objects.get(
            name="checkbox"
        )
        school_type = BoundaryType.objects.get(
            name="Primary School"
        )
        user_type, created = UserType.objects.get_or_create(
            name=UserType.AKSHARA_STAFF
        )

        q1 = Question.objects.get_or_create(
            text="Number concept 1",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q2 = Question.objects.get_or_create(
            text="Number concept 2",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q3 = Question.objects.get_or_create(
            text="Number concept 3",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q4 = Question.objects.get_or_create(
            text="Number concept 4",
            data_type=1,
            user_type=user_type,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q5 = Question.objects.get_or_create(
            text="Number concept 5",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q6 = Question.objects.get_or_create(
            text="Addition 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q7 = Question.objects.get_or_create(
            text="Addition 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q8 = Question.objects.get_or_create(
            text="Subtraction 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q9 = Question.objects.get_or_create(
            text="Subtraction 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q10 = Question.objects.get_or_create(
            text="Multiplication 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q11 = Question.objects.get_or_create(
            text="Multiplication 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q12 = Question.objects.get_or_create(
            text="Division 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q13 = Question.objects.get_or_create(
            text="Division 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q14 = Question.objects.get_or_create(
            text="Addition 3",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]        
        q15 = Question.objects.get_or_create(
            text="Subtraction 3",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]        
        q16 = Question.objects.get_or_create(
            text="Division 3",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q17 = Question.objects.get_or_create(
            text="Patterns 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q18 = Question.objects.get_or_create(
            text="Shapes and spatial understanding 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q19 = Question.objects.get_or_create(
            text="Shapes and spatial understanding 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q20 = Question.objects.get_or_create(
            text="Shapes and spatial understanding 3",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]

        questions = [q1, q2, q3, q4, q5, q6, q7,
                     q8, q9, q10, q11, q12, q13,
                     q14, q15, q16, q17, q18, q19, q20]


        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group,
                question=question,
                sequence=count+1
            )

        print "GP Contest class 4 questions populated."


        question_group, created = Questiongroup.objects.get_or_create(
            version=2,
            source=source,
            survey=survey,
            start_date=start_date,
            status=Questiongroup.ACTIVE_STATUS
        )

        q1 = Question.objects.get(text="Number concept 1")
        q2 = Question.objects.get(text="Number concept 2")
        q3 = Question.objects.get(text="Number concept 3")
        q4 = Question.objects.get(text="Number concept 4")
        q5 = Question.objects.get(text="Addition 1")
        q6 = Question.objects.get(text="Addition 2")
        q7 = Question.objects.get(text="Subtraction 1")
        q8 = Question.objects.get(text="Subtraction 2")
        q9 = Question.objects.get(text="Multiplication 1")
        q10 = Question.objects.get(text="Multiplication 2")
        q11 = Question.objects.get(text="Division 1")
        q12 = Question.objects.get(text="Division 2")
        q13 = Question.objects.get(text="Addition 3")
        q14 = Question.objects.get_or_create(
            text="Multiplication 3",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q15 = Question.objects.get(text="Division 3")
        q16 = Question.objects.get(text="Patterns 1") 
        q17 = Question.objects.get_or_create(
            text="Patterns 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q18 = Question.objects.get_or_create(
            text="Fractions 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q19 = Question.objects.get_or_create(
            text="Decimal 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q20 = Question.objects.get(text="Shapes and spatial understanding 1")

        questions = [
            q1, q2, q3, q4, q5, q6, q7,
            q8, q9, q10, q11, q12, q13,
            q14, q15, q16, q17, q18, q19, q20
        ]

        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group,
                question=question,
                sequence=count+1
            )

        print "GP Contest class 5 questions populated."

        question_group, created = Questiongroup.objects.get_or_create(
            version=3,
            source=source,
            survey=survey,
            start_date=start_date,
            status=Questiongroup.ACTIVE_STATUS
        )

        q1 = Question.objects.get(text="Number concept 1")
        q2 = Question.objects.get(text="Number concept 2")
        q3 = Question.objects.get(text="Addition 1")
        q4 = Question.objects.get(text="Addition 2")
        q5 = Question.objects.get(text="Subtraction 1")
        q6 = Question.objects.get(text="Subtraction 2")
        q7 = Question.objects.get(text="Multiplication 1")
        q8 = Question.objects.get(text="Multiplication 2")
        q9 = Question.objects.get(text="Division 1")
        q10 = Question.objects.get(text="Division 2")
        q11 = Question.objects.get(text="Division 3")
        q12 = Question.objects.get_or_create(
            text="Division 4",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q13 = Question.objects.get(text="Decimal 1")
        q14 = Question.objects.get(text="Fractions 1")
        q15 = Question.objects.get_or_create(
            text="Fractions 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q16 = Question.objects.get(text="Shapes and spatial understanding 1")
        q17 = Question.objects.get_or_create(
            text="Measurement: Weight 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q18 = Question.objects.get_or_create(
            text="Measurement: Time 1",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q19 = Question.objects.get_or_create(
            text="Shapes and spatial understanding 2",
            data_type=1,
            question_type=question_type,
            school_type=school_type,
            options="{Yes,No}",
        )[0]
        q20 = Question.objects.get(text="Addition 3")

        for count, question in enumerate(questions):
            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group,
                question=question,
                sequence=count+1
            )

        questions = [
            q1, q2, q3, q4, q5, q6, q7,
            q8, q9, q10, q11, q12, q13,
            q14, q15, q16, q17, q18, q19, q20
        ]

        print "GP Contest class 6 questions populated."

