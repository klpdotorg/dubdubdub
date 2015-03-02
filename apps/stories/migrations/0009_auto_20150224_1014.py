# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0008_story_user_type'),
    ]

    operations = [
        migrations.RunSQL('ALTER TABLE stories_question ADD COLUMN user_type INTEGER REFERENCES stories_usertype'),
    ]
