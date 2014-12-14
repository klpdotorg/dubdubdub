import requests

from django.utils import timezone
from django.db import transaction
from django.core import serializers
from django.core.management.base import BaseCommand

from schools.models import School
from stories.models import Story, Questiongroup, Source, Question, Answer

class Command(BaseCommand):
    args = "<dates month year>"
    help = """Import data from IVRS

    ./manage.py fetchivrs 12,13,14 12 2014"""

    @transaction.atomic
    def handle(self, *args, **options):
        if args:
            sane, message = self.sanity_check(args)
            if sane:
                print message
                dates = get_dates(args)
            else:
                print message
                return
        else:
            today = timezone.now().date().strftime("%m/%d/%Y")
            source = Source.objects.get(name = "ivrs")
            success, json_list = self.fetch_data(today)
            if success:
                for json in json_list:
                    self.process_json(source, json)
            else:
                return

    def sanity_check(self, args):
        if len(args) < 3:
            return (False, "Usage is $./manage.py fetchivrs [date,date,date month year]")
        else:

            dates = args[0].split(",")
            for date in dates:
                if int(date) not in range(1,32):
                    return (False, "Please enter a valid date in between 1 and 31")

            month = args[1]
            if int(month) not in range(1,13):
                return (False, "Please enter a valid month in between 1 and 12")

            year = args[2]
            if len(year) != 4:
                return (False, "Please enter a valid date of the format 2014")
            elif int(year) > timezone.now().year:
                return (False, "Please enter a valid year. Not the future")

        return (True, "Parameters accepted. Commencing data fetch")


    def process_json(self, source, json):
        date = json['Date & Time']
        school_id = json['School ID']
        telephone = json['Mobile Number']
        school = School.objects.get(id = school_id)
        question_group = Questiongroup.objects.get(source__name = "ivrs")

        story, created = Story.objects.get_or_create(
            school = school,
            group = question_group,
            date = date,
            telephone = telephone,
        )

        if created:
            for i in range(1, 7):
                question = Question.objects.get(
                    school_type = school.admin3.type,
                    questiongroup__source = source,
                    questiongroupquestions__sequence = i
                )
                answer = Answer.objects.get_or_create(
                    story = story,
                    question = question,
                    text = json[str(i)]
                )
        else:
            print "Date %s for school %s already processed" % (date, school)
            return

    def fetch_data(self, date):
        url = "http://89.145.83.72/akshara/json_feeds.php?fromdate=%s&enddate=%s" \
              % (date, date)
        try:
            response = requests.get(url)
            return (True, response.json())
        except Exception as ex:
            print ex, type(ex)
            return (False, None)
