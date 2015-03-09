import csv
import datetime

from django.core.management.base import BaseCommand

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup, QuestionType, 
    QuestiongroupQuestions, Source, UserType)

class Command(BaseCommand):
    args = ""
    help = """Parse and store the Community Feedback V1 data
    
    ./manage.py fetchcommunityv1"""

    def handle(self, *args, **options):
        source = Source.objects.get_or_create(name="community")[0]
        question_group = Questiongroup.objects.get_or_create(version=1, source=source)[0]
        UserType.objects.get_or_create(name=UserType.PARENTS)
        UserType.objects.get_or_create(name=UserType.TEACHERS)
        UserType.objects.get_or_create(name=UserType.VOLUNTEER)

        f = open('communityv1.csv')
        csv_f = csv.reader(f)
        
        count = 0
        for row in csv_f:
            # Skip first two rows
            if count == 0 or count == 1:
                count += 1
                continue

            name = row[6]
            school_id = row[10]
            accepted_answers = ['0','1']
            parsed_date = self.parse_date(row[1], row[2], row[3])

            date_of_visit = datetime.datetime.strptime(
                parsed_date, '%d-%m-%Y'
            )

            try:
                school = School.objects.get(id=school_id)
            except:
                print "School with id %s not found" % school_id
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
                            questiongroup__source=source,
                            questiongroupquestions__sequence=sequence_number,
                        )
                        question.school_type = school.admin3.type
                        question.save()
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
                            questiongroup__source=source,
                            questiongroupquestions__sequence=sequence_number,
                        )
                        question.school_type = school.admin3.type
                        question.save()
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
                            questiongroup__source=source,
                            questiongroupquestions__sequence=sequence_number,
                        )
                        question.school_type = school.admin3.type
                        question.save()
                        answer = Answer.objects.get_or_create(
                            story=story,
                            question=question,
                            text=row[answer_column],
                        )

    def parse_date(self, value, month, year):
        day = self.get_day(value)
        return day.strip()+"-"+month+"-"+year

    def get_day(self, value):
        if "/" in value:
            return str(value.split("/")[0])
        elif self.is_day_correct(value):
            return str(value)
        else:
            return "1"

    def is_day_correct(self, day):
        try:
            value = int(day) in range(1,32)
            return value
        except:
            return False
