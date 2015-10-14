# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0010_auto_20150716_0019'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='state',
            name='is_title_verified',
        ),
        migrations.RemoveField(
            model_name='state',
            name='question_number',
        ),
    ]
