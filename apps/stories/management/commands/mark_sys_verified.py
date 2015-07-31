from django.core.management.base import BaseCommand
from stories.models import Story


class Command(BaseCommand):
    args = ""
    help = """Mark all non-web SYS stories as verified
    
    ./manage.py mark_sys_verified"""

    def handle(self, *args, **options):
        stories_qset = Story.objects.exclude(group__source__name='web')
        updated = stories_qset.update(is_verified=True)
        print "%d Stories Updated" % updated
