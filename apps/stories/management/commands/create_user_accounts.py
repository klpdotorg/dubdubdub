import csv

from optparse import make_option

from django.db import transaction
from django.core.management.base import BaseCommand

from users.models import User


class Command(BaseCommand):
    args = "<path to file>"
    help = """Create user accounts from CSV

    ./manage.py create_user_accounts --file=path/to/file"""

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        f = open(file_name, 'r')
        csv_f = csv.reader(f)

        mobile_numbers = []
        emails = []
        count = 0

        for row in csv_f:
            if count in [0, 1]:
                count += 1
                continue

            count += 1

            name = row[4].strip()
            if ' ' in name:
                first_name, last_name = name.split(" ", 1)
            else:
                first_name, last_name = (name, '')

            email = name.lower().replace(" ","") + "@klp.org.in"
            mobile_number = row[5].strip()

            if User.objects.filter(email=email).exists():
                user = User.objects.get(email=email)
                if user.mobile_no == mobile_number:
                    continue
                else:
                    email = name.lower().replace(" ","") + str(count) + "@klp.org.in"

            user, created = User.objects.get_or_create(
                email=email,
                first_name=first_name,
                last_name=last_name,
                mobile_no=mobile_number
            )
            print "User: " + str(user) + " created: " + str(created)

        print str(count) + " lines processed."
