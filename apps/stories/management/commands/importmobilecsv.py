import os
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
    Story, Answer)

FIELD_COORDINATORS = {
    "LINGASUGUR": "kumargaded@gmail.com",
    "HAGARIBOMMANAHALLI": "natab146@gmail.com",
    "BHALKI": "sidram@akshara.org.in",
    "CHITTAPUR": "sanjeevkumark321@gmail.com",
    "SHORAPUR": "praneshdv@gmail.com",
    "AURAD": "santhoshkumar.machkure@gmail.com",
    "AFZALPUR": "shankarnagmardi@gmail.com",
    "BELLARY WEST": "gajendravallar@gmail.com",
    "DEVADURGA": "svhonnalli794@gmail.com",
    "HOSAKOTE": "srinivasapy@gmail.com",
    "BELLARY EAST": "gajendravallar@gmail.com",
    "BASAVAKALYAN": "vbpatil2684@gmail.com",
    "KUSTAGI": "umesh@akshara.org.in",
    "SINDHANUR": "adiveshappa@gmail.com",
    "MANVI": "shivu9972488787@gmail.com",
    "MUNDARAGI": "devendrada@akshara.org.in",
    "YELBURGA": "g.s.vandali@gmail.com",
    "HUMNABAD": "sharanuprabhu@gmail.com",
    "HADAGALI": "natab146@gmail.com",
    "GULBARGA NORTH": "shiremath8005.sh@gmail.com",
    "HOSPET": "pandithkhm9009@gmail.com",
    "YADGIR": "venky8715@gmail.com",
    "RAICHUR": "ranganath@akshara.org.in",
    "BIDAR": "mbiradar777@gmail.com",
    "GANGAVATHI": "manjunathmeti40@gmail.com",
    "GULBARGA SOUTH": "jyothi@akshara.org.in",
    "KOPPAL": "g.s.vandali@gmail.com",
    "JEWARGI": "shiremath8005.sh@gmail.com",
    "SIRUGUPPA": "pandithkhm9009@gmail.com",
    "ALAND": "ajbelam@gmail.com",
    "CHINCHOLI": "sudhakarpatil108@gmail.com",
    "KUDLAGI": "mayurappab@gmai.com",
    "SANDUR": "hanumantharaya@akshara.org.in",
    "SHAHAPUR": "ayyannapalled@gmail.com",
    "SEDAM": "shankarnagmardi@gmail.com"
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

        source = Source.objects.get(name="csv")
        question_group, created = Questiongroup.objects.get_or_create(
            version=1, source=source
        )

        parents, created = UserType.objects.get_or_create(name=UserType.PARENTS)

        f = open(file_name, 'r')
        csv_f = csv.reader(f)

        missing_ids = {}
        missing_ids['schools'] = []

        count = 0 # Just to skip the first two rows.

        previous_date = ""

        for row in csv_f:
            # Skip first few rows
            if count in [0, 1]:
                count += 1
                continue

            block = row[2].strip()
            email = FIELD_COORDINATORS.get(block, None)
            school_id = row[4].strip()
            accepted_answers = {'1':'Yes', '0':'No', '99':'Unknown', '88':'Unknown'}
            user_type = parents

            try:
                User = get_user_model()
                field_coordinator = User.objects.get(
                    email=email.strip()
                )
            except Exception as ex:
                if email is None:
                    print "Escaping None entry"
                else:
                    print ex
                    print "Account not found for User: " + str(email)
                field_coordinator = None

            parents_name = row[10].strip()
            day, month, year = row[24].strip(), row[25].strip(), row[26].strip()
            previous_date = date_of_visit = self.parse_date(
                previous_date, day, month, year
            )

            try:
                school = School.objects.get(id=school_id)
            except Exception as ex:
                missing_ids['schools'].append(school_id)
                continue

            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            answer_columns = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22]

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

