import csv

from optparse import make_option

from django.contrib.auth.models import Group
from django.db import transaction, DEFAULT_DB_ALIAS
from django.core.management.base import BaseCommand
from django.contrib.admin.util import NestedObjects

from users.models import User
from schools.models import Boundary, BoundaryUsers

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

    ./manage.py create_user_accounts --file=path/to/file"""

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        bfc_group, created = Group.objects.get_or_create(name="BFC")
        crp_group, created = Group.objects.get_or_create(name="CRP")
        afs_group, created = Group.objects.get_or_create(name="AFS")
        brc_group, created = Group.objects.get_or_create(name="BRC")
        brp_group, created = Group.objects.get_or_create(name="BRP")
        ddpi_group, created = Group.objects.get_or_create(name="DDPI")
        diet_group, created = Group.objects.get_or_create(name="DIET")
        eo_group, created = Group.objects.get_or_create(name="EO")
        hm_group, created = Group.objects.get_or_create(name="HM")

        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
        count = 0

        for row in csv_f:
            if count == 0:
                count += 1
                continue

            count += 1

            district = row[0].strip().lower()
            block = row[1].strip().lower()
            cluster = row[2].strip().lower()
            group_name = row[3].strip()

            if district == 'yadgir':
                district = 'yadagiri'

            try:
                boundary = Boundary.objects.get(
                    name=cluster,
                    hierarchy__name="district",
                    type__name="Primary School"
                )
            except Exception as ex:
                boundary = None

            name = row[4].strip()
            if ' ' in name:
                first_name, last_name = name.split(" ", 1)
            else:
                first_name, last_name = (name, '')

            first_name, last_name = first_name[:64], last_name[:64]

            if '@' in row[6].strip():
                email = row[6].strip()
            else:
                email = name.lower().replace(" ","")[:63] + "@klp.org.in"

            mobile_number = row[5].strip()

            if mobile_number:
                if len(mobile_number) != 10:
                    continue
                elif User.objects.filter(email=email).exists():
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
                group = Group.objects.get(name=group_name)
                group.user_set.add(user)
            else:
                continue

            if boundary:
                BoundaryUsers.objects.get_or_create(user=user, boundary=boundary)

        print str(count) + " lines processed."
