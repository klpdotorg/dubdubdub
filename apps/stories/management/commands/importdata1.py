import sys
import csv
from django.core.management.base import BaseCommand
from django.core.cache import cache
from stories.models import Story
from stories.models import Answer
from stories.models import Question
from stories.models import Questiongroup
from stories.models import StoryImage
from schools.models import School
from users.models import User

class Command(BaseCommand):
    help = 'Import data from EMS'

    filename = sys.argv[2]
    file = open(filename, 'r')
    data = csv.DictReader(file)
    notfoundfile = open('not-in-dubdubdub.txt', 'w')

    def handle(self, *args, **options):
        for d in self.data:
            klpid =  d['KLP ID']
            address = d['Address']
            landmark = d['Landmark #1']
            bus = d['Bus Details']
            pincode = d['PIN Code']
            lat = d['LAT']
            lon = d['LONG']
            coordinates = 'POINT ('+lon+' '+lat+')'


            print klpid
            if not (klpid.startswith('5')):
                try:
                    school = School.objects.get(id=d['KLP ID'])
                    school_address = school.address
                    # print school_address
                    print school.instcoord.coord = coordinates

                    # Update details.
                    if address:
                        school_address.address = d['Address']
                    if landmark:
                        school_address.landmark = d['Landmark #1']
                    if bus:
                        school_address.bus = bus
                    if pincode:
                        school_address.pincode = pincode
                    school_address.save()

                    # Story
                    story = {
                        date: d['Date'],
                        user: User.objects.get(email='dev@klp.org.in'),
                        email: 'dev@klp.org.in',
                        name: 'Team KLP',
                        school: school
                        }

                    self.createStory(story)

                except:
                    self.notfoundfile.write(klpid+'\n')
                    pass

        self.notfoundfile.close()
        self.stdout.write('This works!')

    def createStory(self, story):
        group = Questiongroup.objects.get(id=1)
        new_story = Story(user=story.user, school=story.school,group=group,is_verified=True, name=story.name,
                    email=story.email, date=story.date)
        playground_question = Question.objects.get(text='Play ground')
        fence_question = Question.objects.get(text='Boundary wall/ Fencing')
        playground_answer = Answer(story=new_story, question=playground_question, text=self.d['PlayGround?'])
        fence_answer = Answer(story=new_story, question=fence_question, text=self.d['Fence?'])

        # Images
        # Todo.

        new_story.save()
        playground_answer.save()
        fence_answer.save()
