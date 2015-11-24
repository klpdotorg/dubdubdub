import os
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

    ./manage.py fetchanganwadi --file=path/to/file --format=[v1/v2/mallur/koppal/bangalore/bangalore-old]"""

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
        make_option('--format',
                    help='Which format to use - v1/v2/mallur/koppal/bangalore/bangalore-old'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        csv_format = options.get('format', None)
        if not csv_format or csv_format not in ['v1', 'v2', 'mallur', 'koppal', 'bangalore', 'bangalore-old']:
            print "Please specify a format with the --format argument [v1/v2/mallur/koppal/bangalore/bangalore-old]"
            return

        source = Source.objects.get_or_create(name="anganwadi")[0]
        user_type = UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]

        if csv_format == 'v1':
            start_date = datetime.datetime.strptime('2014-08-18', '%Y-%m-%d')
            end_date = datetime.datetime.strptime('2015-12-30', '%Y-%m-%d')
            question_group = Questiongroup.objects.get(
                version=1,
                source=source,
                start_date=start_date,
                end_date=end_date,
            )
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
                                 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
                                 31, 32, 33, 34, 35, 36]
            answer_columns = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
                              23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
                              38, 39, 40, 41, 42]

            f = open(file_name, 'r')
            csv_f = csv.reader(f)

        elif csv_format == 'mallur':
            start_date = datetime.datetime.strptime('2013-08-06', '%Y-%m-%d')
            end_date = datetime.datetime.strptime('2014-12-30', '%Y-%m-%d')
            question_group = Questiongroup.objects.get(
                version=4,
                source=source,
                start_date=start_date,
                end_date=end_date,
            )
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
                                 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
                                 62, 63, 64, 65, 66, 67]
            answer_columns = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                             28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
                             49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                             70, 71, 72, 73, 74]

            f = open(file_name, 'r')
            csv_f = csv.reader(f)

        elif csv_format == 'bangalore':
            start_date = datetime.datetime.strptime('2014-01-13', '%Y-%m-%d')
            end_date = datetime.datetime.strptime('2014-05-30', '%Y-%m-%d')
            question_group = Questiongroup.objects.get(
                version=3,
                source=source,
                start_date=start_date,
                end_date=end_date,
            )
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
                                 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
                                 62, 63, 64, 65, 66, 67, 68, 69, 70]
            answer_columns = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                             28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
                             49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                             70, 71, 72, 73, 74, 75, 76, 77]

            f = open(file_name, 'r')
            csv_f = csv.reader(f)

        elif csv_format == 'bangalore-old':
            start_date = datetime.datetime.strptime('2010-01-13', '%Y-%m-%d')
            end_date = datetime.datetime.strptime('2012-05-30', '%Y-%m-%d')
            question_group = Questiongroup.objects.get(
                version=6,
                source=source,
                start_date=start_date,
                end_date=end_date,
            )
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
                                 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
                                 62, 63, 64, 65, 66, 67, 68, 69, 70]
            answer_columns = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                             28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
                             49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
                             70, 71, 72, 73, 74, 75, 76]

            f = open(file_name, 'r')
            csv_f = csv.reader(f, delimiter='|')

        elif csv_format == 'koppal':
            start_date = datetime.datetime.strptime('2013-06-04', '%Y-%m-%d')
            end_date = datetime.datetime.strptime('2014-05-30', '%Y-%m-%d')
            question_group = Questiongroup.objects.get(
                version=5,
                source=source,
                start_date=start_date,
                end_date=end_date,
            )
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
            answer_columns = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]

            f = open(file_name, 'r')
            csv_f = csv.reader(f)

        else: # csv_format == 'v2'
            start_date = datetime.datetime.strptime('2014-08-18', '%Y-%m-%d')
            end_date = datetime.datetime.strptime('2015-12-30', '%Y-%m-%d')
            question_group = Questiongroup.objects.get(
                version=2,
                source=source,
                start_date=start_date,
                end_date=end_date,
            )
            question_sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                 22, 23, 24, 25, 26]
            answer_columns = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                             28, 29, 30, 31, 32]

            f = open(file_name, 'r')
            csv_f = csv.reader(f, delimiter='|')

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
                'NA':'Unknown',
                'dates':['1986', '1990', '1984', '1992', '1982', '1983', '1996',
                         '0', '1985', '2006', '2004', '2005', '2009', '2010']
            }
            if csv_format == 'v1':
                accepted_answers = {
                    '0':'No',
                    '1':'Yes',
                    '2':'Unknown',
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

            print "Story is: " + str(story) + "and it is created: " + str(created)

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
                elif csv_format == 'v2' and sequence_number in range(1, 8):
                    answer = row[answer_column].strip()
                    if answer == 'NA':
                        answer = 'Unknown'

                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer,
                    )
                elif csv_format == 'v2' and sequence_number == 16:
                    # This special case is because column 16 uses
                    # '2' to specify 'Unknown/NA'.
                    answer = row[answer_column].strip()
                    if answer == '2':
                        answer = 'Unknown'
                    else:
                        answer = accepted_answers[answer]

                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer,
                    )
                elif csv_format == 'v1' and sequence_number in [1, 2, 3, 4, 5, 35, 36]:
                    answer = row[answer_column].strip()
                    if answer == 'NA':
                        answer = 'Unknown'

                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer,
                    )
                elif csv_format == 'v1' and sequence_number == 16:
                    # To invert the answers of column 16
                    answer = row[answer_column].strip()
                    if answer == '1':
                        answer = 'No'
                    else:
                        answer = 'Yes'
                    question = Question.objects.get(
                        questiongroup=question_group,
                        questiongroupquestions__sequence=sequence_number,
                    )
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer,
                    )
                else:
                    print "Answer not found: " + str(row[answer_column].strip())
                    print "Question number is: " + str(sequence_number)
                    continue

        f.close()

        log_directory = os.environ.get('DUBDUBDUB_LOG_DIR', None)
        if log_directory:
            file_name = file_name.split('/')[-1]
            file_name = log_directory + file_name + "_error.log"
        else:
            file_name = file_name + "_error.log"

        f = open(file_name, 'w')
        f.write(json.dumps(school_errors, indent = 4))
        f.close()
