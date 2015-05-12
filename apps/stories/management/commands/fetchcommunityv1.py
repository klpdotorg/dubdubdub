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
    help = """Parse and store the Community Feedback V1 data

    ./manage.py fetchcommunityv1 --file=path/to/file"""

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
        question_group = Questiongroup.objects.get_or_create(version=1, source=source)[0]
        UserType.objects.get_or_create(name=UserType.PARENTS)
        UserType.objects.get_or_create(name=UserType.TEACHERS)
        UserType.objects.get_or_create(name=UserType.VOLUNTEER)

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
        
        school_errors = []

        count = 0
        for row in csv_f:
            # Skip first two rows
            if count == 0 or count == 1:
                count += 1
                continue

            name = row[6]
            school_id = row[10]
            accepted_answers = ['0','1']
            date_of_visit = self.parse_date(row[1], row[2], row[3])

            try:
                school = School.objects.get(id=school_id)
            except:
                school_errors.append(school_id)
                continue
                
            # One for the TEACHERS
            teachers_question_sequence = [1, 2, 3, 4, 5, 6, 7, 8]
            teachers_answer_columns = [13, 20, 27, 34, 42, 43, 44, 45]

            for answer_column in teachers_answer_columns:
                if row[answer_column] in accepted_answers:
                    at_least_one_answer = True
                    break
            else:
                at_least_one_answer = False

            if at_least_one_answer:
                story, created = Story.objects.get_or_create(
                    school=school,
                    group=question_group,
                    date_of_visit=timezone.make_aware(
                        date_of_visit, timezone.get_current_timezone()
                    ),
                    user_type=UserType.objects.get(name=UserType.TEACHERS)
                )

                for sequence_number, answer_column in zip(teachers_question_sequence, teachers_answer_columns):
                    if row[answer_column] in accepted_answers:
                        question = Question.objects.get(
                            questiongroup=question_group,
                            questiongroupquestions__sequence=sequence_number,
                        )
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=row[answer_column],
                        )
                
            # One for the PARENTS
            parents_question_sequence = [1, 2, 3, 4, 9, 10, 11, 12]
            parents_answer_columns = [14, 21, 28, 35, 48, 49, 50, 51]

            for answer_column in parents_answer_columns:
                if row[answer_column] in accepted_answers:
                    at_least_one_answer = True
                    break
            else:
                at_least_one_answer = False

            if at_least_one_answer:
                story, created = Story.objects.get_or_create(
                    school=school,
                    group=question_group,
                    date_of_visit=timezone.make_aware(
                        date_of_visit, timezone.get_current_timezone()
                    ),
                    user_type=UserType.objects.get(name=UserType.PARENTS)
                )

                for sequence_number, answer_column in zip(parents_question_sequence, parents_answer_columns):
                    if row[answer_column] in accepted_answers:
                        question = Question.objects.get(
                            questiongroup=question_group,
                            questiongroupquestions__sequence=sequence_number,
                        )
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=row[answer_column],
                        )

            # And one for the VOLUNTEER who lives down the lane
            communitys_question_sequence = [1, 2, 3, 4, 13, 14, 15, 16]
            communitys_answer_columns = [15, 22, 29, 36, 54, 55, 56, 57]

            for answer_column in communitys_answer_columns:
                if row[answer_column] in accepted_answers:
                    at_least_one_answer = True
                    break
            else:
                at_least_one_answer = False

            if at_least_one_answer:
                story, created = Story.objects.get_or_create(
                    school=school,
                    group=question_group,
                    date_of_visit=timezone.make_aware(
                        date_of_visit, timezone.get_current_timezone()
                    ),
                    user_type=UserType.objects.get(name=UserType.VOLUNTEER)
                )

                for sequence_number, answer_column in zip(communitys_question_sequence, communitys_answer_columns):
                    if row[answer_column] in accepted_answers:
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
        f = open('school_errors.log', 'w')
        f.write(json.dumps(school_errors, indent = 4))
        f.close()

    def parse_date(self, value, month, year):
        year = self.get_year(year)
        month = month
        day = self.get_day(value, month, year)

        date = day.strip()+"-"+month+"-"+year
        date_of_visit = datetime.datetime.strptime(
            date, '%d-%m-%Y'
        )
        return date_of_visit

    def get_day(self, value, month, year):
        if "/" in value:
            return str(value.split("/")[0])
        elif self.is_day_correct(value):
            return str(value)
        else:
            # Check to see whether assigning the default day
            # as '1' might make the day a Sunday or not. If it
            # is a Sunday, then use default as '2'.
            date_of_visit = datetime.datetime.strptime(
            "1"+"-"+month+"-"+year, '%d-%m-%Y'
            )
            if date_of_visit.strftime("%A") == "Sunday":
                return "2"
            return "1"

    def is_day_correct(self, day):
        try:
            value = int(day) in range(1,32)
            return value
        except:
            return False

    def get_year(self, value):
        if self.is_year_correct(value):
            return value
        else:
            return "2014"

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)
