from datetime import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Populate DB with Anganwadi V2 questions

    ./manage.py populateanganwadiv2"""

    def handle(self, *args, **options):
        s = Source.objects.get_or_create(name="anganwadi")[0]
        start_date = datetime.strptime('2014-08-18', '%Y-%m-%d')
        end_date = datetime.strptime('2015-12-30', '%Y-%m-%d')
        question_group = Questiongroup.objects.get_or_create(
            version=6,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]
        question_type = QuestionType.objects.get(name="checkbox")
        school_type = BoundaryType.objects.get(name="PreSchool")
        user_type= UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        questions = [
            "Number of students enrolled(boys)", 
            "Number of students enrolled(girl)", 
            "Number of students present(boy)", 
            "Number of students present(girl)", 
            "Number of students with special needs(boy)", 
            "Number of students with special needs(girl)", 
            "Where is the center functioning", 
            "The anganwadi center is in a spacious room (35 sq according to ecce rule), meaning there is an indoor enclosure", 
            "There is an outdoor space for 30 children, with space of 30sq", 
            "Anganwadi Centre walls are in good shape", 
            "Anganwadi Centre floor is in good shape", 
            "Anganwadi Centre roof is in good shape", 
            "There is a toilet for children to use", 
            "Children are using toilet", 
            "Centre has water available in the taps", 
            "There is pure drinking water facility", 
            "Food to be distributed on that day was covered properly", 
            "There is seperate facility for washing hands after meals", 
            "There is black board in the center", 
            "Learning materials are present in the centre", 
            "Anganwadi worker is trained", 
            "Activities are conducted using learning material by the anganwadi worker", 
            "Children learning value correction is done for 2013-14", 
            "Progress in children learning is documented", 
            "Bala Vikas Samithi is present", 
            "Bala Vikas Samithi meeting is conducted"
        ]


        for count, question in enumerate(questions):
            q = Question.objects.get_or_create(
                text=question,
                data_type=1,
                user_type=user_type,
                question_type=question_type,
                school_type=school_type,
                options="{'Yes','No'}",
            )[0]

            QuestiongroupQuestions.objects.get_or_create(
                questiongroup=question_group, question=q, sequence=count+1)

        print "Anganwadi v2 questions populated."
