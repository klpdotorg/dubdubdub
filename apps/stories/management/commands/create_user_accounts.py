import csv

from optparse import make_option

from django.contrib.auth.models import Group
from django.db import transaction, DEFAULT_DB_ALIAS
from django.core.management.base import BaseCommand
from django.contrib.admin.util import NestedObjects

from users.models import User

def make_mobile_numbers_unique(users):
    for user in users:
        collector = NestedObjects(using=DEFAULT_DB_ALIAS)
        collector.collect([user])
        items = collector.nested()
        for item in items:
            if isinstance(item, User):
                continue
            else:
                unique_instances = set(
                    [str(instance.__class__.__name__) for instance in item]
                )
                if len(unique_instances) == 1:
                    pass
                    # user.delete()


class Command(BaseCommand):
    args = "<path to file>"
    help = """Create user accounts from CSV

    ./manage.py create_user_accounts --file=path/to/file --csv_type=[BFC/CRP]"""

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
        make_option('--csv_type',
                    help='To specify whether it is a BFC or CRP csv'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        bfc_group, created = Group.objects.get_or_create(name="BFC")
        crp_group, created = Group.objects.get_or_create(name="CRP")

        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        csv_type = options.get('csv_type', None)
        if csv_type not in ['BFC', 'CRP']:
            print "Please specify --csv_type as BFC or CRP"
            return

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
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

            if '@' in row[6].strip():
                email = row[6].strip()
            else:
                email = name.lower().replace(" ","") + "@klp.org.in"

            mobile_number = row[5].strip()

            if mobile_number:
                if User.objects.filter(email=email).exists():
                    user = User.objects.get(email=email)
                elif User.objects.filter(mobile_no=mobile_number).exists():
                    user = User.objects.get(mobile_no=mobile_number)
                    user.email = email
                    user.save()
                else:
                    user, created = User.objects.get_or_create(
                        email=email,
                        first_name=first_name,
                        last_name=last_name,
                        mobile_no=mobile_number
                    )
                    print "User: " + str(user) + " created: " + str(created)
                if csv_type == 'BFC':
                    bfc_group.user_set.add(user)
                elif csv_type == 'CRP':
                    crp_group.user_set.add(user)
                else:
                    raise Exception
            else:
                continue

        print str(count) + " lines processed."
