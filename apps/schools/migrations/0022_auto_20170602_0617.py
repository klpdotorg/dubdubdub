# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0021_auto_20170518_1322'),
    ]

    operations = [
        migrations.RunSQL('CREATE INDEX assessments_v2_question_id ON assessments_v2 (question_id);'),
        migrations.RunSQL('CREATE INDEX students_v2_district_name ON students_v2 (district);'),
        migrations.RunSQL('CREATE INDEX students_v2_block_name ON students_v2 (block);'),
        migrations.RunSQL('CREATE INDEX students_v2_cluster_name ON students_v2 (cluster);'),
    ]
