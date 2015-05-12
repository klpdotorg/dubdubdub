import json
import requests
import datetime

from optparse import make_option

from django.utils import timezone
from django.db import transaction
from django.core import serializers
from django.core.management.base import BaseCommand

from schools.models import School
from stories.models import Story, Questiongroup, Source, Question, Answer

class Command(BaseCommand):
    args = "<dates month year>"
    help = """Import data from IVRS

    ./manage.py fetchivrs --from=20/12/2014 --to=21/12/2014"""

    option_list = BaseCommand.option_list + (
        make_option('--from',
                    help='The date from which to start fetching ivrs data.'),
        make_option('--to',
                    help='The date until which to fetch ivrs data '),
    )

    try:
        f = open('ivrs_error.log')
        ivrs_errors = json.loads(f.read())
        f.close()
    except:
        ivrs_errors = []

    @transaction.atomic
    def handle(self, *args, **options):
        from_date = options.get('from', None)
        to_date = options.get('to', None)

        if from_date or to_date:
            if from_date and to_date:
                sane, message = self.sanity_check(from_date, to_date)
                if sane:
                    print message
                    from_date = self.transform_date(from_date)
                    to_date = self.transform_date(to_date)
                else:
                    print message
                    return
            else:
                print "Please specify either both --from and --to dates or neither"
                return
        else:
            from_date = to_date = timezone.now().date().strftime("%m/%d/%Y")

        source = Source.objects.get(name="ivrs")
        success, json_list = self.fetch_data(from_date, to_date)
        if success:
            for the_json in json_list:
                sane, message = self.sanity_check_json(the_json)
                if sane:
                    self.process_json(source, the_json)
                else:
                    print message
                    continue
            else:
                print "All jsons processed!"
        else:
            return

        f = open('ivrs_error.log', 'w')
        f.write(json.dumps(self.ivrs_errors, indent = 4))
        f.close()


    def transform_date(self, date):
        day = date.split("/")[0]
        month = date.split("/")[1]
        year = date.split("/")[2]
        date = month+"/"+day+"/"+year
        return date

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
                if json['School ID'] not in self.ivrs_errors:
                    self.ivrs_errors.append(json['School ID'])
                return (False, "School id: %s does not exist in the DB." % json['School ID'])

        return (True, "Json is sane. Proceeding with dissection.")

    def sanity_check(self, from_date, to_date):
        sane, message = self.check_date(from_date)
        if not sane:
            return (sane, message)
        sane, message = self.check_date(to_date)
        if not sane:
            return (sane, message)
        return (sane, message)
        
    def check_date(self, date):
        day = date.split("/")[0]
        month = date.split("/")[1]
        year = date.split("/")[2]

        if not self.is_day_correct(day):
            return (False, "Please enter a valid day in between 1 and 31")

        if not self.is_month_correct(month):
            return (False, "Please enter a valid month in between 1 and 12")

        if not self.is_year_correct(year):
            return (False, "Please ensure year format is '2014' and it is <= current year")

        return (True, "Parameters accepted. Commencing data fetch")

    def is_day_correct(self, day):
        return int(day) in range(1,32)

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)

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

    def fetch_data(self, from_date, to_date):
        url = "http://klpdata.mahiti.org/json_feeds.php?fromdate=%s&enddate=%s" \
              % (from_date, to_date)
        try:
            response = requests.get(url)
            return (True, response.json())
        except Exception as ex:
            print ex, type(ex)
            return (False, None)
