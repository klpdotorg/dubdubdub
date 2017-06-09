from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from collections import defaultdict
import os
from csv import DictReader
from datetime import datetime
from schools.models import School, Address, Child


def log(msg):
    print msg
    with open('imports/import.log', 'a') as f:
        f.writelines([
            '\n',
            '[' + datetime.now().isoformat() + '] ' + msg
        ])


def dictfetchall(cursor):
    "Returns all rows from a cursor as a dict"
    desc = cursor.description
    d = {}
    for row in cursor.fetchall():
        d[row[0]] = dict(zip([col[0] for col in desc], row))
    return d


class Command(BaseCommand):
    help = 'Imports school statuses exported from EMS'
    EMS_DATA_IMPORT_DIR = os.path.join(settings.DATA_IMPORT_DIR, 'ems')

    def check_data_files(self):
        if not os.path.isdir(self.EMS_DATA_IMPORT_DIR):
            raise Exception(
                'EMS data directory does not exist. '
                'Should be at "%s". ' % self.EMS_DATA_IMPORT_DIR
            )

        self.file_path = os.path.join(self.EMS_DATA_IMPORT_DIR, 'school_id_status.csv')
        if not os.path.isfile(self.file_path):
            raise Exception(
                'Data file missing: %s' % self.file_path
            )

    def handle(self, *args, **options):
        self.check_data_files()

        count = 0
        with open(self.file_path, 'r') as statusidfile:
            reader = DictReader(statusidfile)
            for ems_school in reader:
                try:
                    school = School.objects.get(id=ems_school['id'])

                    if school.status == int(ems_school['active']):
                        continue

                    log('Found school with different status: ' + str(school.id))
                    school.status = ems_school['active']
                    school.save()
                    count += 1
                except Exception, e:
                    log('Could not find school: ' + str(ems_school['id']))
                    print e

        print 'Updated', count, 'schools'
