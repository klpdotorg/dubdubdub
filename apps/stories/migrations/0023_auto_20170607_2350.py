# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations

from stories.models import Story
from users.models import User

def forwards_func(apps, schema_editor):
    stories = Story.objects.filter(group__source__name="sms")
    unregistered_mobile_nos = []
    for story in stories:
        # Trimming the starting 0 if it is there.
        if len(story.telephone) > 10:
            telephone = story.telephone[1:]
        else:
            telephone = story.telephone
        try:
            user = User.objects.get(mobile_no=telephone)
            story.user = user
        except:
            unregistered_mobile_nos.append(telephone)
        story.telephone = telephone
        story.save()

    print set(unregistered_mobile_nos)

def reverse_func(apps, schema_editor):
    stories = Story.objects.filter(group__source__name="sms")
    for story in stories:
        story.user = None
        story.save()


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0022_auto_20170427_2321'),
    ]

    operations = [
        migrations.RunPython(forwards_func, reverse_func),
    ]
