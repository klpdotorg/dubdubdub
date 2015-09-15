# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0013_state_is_invalid'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='ivrs_type',
            field=models.CharField(default=b'gka', max_length=10),
            preserve_default=True,
        ),
    ]
