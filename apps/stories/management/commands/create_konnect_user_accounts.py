import sys
from django.contrib.auth import get_user_model
from django.contrib.auth import authenticate
from django.db import IntegrityError
import csv
from datetime import datetime
from optparse import make_option

from django.db import transaction
from django.core.management.base import BaseCommand

User = get_user_model()


def log(msg):
    with open('logs/fc-create.log', 'a') as fc:
        fc.write(msg + '\n')


class Command(BaseCommand):
    args = "<path to file>"
    help = """Create user accounts for Konnect from CSV

    ./manage.py create_konnect_user_accounts --file=path/to/file"""

    option_list = BaseCommand.option_list + (
        make_option('-f', '--file',
                    help='Path to the csv file'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        with open(file_name, 'rb') as csvfile:
            userreader = csv.DictReader(csvfile)
            for row in userreader:
                email = row['EMAIL']
                password = row['PASSWORD']

                if User.objects.filter(email__iexact=email).count() > 0:
                    # user account exists already. Ignore
                    log("User {} already exists".format(email))
                    continue

                # user account doesn't exist already
                user = User.objects.create(
                    email=email,
                    mobile_no=row['MOBILE'],
                    first_name=row['FIRST NAME'],
                    last_name=row['LAST NAME'],
                    is_email_verified=True
                )
                user.set_password(password)
                user.save()

                log("username: {0}, Password: {1}".format(email, password))

                assert authenticate(username=email, password=password)