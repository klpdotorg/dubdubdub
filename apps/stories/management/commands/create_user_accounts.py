import csv

from optparse import make_option

from django.contrib.auth.models import Group
from django.db import transaction, DEFAULT_DB_ALIAS
from django.core.management.base import BaseCommand
from django.contrib.admin.util import NestedObjects

from users.models import User
from schools.models import Boundary, BoundaryUsers

# def make_mobile_numbers_unique(users):
#     for user in users:
#         collector = NestedObjects(using=DEFAULT_DB_ALIAS)
#         collector.collect([user])
#         items = collector.nested()
#         for item in items:
#             if isinstance(item, User):
#                 continue
#             else:
#                 unique_instances = set(
#                     [str(instance.__class__.__name__) for instance in item]
#                 )
#                 if len(unique_instances) == 1:
#                     pass
#                     # user.delete()


class Command(BaseCommand):
    args = "<path to file>"
    help = """Create user accounts from CSV

    ./manage.py create_user_accounts --file=path/to/file"""

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
    )

    def get_boundary(self, row):
        district = row[0].strip().lower()
        block = row[1].strip().lower()
        cluster = row[2].strip().lower()

        if district == 'yadgir':
            district = 'yadagiri'

        try:
            cluster = Boundary.objects.get(
                name=cluster,
                hierarchy__name="cluster",
                type__name="Primary School"
            )
        except:
            cluster = None
        try:
            block = Boundary.objects.get(
                name=block,
                hierarchy__name="block",
                type__name="Primary School"
            )
        except:
            block = None
        try:
            district = Boundary.objects.get(
                name=district,
                hierarchy__name="district",
                type__name="Primary School"
            )
        except:
            district = None

        if cluster:
            boundary = cluster
        elif block:
            boundary = block
        elif district:
            boundary = district
        else:
            boundary = None

        return boundary

    def get_first_and_last_name(self, row):
        name = row[4].strip()

        if ' ' in name:
            first_name, last_name = name.split(" ", 1)
        else:
            first_name, last_name = (name, '')
            
        first_name, last_name = first_name[:64], last_name[:64]
        return (name, first_name, last_name)

    def get_email(self, name, row):
        if '@' in row[8].strip():
            email = row[8].strip()
        else:
            # Create an email and keep it to max_length
            email = name.lower().replace(" ","")[:63] + "@klp.org.in"
        return email

    def get_mobile_numbers(self, row):
        mobile_number_1 = row[5].strip()
        mobile_number_2 = row[6].strip()
        mobile_number_3 = row[7].strip()
        
        mobile_number_1 = mobile_number_1[-10:] if (
            (mobile_number_1 != '' and len(mobile_number_1) >= 10)
        ) else None 
        mobile_number_2 = mobile_number_2[-10:] if (
            (mobile_number_2 != '' and len(mobile_number_2) >= 10)
        ) else None 
        mobile_number_3 = mobile_number_3[-10:] if (
            (mobile_number_3 != '' and len(mobile_number_3) >= 10)
        ) else None 

        mobile_numbers = []
        if mobile_number_1:
            mobile_numbers.append(mobile_number_1)
        if mobile_number_2:
            mobile_numbers.append(mobile_number_2)
        if mobile_number_3:
            mobile_numbers.append(mobile_number_3)
        return mobile_numbers

    def create_fake_email(self, email):
        dummy_count = 0
        username = email.split('@')[0]
        while User.objects.filter(email=email).exists():
            dummy_count += 1
            email = "dummy_" + str(dummy_count) + "_" + username + "@klp.org.in"

        return email

    def register_and_classify_user(self, mobile_numbers, email, first_name, last_name, group):
        user = None
        if not mobile_numbers:
            return user

        for mobile_number in mobile_numbers:
            if User.objects.filter(mobile_no__contains=mobile_number).exists():
                user = User.objects.get(mobile_no__contains=mobile_number)
                user.mobile_no=",".join(mobile_numbers)
                user.save()
                break
        else:
            if User.objects.filter(email=email).exists():
                email = self.create_fake_email(email)

            user, created = User.objects.get_or_create(
                email=email,
                first_name=first_name,
                last_name=last_name,
                mobile_no=",".join(mobile_numbers)
            )
            print "User: " + str(user) + " created: " + str(created)
            group.user_set.add(user)

        return user

    def get_group(self, row):
        group_name = row[3].strip()
        try:
            group = Group.objects.get(name=group_name)
        except:
            error = 'Group ' + group_name + ' not found!'
            raise Exception(error)
        return group

    def create_groups(self):
        bfc_group, created = Group.objects.get_or_create(name="BFC")
        crp_group, created = Group.objects.get_or_create(name="CRP")
        brc_group, created = Group.objects.get_or_create(name="BRC")
        brp_group, created = Group.objects.get_or_create(name="BRP")
        ddpi_group, created = Group.objects.get_or_create(name="DDPI")
        diet_group, created = Group.objects.get_or_create(name="DIET")
        eo_group, created = Group.objects.get_or_create(name="EO")
        hm_group, created = Group.objects.get_or_create(name="HM")
        ev_group, created = Group.objects.get_or_create(name="EV")

    def get_csv_file(self, options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return None

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
        return csv_f

    @transaction.atomic
    def handle(self, *args, **options):
        self.create_groups()
        csv_file = self.get_csv_file(options)
        if not csv_file:
            return

        count = 0

        for row in csv_file:
            # Skip the first line
            if count == 0:
                count += 1
                continue
            count += 1

            name, first_name, last_name = self.get_first_and_last_name(row)
            mobile_numbers = self.get_mobile_numbers(row)
            boundary = self.get_boundary(row)
            email = self.get_email(name, row)
            group = self.get_group(row) # Raises exception on error
            user = self.register_and_classify_user(
                mobile_numbers,
                email,
                first_name,
                last_name,
                group
            )
            if not user:
                continue # continue with the next row

            if boundary:
                # Map the user to the given boundary
                BoundaryUsers.objects.get_or_create(
                    user=user, boundary=boundary)

        print str(count) + " lines processed."
