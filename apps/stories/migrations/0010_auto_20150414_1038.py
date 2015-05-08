# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0009_auto_20150224_1014'),
    ]

    operations = [
        migrations.RunSQL('ALTER TABLE stories_question ADD COLUMN is_featured BOOLEAN DEFAULT FALSE'),
        migrations.RunSQL('ALTER TABLE stories_question ADD COLUMN display_text TEXT'),
        migrations.RunSQL('ALTER TABLE stories_question ADD COLUMN key varchar(100)'),
    ]
