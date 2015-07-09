# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.core.management import call_command

def forwards(apps, schema_editor):
    call_command('loaddata', 'gkatlm')
    call_command('loaddata', 'chapters')

class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0005_chapter_gkatlm'),
    ]

    operations = [
        migrations.RunPython(forwards),
    ]
