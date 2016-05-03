# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0013_auto_20160227_2100'),
    ]

    operations = [
        migrations.RunSQL('ALTER TABLE stories_questiongroup ADD COLUMN name varchar(100)')
    ]
