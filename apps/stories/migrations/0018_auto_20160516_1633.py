# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0017_auto_20160516_1139'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='survey',
            name='is_active',
        ),
        migrations.AddField(
            model_name='survey',
            name='status',
            field=models.IntegerField(default=0, choices=[(0, 'Draft'), (1, 'Active'), (2, 'Archived')]),
            preserve_default=True,
        ),
    ]
