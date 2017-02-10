# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0018_auto_20161027_1207'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='qg_type',
            field=models.ForeignKey(blank=True, to='ivrs.QuestionGroupType', null=True),
            preserve_default=True,
        ),
    ]
