from django.db import transaction
from django.core.management.base import BaseCommand

from stories.models import Questiongroup, Story

class Command(BaseCommand):
    args = ""
    help = """Populate the start_date and end_date for all the Questiongroups.

    ./manage.py updatequestiongroup
    """

    @transaction.atomic
    def handle(self, *args, **options):
        q_groups = Questiongroup.objects.all()
        for q in q_groups:
            q.start_date = Story.objects.filter(
                group=q
            ).values(
                'date_of_visit'
            ).earliest(
                'date_of_visit'
            )['date_of_visit']

            q.end_date = Story.objects.filter(
                group=q
            ).values(
                'date_of_visit'
            ).latest(
                'date_of_visit'
            )['date_of_visit']

            q.save()
