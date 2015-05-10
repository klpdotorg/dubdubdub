from django.db import transaction
from django.core.management.base import BaseCommand

from stories.models import UserType, Story

class Command(BaseCommand):
    args = ""
    help = """Updates user_types for IVRS to Akshara Staff
    and WEB SYS to Volunteers. Deletes Preschool entries for
    the community survey.
    
    ./manage.py user_and_preschool """

    @transaction.atomic
    def handle(self, *args, **options):
        volunteer = UserType.objects.get_or_create(name=UserType.VOLUNTEER)[0]
        akshara_staff = UserType.objects.get_or_create(name=UserType.AKSHARA_STAFF)[0]
        count = Story.objects.filter(
            group__source__name='web'
        ).update(user_type=volunteer)
        print str(count) + " WEB SYS records updated"
        count = Story.objects.filter(
            group__source__name='ivrs'
        ).update(user_type=akshara_staff)
        print str(count) + " IVRS records updated"
        Story.objects.filter(
            school__admin3__type__name='PreSchool', group__source__name="community"
        ).delete()
