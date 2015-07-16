# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0011_auto_20150716_2255'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='is_processed',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
