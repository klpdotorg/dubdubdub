import os
import sys
import csv
from django.core.management.base import BaseCommand
from django.core.files.images import ImageFile
from stories.models import (Story, Answer, Question, Questiongroup, StoryImage)
from schools.models import School
from users.models import User


class Command(BaseCommand):
    args = "<csvname imagepath>"
    help = """Import data from EMS

    ./manage.py importdata1 foobar.csv /path/to/images/"""

    def handle(self, *args, **options):
        filename, self.image_location = args
        file = open(filename, 'r')
        self.data = csv.DictReader(file)
        self.notfoundfile = open('not-in-dubdubdub.txt', 'w')

        for d in self.data:
            klpid = d['KLP ID']
            address = d['Address']
            landmark = d['Landmark #1']
            bus = d['Bus Details']
            pincode = d['PIN Code']
            lat = d['LAT']
            lon = d['LONG']
            coordinates = 'POINT ('+lon+' '+lat+')'

            if not (klpid.startswith('5')):
                try:
                    school = School.objects.get(id=d['KLP ID'])
                    school_address = school.address

                    # Update details.
                    if address:
                        school_address.address = d['Address']
                    if landmark:
                        school_address.landmark = d['Landmark #1']
                    if bus:
                        school_address.bus = bus
                    if pincode:
                        school_address.pincode = pincode

                    school.instcoord.coord = coordinates

                    school_address.save()
                    school.save()

                    # Story
                    story = {
                        'date': d['Date'],
                        'user': User.objects.get(email='dev@klp.org.in'),
                        'email': 'dev@klp.org.in',
                        'name': 'Team KLP',
                        'school': school
                        }

                    self.createStory(story, klpid)

                except:
                    self.notfoundfile.write(klpid+'\n')
                    pass

        self.notfoundfile.close()

    def createStory(self, story, klpid):
        group = Questiongroup.objects.get(id=1)
        new_story = Story(user=story.user, school=story.school,
                          group=group, is_verified=True, name=story.name,
                          email=story.email, date=story.date)
        playground_question = Question.objects.get(text='Play ground')
        fence_question = Question.objects.get(text='Boundary wall/ Fencing')
        playground_answer = Answer(story=new_story,
                                   question=playground_question,
                                   text=self.d['PlayGround?'])
        fence_answer = Answer(story=new_story, question=fence_question,
                              text=self.d['Fence?'])

        # Images
        images = []
        for i in xrange(1, 4):
            image_filename = '%d-%d.png' % (klpid, i)
            image_path = sys.path.join(self.image_location, image_filename)
            if os.path.isfile(image_path):
                images.append(
                    StoryImage(
                        story=new_story, image=ImageFile(
                            open(image_path)
                        ), is_verified=True, filename=image_filename
                    )
                )
        StoryImage.objects.bulk_create(images)

        new_story.save()
        playground_answer.save()
        fence_answer.save()
