# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0004_auto_20150107_1150'),
    ]

    operations = [
        migrations.AddField(
            model_name='academicyear',
            name='from_year',
            field=models.IntegerField(null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='academicyear',
            name='to_year',
            field=models.IntegerField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
