# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0022_state_invalid_data'),
    ]

    operations = [
        migrations.RenameField(
            model_name='state',
            old_name='invalid_data',
            new_name='raw_data',
        ),
    ]
