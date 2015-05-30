# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0010_auto_20150414_1038'),
    ]

    operations = [
        migrations.RunSQL('ALTER TABLE stories_questiongroup ADD COLUMN start_date timestamp with time zone NULL'),
        migrations.RunSQL('ALTER TABLE stories_questiongroup ADD COLUMN end_date timestamp with time zone NULL'),
    ]
