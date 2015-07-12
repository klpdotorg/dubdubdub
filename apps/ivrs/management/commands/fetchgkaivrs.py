from django.core.management.base import BaseCommand

class Command(BaseCommand):
    args = ""
    help = """Analyzes the GKA IVRS states and saves stories.

    ./manage.py fetchgkaivrs"""

    @transaction.atomic
    def handle(self, *args, **options):
        return 1
