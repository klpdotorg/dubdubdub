import os
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
    help = """Parse and store the Community Feedback V4 data
    
    ./manage.py fetchcommunityv4 --file=path/to/file"""
    
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

        source = Source.objects.get(name="community")
        question_group, created = Questiongroup.objects.get_or_create(
            version=4, source=source
        )

        parents, created = UserType.objects.get_or_create(name=UserType.PARENTS)
        cbo_member, created = UserType.objects.get_or_create(name=UserType.CBO_MEMBER)
        sdmc_member, created = UserType.objects.get_or_create(name=UserType.SDMC_MEMBER)
        elected_rep, created = UserType.objects.get_or_create(name=UserType.ELECTED_REPRESENTATIVE)

        num_to_user_type = {
            '':None,
            '1':parents,
            '2':sdmc_member,
            '3':elected_rep,
            '4':cbo_member,
            '5':cbo_member
        }

        f = open(file_name, 'r')
        csv_f = csv.reader(f)

        missing_ids = {}
        missing_ids['schools'] = []
        count = 0

        previous_date = ""

        for row in csv_f:
            # Skip first few rows
            if count in [0, 1]:
                count += 1
                continue

            name = row[7]
            school_id = row[6].strip()
            accepted_answers = {'1':'Yes', '0':'No', '99':'Unknown', '88':'Unknown'}

            user_type = num_to_user_type[row[8]]
            day, month, year = row[26], row[27], row[28]
            previous_date = date_of_visit = self.parse_date(
                previous_date, day, month, year
            )

            try:
                school = School.objects.get(id=school_id)
            except Exception as ex:
                missing_ids['schools'].append(school_id)
                continue

            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
                                 12, 13, 14, 15, 16, 17]
            answer_columns = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
                              19, 20, 21, 22, 23, 24, 25]

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
                    is_verified=True,
                    group=question_group,
                    date_of_visit=timezone.make_aware(
                        date_of_visit, timezone.get_current_timezone()
                    ),
                    user_type=user_type,
                )

                print "The Story is: " + str(story) + " and has it been created? " + str(created)

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

        log_directory = os.environ.get('DUBDUBDUB_LOG_DIR')
        if log_directory:
            file_name = file_name.split('/')[-1]
            file_name = log_directory + file_name + "_error.log"
        else:
            file_name = file_name + "_error.log"
        f = open(file_name, 'w')
        f.write(json.dumps(missing_ids, indent = 4))
        f.close()

    def parse_date(self, previous_date,  day, month, year):
        date = day + "/" + month + "/" + year
        if date:
            date, date_is_sane = self.check_date_sanity(date)
            if date_is_sane:
                date_of_visit = datetime.datetime.strptime(
                    date, '%d/%m/%Y'
                )
                return date_of_visit

        return previous_date
            
    def check_date_sanity(self, date):
        months = {
            'june': '6',
            'july': '7',
        }

        day = date.split("/")[0]
        month = date.split("/")[1]
        year = date.split("/")[2]

        if month.strip().lower() in months:
            month = months[month.strip().lower()]
            date = day + "/" + month + "/" + year

        if not self.is_day_correct(day):
            return (date, False)

        if not self.is_month_correct(month):
            return (date, False)

        if not self.is_year_correct(year):
            return (date, False)

        return (date, True)

    def is_day_correct(self, day):
        try:
            return int(day) in range(1,32)
        except:
            return False

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)
