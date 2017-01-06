# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0021_remove_state_ivrs_type'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='invalid_data',
            field=models.TextField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
