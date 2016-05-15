# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0015_survey'),
    ]

    operations = [
        migrations.RunSQL('ALTER TABLE stories_questiongroup ADD COLUMN survey_id INTEGER REFERENCES stories_survey'),
    ]
