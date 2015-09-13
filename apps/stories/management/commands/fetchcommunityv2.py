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
        make_option('--format',
                    help='Which format to use - Hosakote1/Hosakote2/v2/GKA1/GKA2'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        csv_format = options.get('format', None)
        if not csv_format or csv_format not in ['Hosakote1', 'Hosakote2', 'v2', 'GKA1', 'GKA2']:
            print "Please specify a formate with the --format argument [Hosakote1/Hosakote2/v2/GKA1/GKA2]"
            return

        source = Source.objects.get_or_create(name="community")[0]
        question_group = Questiongroup.objects.get_or_create(version=2, source=source)[0]
        user_types = {
            'parents': UserType.PARENTS,
            'cbo member': UserType.CBO_MEMBER,
            'local leader': UserType.LOCAL_LEADER,
            'elcted/local leader': UserType.LOCAL_LEADER,
            'sdmc member': UserType.SDMC_MEMBER,
            'educated youth': UserType.EDUCATED_YOUTH,
        }
        UserType.objects.get_or_create(name=UserType.PARENTS)
        UserType.objects.get_or_create(name=UserType.CBO_MEMBER)
        UserType.objects.get_or_create(name=UserType.SDMC_MEMBER)
        UserType.objects.get_or_create(name=UserType.LOCAL_LEADER)
        UserType.objects.get_or_create(name=UserType.EDUCATED_YOUTH)

        num_to_user_type = {
            '':None,
            '1':'Parents',
            '2':'SDMC Member',
            '3':'Local Leader',
            '4':'CBO Member',
            '5':'Educated youth'
        }

        f = open(file_name, 'r')
        csv_f = csv.reader(f)

        if csv_format in ["Hosakote1", "Hosakote2"]:
            dise_errors = {}
            dise_errors['no_school_code'] = []
            count = -1
        else:
            dise_errors = {}
            dise_errors['no_dise_code'] = []
            dise_errors['no_school_for_dise'] = []
            count = 0

        previous_date = ""

        for row in csv_f:
            # Skip first few rows
            if count in [0, 1, -1]:
                count += 1
                continue

            if csv_format == "v2":
                name = row[6]
                dise_code = row[5]
                accepted_answers = {'Y':'Yes', 'N':'No'}

                if row[7] in ['1', '2', '3', '4', '5']:
                    user_type = self.get_user_type(num_to_user_type[row[7]], user_types)
                else:
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

            elif csv_format in ["Hosakote1", "Hosakote2"]:
                if csv_format == "Hosakote1":
                    name = row[13]
                    school_id = row[9]
                    accepted_answers = {'1':'Yes', '0':'No', '88':'Unknown', '99':'Unknown'}
                    user_type = self.get_user_type(num_to_user_type[row[14]], user_types)
                    previous_date = date_of_visit = self.parse_date(previous_date, row[11])

                    try:
                        school = School.objects.get(id=school_id)
                    except Exception as ex:
                        dise_errors['no_school_code'].append(school_id)
                        continue

                    question_sequence = [1, 2, 3, 4, 5, 6, 7, 8]
                    answer_columns = [15, 16, 17, 18, 19, 20, 21, 22]

                else:
                    users = {
                        'parents': ['parent', 'parents'],
                        'cbo member': ['cbo member', 'cbo membar'],
                        'local leader': ['elected/ local leader', 'elected- local leader',
                                         'elected/local leader', 'elected-local leader',
                                         'elected /local leader', 'elected local leader',
                                         'local leader', 'elected / local leader',
                                         'educated /local leader'],
                        'sdmc member': ['sdmc-1', 'sdmc-2', 'sdmc -2', 'sdmc -1'],
                        'educated youth': ['educated youth'],
                        None:['na']
                    }

                    name = row[10]
                    school_id = row[6]
                    accepted_answers = {'Yes':'Yes', 'No':'No', 'Unaware':'Unknown'}
                    user_type = row[9].strip().lower()

                    for user in users:
                        if user_type in users[user]:
                            user_type = user
                    user_type = self.get_user_type(user_type, user_types)
                    previous_date = date_of_visit = self.parse_date(previous_date, row[8])

                    try:
                        school = School.objects.get(id=school_id)
                    except Exception as ex:
                        dise_errors['no_school_code'].append(school_id)
                        continue

                    question_sequence = [1, 2, 3, 4, 5, 6, 7, 8]
                    answer_columns = [11, 14, 17, 20, 23, 26, 29, 32]

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

                    for sequence_number, answer_column in zip(question_sequence, answer_columns):
                        answer_text = None
                        for i in range(0, 3):
                            if row[answer_column+i].strip() in accepted_answers:
                                answer_text = row[answer_column+i].strip()
                                break
                        if answer_text:
                            question = Question.objects.get(
                                questiongroup=question_group,
                                questiongroupquestions__sequence=sequence_number,
                            )
                            answer = Answer.objects.get_or_create(
                                story=story,
                                question=question,
                                text=accepted_answers[answer_text],
                            )

                    continue

            else:
                name = row[8]
                accepted_answers = {'1':'Yes', '0':'No', '88':'Unknown', '99':'Unknown'}
                user_type = self.get_user_type(num_to_user_type[row[9]], user_types)
                previous_date = date_of_visit = self.parse_date(previous_date, row[18])
                if csv_format == "GKA1":
                    dise_code = row[5]
                else:
                    dise_code = row[7]

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
                answer_columns = [10, 11, 12, 13, 14, 15, 16, 17]


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
        file_name = file_name + "_error.log"
        f = open(file_name, 'w')
        f.write(json.dumps(dise_errors, indent = 4))
        f.close()

    def parse_date(self, previous_date,  date):
        if date:
            if date == "99":
                return previous_date
            date, date_is_sane = self.check_date_sanity(date)
            if date_is_sane:
                date_of_visit = datetime.datetime.strptime(
                    date, '%d/%m/%Y'
                )
                return date_of_visit

        return previous_date

    def get_user_type(self, user_type, user_types):
        if user_type:
            return UserType.objects.get(
                name=user_types[user_type.strip().lower()]
            )
        else:
            return None
            
    def check_date_sanity(self, date):
        if "." in date:
            try:
                day = date.split(".")[0]
                month = date.split(".")[1]
                year = date.split(".")[2]
            except:
                return (date, False)
        elif "//" in date:
            try:
                day = date.split("/")[0]
                month = date.split("/")[2]
                year = date.split("/")[3]
                if len(year) == 2:
                    year = "20"+year
            except:
                # Date format itself will be messed up
                return (date, False)
        else:
            try:
                day = date.split("/")[0]
                month = date.split("/")[1]
                year = date.split("/")[2]
                if len(year) == 2:
                    year = "20"+year
            except:
                # Date format itself will be messed up
                return (date, False)


        if not self.is_day_correct(day):
            return (date, False)

        if not self.is_month_correct(month):
            return (date, False)

        if not self.is_year_correct(year):
            return (date, False)

        date = day+"/"+month+"/"+year
        return (date, True)

    def is_day_correct(self, day):
        return int(day) in range(1,32)

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)
