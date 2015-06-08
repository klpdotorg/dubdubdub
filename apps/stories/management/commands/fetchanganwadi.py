import csv
import json
import datetime

from optparse import make_option

from django.utils import timezone
from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Source, UserType,
    Story, Answer)

class Command(BaseCommand):
    args = "<path to file>"
    help = """Parse and store the Anganwadi data

    ./manage.py fetchanganwadi --file=path/to/file --format=[v1/mallur/bangalore]"""

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
        make_option('--format',
                    help='Which format to use - v1/mallur/bangalore'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        csv_format = options.get('format', None)
        if not csv_format or csv_format not in ['v1', 'mallur', 'bangalore']:
            print "Please specify a formate with the --format argument [v1/mallur/bangalore]"
            return

        if csv_format == 'v1':
            start_date = datetime.strptime('2013-06-04', '%Y-%m-%d')
            end_date = datetime.strptime('2014-05-30', '%Y-%m-%d')
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
            answer_columns = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]
        elif csv_format == 'mallur':
            start_date = datetime.strptime('2013-08-06', '%Y-%m-%d')
            end_date = datetime.strptime('2014-12-30', '%Y-%m-%d')
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
                                 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
                                 62, 63, 64, 65, 66, 67]
            answer_colums = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                             28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
                             49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                             70, 71, 72, 73, 74]
        else:
            start_date = datetime.strptime('2014-01-13', '%Y-%m-%d')
            end_date = datetime.strptime('2014-05-30', '%Y-%m-%d')
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
                                 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
                                 62, 63, 64, 65, 66, 67, 68, 69, 70]
            answer_colums = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                             28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
                             49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                             70, 71, 72, 73, 74, 75, 76, 77]

        source = Source.objects.get_or_create(name="community")[0]
        question_group = Questiongroup.objects.get_or_create(
            version=3,
            source=s,
            start_date=start_date,
            end_date=end_date,
        )[0]

        user_type = UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        f = open(file_name, 'r')
        csv_f = csv.reader(f)

        school_errors = []

        count = 0
        for row in csv_f:
            # Skip the first row
            if count == 0:
                count += 1
                continue

            name = row[4]
            school_id = row[3]
            accepted_answers = {
                '0':'No',
                '1':'Yes',
                'dates':['1986', '1990', '1984', '1992', '1982', '1983', '1996',
                         '0', '1985', '2006', '2004', '2005', '2009', '2010']
            }
            date_of_visit = start_date

            try:
                school = School.objects.get(id=school_id)
            except:
                school_errors.append(school_id)
                continue

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
                if row[answer_column].strip() in accepted_answers:
                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=accepted_answers[row[answer_column].strip()],
                    )
                elif row[answer_column].strip() in accepted_answers['dates']:
                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=row[answer_column],
                    )
        f.close()
        file_name = "error_"+csv_format+".log"
        f = open(file_name, 'w')
        f.write(json.dumps(school_errors, indent = 4))
        f.close()
