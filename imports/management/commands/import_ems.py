from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from collections import defaultdict
import os
from csv import DictReader
from datetime import datetime
from schools.models import School, Address, Child
from imports.models import EMSSchool, EMSAddress, EMSChild


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
    help = 'Imports EMS data extracted as CSVS'
    EMS_DATA_IMPORT_DIR = os.path.join(settings.DATA_IMPORT_DIR, 'ems')
    EMS_DATA_QUERIES = {
        'tb_boundary.csv': 'select id, parent as parent_id, name, hid as boundary_category_id, type as boundary_type_id from tb_boundary',
        'tb_school.csv': 'select id, boundary_id::integer as bid, inst_address_id::integer as aid, dise_code, inst_name as name, inst_category as cat, institution_gender as sex, COALESCE(moi, \'kannada\') as moi, management as mgmt, active as status from ems_tb_school',
        'tb_address.csv': 'select tb_address.id as id, address, area, pincode, landmark, instidentification, instidentification2, bus as route_information from tb_address, tb_school where tb_school.aid=tb_address.id and tb_school.status=2',
        'tb_child.csv': 'select id, name, dob, sex as gender, mt from tb_child',
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

    def need_update(self, objone, objtwo, keys):
        """
        Takes 2 similar objects and a list of keys to compare

        Returns True if any of the key values don't match
        """
        for key in keys:
            value_one = getattr(objone, key).lower() if isinstance(getattr(objone, key), basestring) else getattr(objone, key)
            value_two = getattr(objtwo, key).lower() if isinstance(getattr(objtwo, key), basestring) else getattr(objtwo, key)

            if value_one != value_two:
                return True
        return False

    def handle_tb_school(self):
        keys = ['status', 'name', 'admin3_id', 'cat', 'dise_info_id', 'mgmt', 'sex']

        # all schools in ems table
        ems_schools = EMSSchool.objects.all()
        ems_schools_dict = dict()
        # all schools in www table
        www_schools_qs = School.objects.all()
        www_schools = dict()
        for s in www_schools_qs:
            www_schools[s.id] = s

        # new schools in ems table
        ems_schools_new = ems_schools.exclude(id__in=www_schools_qs)

        ems_schools_existing = ems_schools.filter(id__in=www_schools_qs)

        log('Total %s new schools' % ems_schools_new.count())
        log(','.join([str(_.id) for _ in ems_schools_new]))

        for new_school in ems_schools_new:
            if new_school.id in www_schools.keys():
                log('Duplicate schools in EMS table - %s' % new_school.id)
                continue
            # insert new school
            log('Processing new school - %s' % new_school)
            new_address = None

            if new_school.address_id:
                ems_school_address = EMSAddress.objects.get(pk=new_school.address_id)

                matching_existing_address = Address.objects.filter(
                    address=ems_school_address.address,
                    area=ems_school_address.area,
                    pincode=ems_school_address.pincode,
                    landmark=ems_school_address.landmark,
                    instidentification=ems_school_address.instidentification,
                    bus=ems_school_address.bus,
                    instidentification2=ems_school_address.instidentification2
                )

                if matching_existing_address.count() > 0:
                    log('Found existing address %s' % matching_existing_address[0].id)
                    new_school.address = matching_existing_address[0]
                else:
                    new_address = Address.objects.create(
                        address=ems_school_address.address,
                        area=ems_school_address.area,
                        pincode=ems_school_address.pincode,
                        landmark=ems_school_address.landmark,
                        instidentification=ems_school_address.instidentification,
                        bus=ems_school_address.bus,
                        instidentification2=ems_school_address.instidentification2
                    )
                    log('Created new address %s' % new_address.id)

            www_new_school = School.objects.create(
                id=new_school.id,
                admin3_id=new_school.admin3_id,
                address=new_address,
                dise_info_id=new_school.dise_info_id,
                name=new_school.name,
                cat=new_school.cat,
                sex=new_school.sex,
                moi=new_school.moi,
                mgmt=new_school.mgmt,
                status=new_school.status,
            )

            # add it to the list of existing schools in www
            # so that we dont have to query again
            www_schools[www_new_school.id] = www_new_school
            log('Created new school - %s' % www_new_school)

        # find schools in www that needs to be updated
        www_schools_update = []
        for ems_sch in ems_schools_existing:
            ems_schools_dict[ems_sch.id] = ems_sch
            www_sch = www_schools[ems_sch.id]

            if self.need_update(www_sch, ems_sch, keys):
                www_schools_update.append(www_sch)

        log('Total %s schools to update' % len(www_schools_update))
        log(','.join([str(_.id) for _ in www_schools_update]))

        for www_school in www_schools_update:
            # update existing school
            log('Updating existing school - %s' % www_school)
            ems_school = ems_schools_dict[www_school.id]

            # if www doesn't have address copy it from ems
            # if www has address, dont bother

            if not www_school.address and ems_school.address:
                ems_school_address = ems_school.address

                matching_existing_address = Address.objects.filter(
                    address=ems_school_address.address,
                    area=ems_school_address.area,
                    pincode=ems_school_address.pincode,
                    landmark=ems_school_address.landmark,
                    instidentification=ems_school_address.instidentification,
                    bus=ems_school_address.bus,
                    instidentification2=ems_school_address.instidentification2
                )

                if matching_existing_address.count() > 0:
                    log('Found existing address %s' % matching_existing_address[0].id)
                    www_school.address = matching_existing_address[0]
                else:
                    new_address = Address.objects.create(
                        address=ems_school_address.address,
                        area=ems_school_address.area,
                        pincode=ems_school_address.pincode,
                        landmark=ems_school_address.landmark,
                        instidentification=ems_school_address.instidentification,
                        bus=ems_school_address.bus,
                        instidentification2=ems_school_address.instidentification2
                    )
                    log('Created new address %s' % new_address.id)
                    www_school.address = new_address

            www_school.admin3_id = ems_school.admin3_id
            www_school.dise_info_id = ems_school.dise_info_id
            www_school.name = ems_school.name
            www_school.cat = ems_school.cat
            www_school.moi = ems_school.moi if ems_school.moi else 'kannada'
            www_school.sex = ems_school.sex
            www_school.mgmt = ems_school.mgmt
            www_school.status = ems_school.status
            www_school.save()

            log('Updated existing school %s' % www_school)

    def handle(self, *args, **options):
        # check if data files are in place
        self.check_data_files()

        self.handle_tb_school()

        self.stdout.write('%s' % self.EMS_DATA_IMPORT_DIR)
