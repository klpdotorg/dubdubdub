import json
import requests
import datetime

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
                dates = self.get_dates(args)
            else:
                print message
                return
        else:
            dates = [timezone.now().date().strftime("%m/%d/%Y")]

        source = Source.objects.get(name = "ivrs")
        for date in dates:
            success, json_list = self.fetch_data(date)
            if success:
                for json in json_list:
                    sane, message = self.sanity_check_json(json)
                    if sane:
                        self.process_json(source, json)
                    else:
                        print message
                        continue
            else:
                return

    def get_dates(self, args):
        days = args[0].split(",")
        month = args[1]
        year = args[2]
        dates = [month+"/"+day+"/"+year for day in days]
        return dates

    def sanity_check_json(self, json):
        if not json.get('Date & Time', None):
            return (False, "Date & Time not present in the json response.")
        elif not json.get('School ID', None):
            return (False, "School not present in the json response.")
        elif not json.get('Mobile Number', None):
            return (False, "Mobile Number not present in the json response.")
        elif any(str(question_number) not in json for question_number in range(1, 7)):
            return (
                False,
                "Questions missing in json for school ID %s." % json['School ID'])
        else:
            try:
                school = School.objects.get(id=json['School ID'])
            except Exception as ex:
                print ex, type(ex)
                return (False, "School id: %s does not exist in the DB." % json['School ID'])

        return (True, "Json is sane. Proceeding with dissection.")

    def sanity_check(self, args):
        if len(args) < 3:
            return (False, "Usage is $./manage.py fetchivrs [date,date,date month year]")
        else:
            days = args[0].split(",")
            for day in days:
                if int(day) not in range(1,32):
                    return (False, "Please enter a valid day in between 1 and 31")

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

        school = School.objects.get(id=school_id)
        question_group = Questiongroup.objects.get(source__name="ivrs")
        date = datetime.datetime.strptime(
            date, '%Y-%m-%d %H:%M:%S'
        )

        story, created = Story.objects.get_or_create(
            school=school,
            group=question_group,
            date_of_visit=timezone.make_aware(
                date, timezone.get_current_timezone()
            ),
            telephone=telephone,
        )

        if created:
            for i in range(1, 7):
                question = Question.objects.get(
                    school_type=school.admin3.type,
                    questiongroup__source=source,
                    questiongroupquestions__sequence=i
                )
                answer = Answer.objects.get_or_create(
                    story=story,
                    question=question,
                    text=json[str(i)]
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
