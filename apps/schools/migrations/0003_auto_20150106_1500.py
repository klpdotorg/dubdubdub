# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0002_boundaryliblangagg_boundaryliblevelagg'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='boundaryliblangagg',
            name='year',
        ),
        migrations.RemoveField(
            model_name='boundaryliblevelagg',
            name='year',
        ),
    ]
