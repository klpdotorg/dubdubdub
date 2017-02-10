# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0023_auto_20161030_1226'),
    ]

    operations = [
        migrations.AddField(
            model_name='state',
            name='comments',
            field=models.TextField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
