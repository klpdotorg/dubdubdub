# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0023_auto_20141113_0206'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='organization',
            name='website',
        ),
    ]
