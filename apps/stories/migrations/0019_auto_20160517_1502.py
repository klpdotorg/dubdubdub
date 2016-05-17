# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0018_auto_20160516_1633'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='survey',
            name='end_date',
        ),
        migrations.RemoveField(
            model_name='survey',
            name='start_date',
        ),
        migrations.AddField(
            model_name='survey',
            name='group',
            field=models.OneToOneField(null=True, blank=True, to='stories.Questiongroup'),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='survey',
            name='name',
            field=models.CharField(max_length=150),
            preserve_default=False,
        ),
    ]
