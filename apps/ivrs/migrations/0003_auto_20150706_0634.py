# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0002_state_question_number'),
    ]

    operations = [
        migrations.AlterField(
            model_name='state',
            name='question_number',
            field=models.IntegerField(default=1),
            preserve_default=True,
        ),
    ]
