# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0008_state_is_title_verified'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='date_of_visit',
            field=models.DateField(default=django.utils.timezone.now),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='state',
            name='telephone',
            field=models.CharField(max_length=50, blank=True),
            preserve_default=True,
        ),
    ]
