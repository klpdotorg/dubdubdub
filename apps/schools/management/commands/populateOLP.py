import os
import csv
import json
import datetime

from optparse import make_option

from django.utils import timezone
from django.db import transaction
from django.utils.text import slugify
from django.core.management.base import BaseCommand

from common.utils import get_logfile_path
from schools.models.choices import STATUS_CHOICES

from schools.models import (
    Boundary,
    BoundaryType,
    BoundaryHierarchy,
    DiseInfo,
    School
)

CATEGORY_MAPPER = {
    '1':'Lower Primary',
    '2':'Upper Primary',
    '3':'Secondary',
    '4':'Upper Primary',
    '5':'Secondary',
    '6':'Secondary',
    '7':'Secondary',
    '8':'Secondary',
    '9':'Secondary',
    '10':'Secondary',
    '11':'Secondary'
}

SCHOOL_GENDER_MAPPER = {
    '1':'boys',
    '2':'girls',
    '3':'co-ed',
}

MOI_MAPPER = {
    '01':'assamese',
    '02':'bengali',
    '03':'gujarathi',
    '04':'hindi',
    '05':'kannada',
    '06':'kashmiri',
    '07':'konkani',
    '08':'malayalam',
    '09':'manipuri',
    '10':'marathi',
    '11':'nepali',
    '12':'oriya',
    '13':'punjabi',
    '14':'sanskrit',
    '15':'sindhi',
    '16':'tamil',
    '17':'telugu',
    '18':'urdu',
    '19':'english',
    '20':'bodo',
    '21':'mising',
    '22':'dogri',
    '23':'khasi',
    '24':'garo',
    '25':'mizo',
    '26':'bhutia',
    '27':'lepcha',
    '28':'limboo',
    '29':'french',
    '99':'other',
}

MANAGEMENT_MAPPER = {
    '1':'ed',
    '2':'swd',
    '3':'local',
    '4':'p-a',
    '5':'p-ua',
    '6':'others',
    '7':'central-g',
    '8':'ur',
    '97':'madrasa-r',
    '98':'madrasa-ur',
}

class Command(BaseCommand):
    args = "<path to file>"
    help = """Parses and populates the OLP School
    and boundary data.
    
    ./manage.py populateOLP --file=path/to/file"""
    
    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
        make_option('--confirm',
                    help='A mandatory parameter to avoid running this on any other instances'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        file_name = options.get('file', None)
        if not file_name:
            print "Please specify a filename with the --file argument"
            return

        confirm = options.get('confirm', None)
        if not confirm:
            print "Please pass in --confirm='yes_i_want_to_replace_klp_data_with_olp'"
            return

        if confirm != "yes_i_want_to_replace_klp_data_with_olp":
            print "Please pass in --confirm='yes_i_want_to_replace_klp_data_with_olp'"

        district_hierarchy = BoundaryHierarchy.objects.get(id=9, name='district') # Primary School districts
        block_hierarchy = BoundaryHierarchy.objects.get(name='block')
        cluster_hierarchy = BoundaryHierarchy.objects.get(name='cluster')

        primary_school_type = BoundaryType.objects.get(name='Primary School')

        latest_school_id = 63929 # School.objects.latest('id').id

        f = open(file_name, 'r')
        csv_f = csv.reader(f)
        output_sql = open(get_logfile_path("school_sql", "sql"), "w")

        count = 0

        for row in csv_f:
            # Skip first row
            if count == 0:
                count += 1
                continue

            district_name = row[2].strip().lower()
            block_name = row[4].strip().lower()
            cluster_name = row[6].strip().lower()
            area_name = row[8].strip().lower()

            school_id = row[9].strip()
            try:
                dise_info = DiseInfo.objects.get(dise_code=school_id)
            except:
                dise_info = None

            school_name = row[10].strip()

            management = row[19].strip()
            if management == '':
                management = '8' # Corresponds to 'ur'
            management = MANAGEMENT_MAPPER[management]

            category = row[20].strip()
            if category == '':
                category = '1' # Corresponds to 'Lower Primary'. Wild guess. Bad data.
            category = CATEGORY_MAPPER[category]

            gender = row[24].strip()
            if gender == '':
                gender = '3' # Corresponds to 'co-ed'. Wild guess. Bad data.
            gender = SCHOOL_GENDER_MAPPER[gender]

            moi = row[57].strip()
            if len(moi) == 1:
                moi = '0'+moi
            if moi in ['', '31', '32', '33', '35', '39', '98']:
                moi = '99'
            moi = MOI_MAPPER[moi]

            pincode = row[29].strip()
            longitude, latitude = row[171].strip(), row[172].strip()

            try:
                district, created = Boundary.objects.get_or_create(
                    name=district_name,
                    dise_slug=slugify(unicode(district_name)),
                    hierarchy=district_hierarchy,
                    type=primary_school_type,
                    status=2, # active. Defined in schools.models.choices
                )
            except Exception as ex:
                print "District"
                print ex
                print district_name
                print slugify(unicode(district_name))
                break

            try:
                block, created = Boundary.objects.get_or_create(
                    parent=district,
                    name=block_name,
                    dise_slug=slugify(unicode(district_name+' '+block_name)),
                    hierarchy=block_hierarchy,
                    type=primary_school_type,
                    status=2, # active. Defined in schools.models.choices
                )
            except Exception as ex:
                print "Block"
                print ex
                print block_name
                print slugify(unicode(district_name+' '+block_name))
                break

            try:
                cluster, created = Boundary.objects.get_or_create(
                    parent=block,
                    name=cluster_name,
                    dise_slug=slugify(unicode(block_name+' '+cluster_name)),
                    hierarchy=cluster_hierarchy,
                    type=primary_school_type,
                    status=2, # active. Defined in schools.models.choices
                )
            except Exception as ex:
                print "Cluster"
                print ex
                print cluster_name
                print slugify(unicode(block_name+' '+cluster_name))
                break

            try:
                latest_school_id += 1
                school, created = School.objects.get_or_create(
                    id=latest_school_id,
                    admin3=cluster,
                    dise_info=dise_info,
                    name=school_name,
                    cat=category,
                    sex=gender,
                    moi=moi,
                    mgmt=management,
                    status=2,
                )
                point = "ST_MakePoint(%s,%s)" % (longitude, latitude)
                sql = "INSERT INTO inst_coord (instid, coord) VALUES (%d,ST_SetSRID(%s,4326));" % (school.id, point)
                output_sql.write(sql + "\n")

                if created:
                    print "School created? :" + str(created) + "! School is " + str(school)
            except Exception as ex:
                print "School"
                print school_name
                print count
                print ex
                break

            count += 1
            if school.id % 2 ==0:
                print "-",
            else:
                print "*",
        else:
            print "Successfully imported data"

        output_sql.close()
