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
            pass
        else:
            today = timezone.now().date().strftime("%m/%d/%Y")
            source = Source.objects.get(name = "ivrs")
            json_list = self.fetch_data(today)
            for json in json_list:
                self.process_json(source, json)

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

    def fetch_data(self, date):
        url = "http://89.145.83.72/akshara/json_feeds.php?fromdate=%s&enddate=%s" \
              % (date, date)
        response = requests.get(url)
        return response.json()
