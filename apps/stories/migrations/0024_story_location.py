# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.contrib.gis.db.models.fields


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0023_auto_20170607_2350'),
    ]

    operations = [
        migrations.AddField(
            model_name='story',
            name='location',
            field=django.contrib.gis.db.models.fields.PointField(srid=4326, max_length=50, null=True, blank=True),
            preserve_default=True,
        ),
    ]
