# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0006_auto_20150709_1519'),
    ]

    operations = [
        migrations.AlterField(
            model_name='state',
            name='session_id',
            field=models.CharField(unique=True, max_length=100),
            preserve_default=True,
        ),
    ]
