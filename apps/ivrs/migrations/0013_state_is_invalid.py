# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0012_state_is_processed'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='is_invalid',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
    ]
