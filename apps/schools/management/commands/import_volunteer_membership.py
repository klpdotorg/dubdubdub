import csv
from optparse import make_option

from django.core.management.base import BaseCommand
from django.contrib.auth.models import Group
from django.db import transaction

from users.models import User
from schools.models import Boundary, BoundaryUsers


class Command(BaseCommand):
    args = "<path to file>"
    help = """Parse and store volunteer memebership

    ./manage.py import_volunteer_membership --file=path/to/file"""
    
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

        ev_group, created = Group.objects.get_or_create(name="Educational Volunteer")

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
        # Skips first two rows
        next(csv_f)
        next(csv_f)

        for row in csv_f:
            name = row[3].split(' ')
            boundary_name = row[1].lower()
            first_name, last_name = name[0], '' if len(name) == 1 else name[1]
            mobile_no = row[10]
            email = row[11]

            # if email not available.
            if not '@' in email:
                email = first_name + last_name + '@klp.org.in'

            if User.objects.filter(email=email).exists():
                user = User.objects.get(email=email)
            elif User.objects.filter(mobile_no=mobile_no).exists():
                user = User.objects.get(mobile_no=mobile_no)
                user.email = email
                user.save()
            else:
                user, created = User.objects.get_or_create(
                    email=email,
                    first_name=first_name,
                    last_name=last_name,
                    mobile_no=mobile_no
                )
            
            if boundary_name == 'yadgiri':
                boundary_name = 'yadagiri'

            boundary = Boundary.objects.get(name=boundary_name, hierarchy__name='district')
            ev_group.user_set.add(user)
            bu, created = BoundaryUsers.objects.get_or_create(user=user, boundary=boundary)
