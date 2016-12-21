import sys
from django.contrib.auth import get_user_model

from django.db import transaction, models
from django.core.management.base import BaseCommand
from stories.models import Story, Questiongroup

User = get_user_model()


def log(msg):
    with open('logs/fc-create.log', 'a') as fc:
        fc.write(msg + '\n')


def uniquify_user(user_collection, user_to_keep):
    rest_users = user_collection.exclude(id=user_to_keep.id)
    Questiongroup.objects.filter(
        created_by__in=rest_users
    ).update(
        created_by=user_to_keep
    )
    Story.objects.filter(
        user__in=rest_users
    ).update(user=user_to_keep)
    rest_users.delete()


class Command(BaseCommand):
    @transaction.atomic
    def handle(self, *args, **options):
        konnected_users = ["gajendravallar@gmail.com", "hanumantharaya@akshara.org.in", "mayurappab@gmail.com", "natab146@gmail.com", "pandithkhm9009@gmail.com", "mbiradar777@gmail.com", "santhoshkumar.machkure@gmail.com", "sharanuprabhu@gmail.com", "sidram@akshara.org.in", "vbpatil2684@gmail.com", "ajbelam@gmail.com", "jyothi@akshara.org.in", "sanjeevkumark321@gmail.com", "shankarnagmardi@gmail.com", "shiremath8005.sh@gmail.com", "sudhakarpatil108@gmail.com", "g.s.vandali@gmail.com", "manjunathmeti40@gmail.com", "adiveshappa@gmail.com", "kumargaded@gmail.com", "ranganath@akshara.org.in", "shivu9972488787@gmail.com", "svhonnalli794@gmail.com", "ayyannapalled@gmail.com", "praneshdv@gmail.com", "venky8715@gmail.com", "akkamahadevihm@gmail.com", "babuy1980@gmail.com", "Badni.@gmail.com", "Devendrada@akshara.org.in", "doddappa1981@gmail.com", "gkumarramesh7@gmail.com", "gudimaniprakash@gmail.com", "hanamanthm83@gmail.com", "lakshmankc749@gmail.com", "lakshminarayan2341@gmail.com", "mallapurmaruti@gmail.com", "prasannakumar01980@gmail.com", "raghunarayanappa9535@gmail.com", "sangugmp@gmail.com", "shankargoudagadad1889@gmail.com", "shivappabadiger1369@gmail.com", "srinivasap6180@gmail.com", "Srinivasapy@gmail.com", "umesh@akshara.org.in"]

        duplicate_mob_nos = User.objects.values('mobile_no').annotate(
            num_mob=models.Count('mobile_no')
        ).filter(num_mob__gt=1).order_by('-num_mob')
        print duplicate_mob_nos

        for mobile_no in duplicate_mob_nos:
            users = User.objects.filter(mobile_no=mobile_no['mobile_no'])
            print users
            # check if any of them in konnect users
            any_konnect_user = False
            for user in users:
                if user.email in konnected_users:
                    any_konnect_user = True
                    print "FOUND KONNECT USER!"

            if any_konnect_user:
                for user in users:
                    if user.email in konnected_users:
                        # keep this user, delete others
                        # replace entries in stories and questiongroup.created_by
                        uniquify_user(users, user)
            else:
                story_counts = Story.objects.values('user').annotate(
                    num_stories=models.Count('user')
                ).filter(user__in=users).order_by('-num_stories')
                print story_counts
                # keep user with most stories
                if len(story_counts) > 0:
                    user_to_keep = User.objects.get(id=story_counts[0]['user'])
                    uniquify_user(users, user_to_keep)
                else:
                    # none of the user accounts have any stories tied to them
                    # delete either one
                    uniquify_user(users, users[0])

        User.objects.filter(email='dev@klp.org.in').update(mobile_no='1234567890')