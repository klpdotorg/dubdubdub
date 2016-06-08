# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0019_auto_20160517_1502'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='survey',
            name='created_by',
        ),
        migrations.RemoveField(
            model_name='survey',
            name='group',
        ),
        migrations.RemoveField(
            model_name='survey',
            name='school_type',
        ),
        migrations.RemoveField(
            model_name='survey',
            name='status',
        ),
    ]
