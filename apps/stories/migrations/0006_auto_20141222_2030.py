# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0005_auto_20141221_1953'),
    ]

    operations = [
        migrations.AlterField(
            model_name='story',
            name='date_of_visit',
            field=models.DateField(default=django.utils.timezone.now),
            preserve_default=True,
        ),
    ]
