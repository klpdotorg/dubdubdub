# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0007_auto_20150223_1115'),
    ]

    operations = [
        migrations.AddField(
            model_name='story',
            name='user_type',
            field=models.ForeignKey(blank=True, to='stories.UserType', null=True),
            preserve_default=True,
        ),
    ]
