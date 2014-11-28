import requests

from django.utils import timezone
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    args = "<dates month year>"
    help = """Import data from IVRS

    ./manage.py fetchivrs 12,13,14 12 2014"""

    def handle(self, *args, **options):
        if args:
            pass
        else:
            today = timezone.now().date().strftime("%m/%d/%Y")
            json = self.fetch_data(today)
            print json
        
    def fetch_data(self, date):
        url = "http://89.145.83.72/akshara/json_feeds.php?fromdate=%s&enddate=%s" \
              % (date, date)
        response = requests.get(url)
        return response.json()
