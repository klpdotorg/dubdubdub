import os
import sys
import csv
import psycopg2
from django.core.management.base import BaseCommand
from django.core.files.images import ImageFile
from django.db import transaction
from stories.models import (Story, Answer, Question, Questiongroup, StoryImage)
from schools.models import School, Address, Boundary, BoundaryType, BoundaryHierarchy
from users.models import User


class Command(BaseCommand):
    args = "<csvname imagepath>"
    help = """Import data from EMS

    ./manage.py importdata1 foobar.csv /path/to/images/"""

    @transaction.atomic
    def handle(self, *args, **options):
        filename, self.image_location = args
        file = open(filename, 'r')
        self.data = csv.DictReader(file)
        self.notfoundfile = open('not-in-dubdubdub.txt', 'w')
        dev_user = User.objects.get(email='dev@klp.org.in')

        for d in self.data:
            # ,Unnamed: 0_x,S No_x,Date,Block,Cluster,School Name_spotways,
            # KLP ID,Address,PIN Code,PlayGround?,Fence?,Landmark #1,
            # Landmark #2,Route to School,Bus Details,
            # LAT_spotways,LONG_spotways,Unnamed: 0_y,S No_y,klp_district,
            # klp_block,klp_cluster,dise_code,School Name_ems,category,
            # management,LAT_ems,LONG_ems,institution_gender,hierarchy,moi
            klpid = d['KLP ID']
            address = d['Address']
            landmark = d['Landmark #1']
            bus = d['Bus Details']
            pincode = d['PIN Code']
            lat = d['LAT_spotways']
            lon = d['LONG_spotways']
            coordinates = 'POINT ('+lon+' '+lat+')'

            connection, cursor = self.connectKlpCoord()

            if klpid.startswith('5'):
                continue

            print '='*20

            try:
                school = School.objects.get(id=klpid)
            except School.DoesNotExist:
                # School doesn't exist
                print 'Creating new school with id: %s' % klpid
                school = School(
                    id=klpid,
                    name=d.get('Name_ems'),
                    cat=d.get('category'),
                    sex=d.get('institution_gender', 'co-ed'),
                    moi=d.get('moi', 'kannada'),
                    mgmt=d.get('management', 'ed')
                )
                school.admin3 = self.get_or_create_admin3(d)

            if address:
                if school.address and (not school.address == address):
                    school_address = school.address
                    school_address.address = address
                else:
                    print 'Creating new address for klpid: %s' % klpid
                    school_address = Address.objects.create(
                        address=address
                    )
                    school.address = school_address

            # Update address details.
            if landmark:
                school_address.landmark = landmark
            if bus:
                school_address.bus = bus
            if pincode:
                school_address.pincode = pincode

            school_address.save()
            school.save()

            # Story
            story = {
                'date': d['Date'],
                'user': dev_user,
                'email': 'dev@klp.org.in',
                'name': 'Team KLP',
                'school': school
            }

            self.createStory(story, klpid, d)

            self.updateCoord(cursor, klpid, coordinates)

            cursor.close()
            connection.commit()
            connection.close()

        self.notfoundfile.close()

    def school_exists(self, klpid):
        return School.objects.filter(id=klpid).count() > 0

    def get_or_create_admin3(self, data):
        hierarchy = data.get('hierarchy')
        hierarchies = {
            'project': 14,
            'circle': 15,
            'district': 13,
            'cluster': 11,
            'district': 9,
            'block': 10,
            'school': 12,
        }

        if hierarchy == 'Dist/Proj/Circ':
            type_id = 2
        elif hierarchy == 'Dist/Blck/Clst':
            type_id = 1
        else:
            raise Exception('Invalid hierarchy "%s"' % hierarchy)

        print hierarchy
        # create or get district
        try:
            district = Boundary.objects.get(
                name__iexact=data.get('klp_district'))
        except Boundary.DoesNotExist:
            print 'Creating new district: %s' % data.get('klp_district')
            district = Boundary(
                name=data.get('klp_district'),
                hierarchy_id=13 if type_id == 2 else 9,
                type_id=type_id
            )
            district.save()

        # create or get project/block
        try:
            admin2 = Boundary.objects.get(
                name__iexact=data.get('klp_block'),
                hierarchy_id=hierarchies['block' if type_id == 1 else 'project'],
                type_id=type_id
            )
        except Boundary.DoesNotExist:
            print 'Creating new block: %s' % data.get('klp_block')
            admin2 = Boundary(
                name=data.get('klp_block'),
                hierarchy_id=hierarchies['block' if type_id == 1 else 'project'],
                type_id=type_id,
                parent=district
            )
            admin2.save()

        # create or get circle/cluster
        try:
            admin3 = Boundary.objects.get(
                name__iexact=data.get('klp_cluster'),
                hierarchy_id=hierarchies['cluster' if type_id == 1 else 'circle'],
                type_id=type_id
            )
        except Boundary.DoesNotExist:
            print 'Creating new cluster: %s' % data.get('klp_cluster')
            admin3 = Boundary(
                name=data.get('klp_cluster'),
                hierarchy_id=hierarchies['cluster' if type_id == 1 else 'circle'],
                type_id=type_id,
                parent=admin2
            )
            admin3.save()

        return admin3

    def createStory(self, story, klpid, d):
        group = Questiongroup.objects.get(id=1)
        new_story, created = Story.objects.get_or_create(
            user=story['user'], school=story['school'],
            group=group, is_verified=True, name=story['name'],
            email=story['email']
        )
        if created:
            print 'Created new story for school id: %s' % klpid
            new_story.date = story['date']
            new_story.save()

        playground_question = Question.objects.get(text='Play ground')
        fence_question = Question.objects.get(text='Boundary wall/ Fencing')
        playground_answer, created = Answer.objects.get_or_create(
            story=new_story,
            question=playground_question,
            text=d['PlayGround?']
        )

        fence_answer, crerated = Answer.objects.get_or_create(
            story=new_story, question=fence_question, text=d['Fence?']
        )

        # Images
        images = []
        for i in xrange(1, 4):
            image_filename = '%d-%d.png' % (int(klpid), i)

            if StoryImage.objects.filter(story=new_story,
                                         filename=image_filename).count() > 0:
                continue

            image_path = os.path.join(self.image_location, image_filename)
            if os.path.isfile(image_path):
                images.append(
                    StoryImage(
                        story=new_story, image=ImageFile(
                            open(image_path)
                        ), is_verified=True, filename=image_filename
                    )
                )
                print 'Added image for school id: %d' % int(klpid)

        if images:
            StoryImage.objects.bulk_create(images)

    def connectKlpCoord(self):
        connection = psycopg2.connect("dbname=klp-coord user=klp")
        cursor = connection.cursor()
        return connection, cursor

    def updateCoord(self, cursor, klpid, coordinates):
        query = {
            'check': "SELECT instid from inst_coord WHERE instid=%(klpid)s;",
            'insert': "INSERT INTO inst_coord VALUES (%(klpid)s, ST_PointFromText(%(coordinates)s), 4326);",
            'update': "UPDATE inst_coord SET coord=ST_PointFromText(%(coordinates)s, 4326) WHERE instid=%(klpid)s;"
        }

        cursor.execute(query['check'], {'klpid': klpid})

        if cursor.rowcount > 0:
            cursor.execute(query['update'], {'coordinates': coordinates, 'klpid': klpid})
            print 'Updated coordinates for school id: %s' % klpid
        else:
            cursor.execute(query['insert'], {'coordinates': coordinates, 'klpid': klpid})
            print 'Inserted coordinates for school id: %s' % klpid

    def split_data(self, data):
        exists = []
        notexists = []
        for d in data:
            klpid = d.get('KLP ID')
            if School.objects.filter(id=klpid).count() > 0:
                exists.append(d)
            else:
                notexists.append(d)

        existwriter = csv.DictWriter(
            open('merged_exist.csv', 'w'),
            fieldnames=exists[0].keys()
        )
        existwriter.writeheader()
        existwriter.writerows(exists)

        notexistwriter = csv.DictWriter(
            open('merged_notexist.csv', 'w'),
            fieldnames=exists[0].keys()
        )
        notexistwriter.writeheader()
        notexistwriter.writerows(notexists)
