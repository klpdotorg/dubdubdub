from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
import os
import psycopg2.extras
import pandas as pd
import numpy as np
from csv import DictReader
from prettytable import PrettyTable
cursor = connection.cursor()


def dictfetchall(cursor):
    "Returns all rows from a cursor as a dict"
    desc = cursor.description
    return [
        dict(zip([col[0] for col in desc], row))
        for row in cursor.fetchall()
    ]


class Command(BaseCommand):
    help = 'Imports EMS data extracted as CSVS'
    EMS_DATA_IMPORT_DIR = os.path.join(settings.DATA_IMPORT_DIR, 'ems')
    EMS_DATA_QUERIES = {
        'tb_boundary.csv': 'select id, parent as parent_id, name, hid as boundary_category_id, type as boundary_type_id from tb_boundary',
        'tb_address.csv': 'select tb_address.id as id, address, area, pincode, landmark, instidentification, instidentification2, bus as route_information from tb_address, tb_school where tb_school.aid=tb_address.id and tb_school.status=2',
        'tb_school.csv': '',
        'tb_child.csv': '',
        'tb_class.csv': '',
        'tb_student.csv': '',
        'tb_student_class.csv': '',
        'tb_teacher.csv': '',
        'tb_teacher_class.csv': '',
        'tb_teacher_qual.csv': '',
        'tb_programme.csv': '',
        'tb_assessment.csv': '',
        'tb_question.csv': '',
        'tb_student_eval.csv': ''
    }

    def check_data_files(self):
        if not os.path.isdir(self.EMS_DATA_IMPORT_DIR):
            raise Exception(
                'EMS data directory does not exist. '
                'Should be at "%s". ' % self.EMS_DATA_IMPORT_DIR
            )

        for f in self.EMS_DATA_QUERIES.keys():
            file_path = os.path.join(self.EMS_DATA_IMPORT_DIR, f)
            if not os.path.isfile(file_path):
                raise Exception(
                    'Data file missing: %s' % file_path
                )

    def handle_tb_boundary(self):
        file_name = 'tb_boundary.csv'
        file_path = os.path.join(self.EMS_DATA_IMPORT_DIR, file_name)

        cursor.execute(self.EMS_DATA_QUERIES[file_name])
        df_sql_list = dictfetchall(cursor)
        df_sql = {d['id']: d for d in df_sql_list}

        self.stdout.write('Total %s boundaries in DB' % len(df_sql))

        new_row_ids = []
        update_row_ids = []

        with open(file_path, 'r') as csvfile:
            csv_reader = DictReader(csvfile)

            table = PrettyTable(['id', 'key', 'value in dubdubdub', 'value in ems'])
            for csv_row in csv_reader:
                if int(csv_row['id']) not in df_sql.keys():
                    new_row_ids.append(csv_row['id'])
                    continue

                matching_sql_row = df_sql[int(csv_row['id'])]

                for key in ["parent_id", "name", "boundary_category_id", "boundary_type_id"]:
                    if str(csv_row[key]) != str(matching_sql_row[key]):
                        update_row_ids.append(csv_row['id'])
                        table.add_row([csv_row['id'], key, str(matching_sql_row[key]), csv_row[key]])

            self.stdout.write("Values to update")
            print table

        self.stdout.write(
            '{} new boundaries to add, {} boundaries to update'.format(
                len(new_row_ids), len(set(update_row_ids))
            )
        )

    def handle(self, *args, **options):
        # check if data files are in place
        self.check_data_files()

        self.handle_tb_boundary()

        self.stdout.write('%s' % self.EMS_DATA_IMPORT_DIR)
