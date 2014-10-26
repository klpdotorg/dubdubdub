from django.core.management.base import BaseCommand
from django.core.cache import cache


class Command(BaseCommand):
    help = 'Import data from EMS'

    def handle(self, *args, **options):
        self.stdout.write('This works!')
