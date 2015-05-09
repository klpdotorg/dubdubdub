import csv
import json
import datetime

from optparse import make_option

from django.utils import timezone
from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import (
    School, BoundaryType, DiseInfo)
from stories.models import (
    Question, Questiongroup, QuestionType, 
    QuestiongroupQuestions, Source, UserType,
    Story, Answer)

class Command(BaseCommand):
    args = "<path to file>"
    help = """Parse and store the Community Feedback V2 data
    
    ./manage.py fetchcommunityv2 --file=path/to/file"""
    
    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        source = Source.objects.get_or_create(name="community")[0]
        question_group = Questiongroup.objects.get_or_create(version=2, source=source)[0]
        user_types = {
            'Parents': UserType.PARENTS,
            'CBO Member': UserType.CBO_MEMBER,
            'Local Leader ': UserType.VOLUNTEER,
            'SDMC Member ': UserType.SDMC_MEMBER,
            'Educated youth': UserType.EDUCATED_YOUTH,
        }
        UserType.objects.get_or_create(name=UserType.PARENTS)
        UserType.objects.get_or_create(name=UserType.VOLUNTEER)
        UserType.objects.get_or_create(name=UserType.CBO_MEMBER)
        UserType.objects.get_or_create(name=UserType.SDMC_MEMBER)
        UserType.objects.get_or_create(name=UserType.EDUCATED_YOUTH)

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
        
        count = 0
        previous_date = ""

        dise_errors = {}
        dise_errors['no_dise_code'] = []
        dise_errors['no_school_for_dise'] = []

        for row in csv_f:
            # Skip first two rows
            if count == 0 or count == 1:
                count += 1
                continue

            name = row[6]
            dise_code = row[5]
            accepted_answers = {'Y':'Yes', 'N':'No'}
            user_type = self.get_user_type(row[7], user_types)
            previous_date = date_of_visit = self.parse_date(previous_date, row[16])
    
            try:
                dise_info = DiseInfo.objects.get(dise_code=dise_code)
            except Exception as ex:
                dise_errors['no_dise_code'].append(dise_code)
                continue

            try:
                school = School.objects.get(dise_info=dise_info)
            except Exception as ex:
                dise_errors['no_school_for_dise'].append(dise_code)
                continue

            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8]
            answer_columns = [8, 9, 10, 11, 12, 13, 14, 15]

            for answer_column in answer_columns:
                if row[answer_column] in accepted_answers:
                    at_least_one_answer = True
                    break
            else:
                at_least_one_answer = False

            if at_least_one_answer:
                story, created = Story.objects.get_or_create(
                    school=school,
                    name=name,
                    group=question_group,
                    date_of_visit=timezone.make_aware(
                        date_of_visit, timezone.get_current_timezone()
                    ),
                    user_type=user_type,
                )

                for sequence_number, answer_column in zip(question_sequence, answer_columns):
                    if row[answer_column] in accepted_answers:
                        question = Question.objects.get(
                            questiongroup=question_group,
                            questiongroupquestions__sequence=sequence_number,
                        )
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=accepted_answers[row[answer_column]],
                        )
        f.close()
        f = open('dise_error.log', 'w')
        f.write(json.dumps(dise_errors, indent = 4))
        f.close()
            
    def parse_date(self, previous_date,  date):
        if date:
            date_is_sane = self.check_date_sanity(date)
            if date_is_sane:
                date_of_visit = datetime.datetime.strptime(
                    date, '%d/%m/%Y'
                )
                return date_of_visit

        return previous_date

    def get_user_type(self, user_type, user_types):
        if user_type:
            return UserType.objects.get(
                name=user_types[user_type]
            )
        else:
            return None
            
    def check_date_sanity(self, date):
        try:
            day = date.split("/")[0]
            month = date.split("/")[1]
            year = date.split("/")[2]
        except:
            # Date format itself will be messed up
            return False

        if not self.is_day_correct(day):
            return False

        if not self.is_month_correct(month):
            return False

        if not self.is_year_correct(year):
            return False

        return True

    def is_day_correct(self, day):
        return int(day) in range(1,32)

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)
