# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0015_auto_20160616_1254'),
    ]

    operations = [
        migrations.AddField(
            model_name='meetingreport',
            name='generated_at',
            field=models.DateField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
