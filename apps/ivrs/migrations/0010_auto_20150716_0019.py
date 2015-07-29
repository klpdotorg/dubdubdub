# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0009_auto_20150711_2003'),
    ]

    operations = [
        migrations.AlterField(
            model_name='state',
            name='date_of_visit',
            field=models.DateTimeField(default=django.utils.timezone.now),
            preserve_default=True,
        ),
    ]
