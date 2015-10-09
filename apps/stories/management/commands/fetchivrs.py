import json
import requests
import datetime

from optparse import make_option

from django.utils import timezone
from django.db import transaction
from django.core import serializers
from django.core.management.base import BaseCommand

from schools.models import School
from common.utils import post_to_slack
from stories.models import Story, Questiongroup, Source, Question, Answer

class Command(BaseCommand):
    args = "<dates month year>"
    help = """Import data from IVRS

    ./manage.py fetchivrs --from=31/08/2014 --to=05/12/2014"""

    option_list = BaseCommand.option_list + (
        make_option('--from',
                    help='The date from which to start fetching ivrs data.'),
        make_option('--to',
                    help='The date until which to fetch ivrs data '),
    )

    ivrs_errors = []

    @transaction.atomic
    def handle(self, *args, **options):
        count = 0 # To post daily updates to slack.
        from_date = options.get('from', None)
        to_date = options.get('to', None)

        error_file = '/var/www/dubdubdub/log/error_' + \
                     timezone.now().date().strftime("%m%d%Y") + '.log'

        try:
            f = open(error_file)
            self.ivrs_errors = json.loads(f.read())
            f.close()
        except:
            self.ivrs_errors = []

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
                    created = self.process_json(source, the_json)
                    if created:
                        count += 1
                else:
                    print message
                    continue
            else:
                print "All jsons processed!"
        else:
            return

        f = open(error_file, 'w')
        f.write(json.dumps(self.ivrs_errors, indent = 4))
        f.close()

        post_to_slack(
            channel='#klp',
            author='Mahiti IVRS',
            Message='%s calls processed' % count,
            emoji=':phone:'
        )

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
            return (False, "Please enter a valid day in between 1 and 31 in the format DD")

        if not self.is_month_correct(month):
            return (False, "Please enter a valid month in between 1 and 12 in the format MM")

        if not self.is_year_correct(year):
            return (False, "Please ensure year format is '2014' and it is <= current year")

        return (True, "Parameters accepted. Commencing data fetch")

    def is_day_correct(self, day):
        return (len(day) == 2 and int(day) in range(1,32))

    def is_month_correct(self, month):
        return (len(month) == 2 and int(month) in range(1,13))

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)

    def process_json(self, source, json):
        date = json['Date & Time']
        school_id = json['School ID']
        telephone = json['Mobile Number']

        school = School.objects.get(id=school_id)
        question_group = Questiongroup.objects.get(version=1, source__name="ivrs")
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
                    questiongroup=question_group,
                    questiongroupquestions__sequence=i
                )
                answer = Answer.objects.get_or_create(
                    story=story,
                    question=question,
                    text=json[str(i)]
                )
        else:
            print "Date %s for school %s already processed" % (date, school)

        return created

    def fetch_data(self, from_date, to_date):
        url = "http://klpdata.mahiti.org/json_feeds.php?fromdate=%s&enddate=%s" \
              % (from_date, to_date)
        try:
            response = requests.get(url)
            return (True, response.json())
        except Exception as ex:
            print ex, type(ex)
            return (False, None)
