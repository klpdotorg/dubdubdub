# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.utils import timezone
from dateutil.parser import parse
import pytz

IST = pytz.timezone('Asia/Kolkata')


def fill_created_at(apps, schema_editor):
    count = 0
    Story = apps.get_model('stories', 'Story')
    for story in Story.objects.all():
        if story.created_at != story.entered_timestamp:
            story.created_at = story.entered_timestamp
            story.save()
            count += 1
    print 'updated %d created_at' % count


def fill_date_of_visit(apps, schema_editor):
    Story = apps.get_model('stories', 'Story')
    for story in Story.objects.all():
        try:
            story.date_of_visit = parse(story.date, dayfirst=True).replace(tzinfo=IST).date()
        except:
            # choosing a random date 04-04-2012 for stories without valid date
            print 'Invalid date %s, improvising..' % story.date
            story.date_of_visit = parse('04-04-2012', dayfirst=True).replace(tzinfo=IST).date()
        story.save()


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0004_auto_20141221_1905'),
    ]

    operations = [
        migrations.RunPython(fill_created_at),
        migrations.RunPython(fill_date_of_visit)
    ]
