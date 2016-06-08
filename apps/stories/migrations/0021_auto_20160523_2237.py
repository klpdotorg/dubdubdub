# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0020_auto_20160522_2236'),
    ]

    operations = [
        migrations.RunSQL(
            'ALTER TABLE stories_questiongroup ADD COLUMN created_at timestamp with time zone NULL'
        ),
        migrations.RunSQL(
            'ALTER TABLE stories_questiongroup ADD COLUMN updated_at timestamp with time zone NULL'
        ),
        migrations.RunSQL(
            'ALTER TABLE stories_questiongroup ADD COLUMN status integer NOT NULL DEFAULT 0'
        ),
        migrations.RunSQL(
            'ALTER TABLE stories_questiongroup ADD COLUMN survey_id INTEGER REFERENCES stories_survey'
        ),
        migrations.RunSQL(
            'ALTER TABLE stories_questiongroup ADD COLUMN created_by_id INTEGER REFERENCES users_user'
        ),
        migrations.RunSQL(
            'ALTER TABLE stories_questiongroup ADD COLUMN school_type_id INTEGER REFERENCES tb_boundary_type'
        ),
    ]
