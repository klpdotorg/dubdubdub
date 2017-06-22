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
    Story, Answer, Survey)

class Command(BaseCommand):
    args = "<path to file>"
    help = """Parse and store the GP Contest data
    
    ./manage.py fetchcommunityv4 --file=path/to/file"""
    
    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
        make_option('--class',
                    help='Specify 4, 5 or 6')
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        gp_class = options.get('class', None)
        if not gp_class:
            print "Please specify a class (4/5/6) with the --class argument"
            return

        survey = Survey.objects.get(name="GP Contest")
        source = Source.objects.get(name="csv")

        if gp_class == '4':
            question_group = Questiongroup.objects.get(
                version=1, source=source, survey=survey
            )
        elif gp_class == '5':
            question_group = Questiongroup.objects.get(
                version=2, source=source, survey=survey
            )
        elif gp_class == '6':
            question_group = Questiongroup.objects.get(
                version=3, source=source, survey=survey
            )
        else:
            print "Please specify --class=4/5/6"
            return

        user_type, created = UserType.objects.get_or_create(name=UserType.CHILDREN)
       
        f = open(file_name, 'r')
        csv_f = csv.reader(f, delimiter='|')

        missing_ids = {}
        missing_ids['schools'] = []
        count = 0

        previous_date = ""

        for row in csv_f:
            # Skip first row
            if count == 0:
                count += 1
                continue

            name = row[8]
            gender = row[10].strip().capitalize()
            school_id = row[5].strip()
            accepted_answers = {'1':'Yes', '0':'No'}

            # user_type = num_to_user_type[row[8]]
            day, month, year = row[3].split("/")
            previous_date = date_of_visit = self.parse_date(
                previous_date, day, month, year
            )

            try:
                school = School.objects.get(id=school_id)
            except Exception as ex:
                missing_ids['schools'].append(school_id)
                continue

            # 21 is "class visited". and 22 is "gender".
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
                                 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]

            # We are not considering the 31st column on the CSV. 31
            # corresponds to "class visited". 32 corresponds to "gender".
            answer_columns = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                              21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]

            for answer_column in answer_columns:
                if row[answer_column] in accepted_answers:
                    at_least_one_answer = True
                    break
            else:
                at_least_one_answer = False

            if at_least_one_answer:
                created = False
                while not created:
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
                    date_of_visit = date_of_visit + datetime.timedelta(seconds=60)
                    
                print "The Story is: " + str(story) + " and has it been created? " + str(created)

                for sequence_number, answer_column in zip(question_sequence, answer_columns):
                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    if answer_column == 31:
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=gp_class,
                        )
                    elif answer_column == 32:
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=gender,
                        )
                    elif row[answer_column] in accepted_answers:
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=accepted_answers[row[answer_column]],
                        )
                    else:
                        continue

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
                if not (date_of_visit > datetime.datetime.today()):
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
