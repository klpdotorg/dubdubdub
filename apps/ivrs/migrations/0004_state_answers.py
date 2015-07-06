# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import djorm_pgarray.fields


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0003_auto_20150706_0634'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='answers',
            field=djorm_pgarray.fields.TextArrayField(default=[], dbtype='text'),
            preserve_default=True,
        ),
    ]
