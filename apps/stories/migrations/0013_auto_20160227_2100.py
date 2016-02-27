# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0012_auto_20151211_0324'),
    ]

    operations = [
        migrations.AlterField(
            model_name='story',
            name='date_of_visit',
            field=models.DateTimeField(default=django.utils.timezone.now),
            preserve_default=True,
        ),
    ]
