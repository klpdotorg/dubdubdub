import os
import sys
import csv
import json
import datetime

from optparse import make_option

from django.utils import timezone
from django.db import transaction
from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand

from schools.models import (
    School, BoundaryType, DiseInfo)
from stories.models import (
    Question, Questiongroup, QuestionType, 
    QuestiongroupQuestions, Source, UserType,
    Story, Answer, Survey)

FIELD_COORDINATORS = {
    "bellary": "gajendravallar@gmail.com",
    "lingasugur": "kumargaded@gmail.com",
    "hagaribommanahalli": "natab146@gmail.com",
    "chincholi": "sudhakarpatil108@gmail.com",
    "hospet": "pandithkhm9009@gmail.com",
    "kudligi": "mayurappab@gmail.com",
    "bidar": "mbiradar777@gmail.com",
    "gulbarga north": "shiremath8005.sh@gmail.com",
    "yadgir": "venky8715@gmail.com",
    "sedam": "shankarnagmardi@gmail.com",
    "gangavathi": "manjunathmeti40@gmail.com",
    "raichur": "ranganath@akshara.org.in",
    "humnabad": "sharanuprabhu@gmail.com",
    "siruguppa": "pandithkhm9009@gmail.com",
    "aland": "ajbelam@gmail.com",
    "kustagi": "umesh@akshara.org.in",
    "sindhanur": "adiveshappa@gmail.com",
    "manvi": "shivu9972488787@gmail.com",
    "bhalki": "sidram@akshara.org.in",
    "mundaragi": "devendrada@akshara.org.in",
    "shorapur": "praneshdv@gmail.com",
    "afzalpur": "shankarnagmardi@gmail.com",
    "devadurga": "svhonnalli794@gmail.com",
    "basavakalyan": "vbpatil2684@gmail.com",
    "koppal": "g.s.vandali@gmail.com",
    "hosakote": "srinivasapy@gmail.com",
    "chittapur": "sanjeevkumark321@gmail.com",
    "hadagali": "natab146@gmail.com",
    "sandur": "hanumantharaya@akshara.org.in",
    "aurad": "santhoshkumar.machkure@gmail.com",
    "shahapur": "ayyannapalled@gmail.com",
    "yelburga": "g.s.vandali@gmail.com",
    "gulbarga south": "jyothi@akshara.org.in",
    "jewargi": "shiremath8005.sh@gmail.com"
}

class Command(BaseCommand):
    args = "<path to file>"
    help = """Parse and store the pen and paper data
    collected for the mobile app.
    
    ./manage.py importmobilecsv --file=path/to/file"""
    
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

        survey = Survey.objects.get(name="Community")
        source = Source.objects.get(name="csv")
        question_group, created = Questiongroup.objects.get_or_create(
            version=1, source=source, survey=survey
        )

        parents, created = UserType.objects.get_or_create(name=UserType.PARENTS)

        f = open(file_name, 'r')
        csv_f = csv.reader(f)

        missing_ids = {}
        missing_ids['schools'] = []

        # To keep track of rows and to skip the first two rows.
        count = 0

        previous_date = ""

        for row in csv_f:
            count += 1
            # Skip first few rows
            if count in [1, 2]:
                continue

            block = row[2].strip().lower()
            email = FIELD_COORDINATORS.get(block, None)
            school_id = row[4].strip()
            accepted_answers = {'1':'Yes', '0':'No', '99':'Unknown', '88':'Unknown'}
            user_type = parents

            try:
                school = School.objects.get(id=school_id)
            except Exception as ex:
                missing_ids['schools'].append(school_id)
                continue

            try:
                User = get_user_model()
                if email:
                    email = email.strip()
                field_coordinator = User.objects.get(
                    email=email
                )
            except Exception as ex:
                print "Block '" + \
                    str(block) + \
                    "' has no matching email (" + \
                    str(email) + \
                    ") account. Check row " + \
                    str(count) + \
                    ". Exiting script."

                sys.exit()

            parents_name = row[10].strip()
            day, month, year = row[22].strip(), row[23].strip(), row[24].strip()
            previous_date = date_of_visit = self.parse_date(
                previous_date, day, month, year
            )

            try:
                school = School.objects.get(id=school_id)
            except Exception as ex:
                missing_ids['schools'].append(school_id)
                continue

            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            answer_columns = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

            for answer_column in answer_columns:
                if row[answer_column] in accepted_answers:
                    at_least_one_answer = True
                    break
            else:
                at_least_one_answer = False

            if at_least_one_answer:
                created = False
                while created==False:
                    story, created = Story.objects.get_or_create(
                        user=field_coordinator,
                        school=school,
                        name=parents_name,
                        is_verified=True,
                        group=question_group,
                        date_of_visit=timezone.make_aware(
                            date_of_visit, timezone.get_current_timezone()
                        ),
                        user_type=user_type,
                    )
                    date_of_visit = date_of_visit + datetime.timedelta(minutes=1)

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
                if not (date_of_visit > datetime.datetime.today()):
                    return date_of_visit

        return previous_date
            
    def check_date_sanity(self, date):

        day = date.split("/")[0]
        month = date.split("/")[1]
        year = date.split("/")[2]

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

