# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0012_boundaryassessmentpercentile_grampanchayat_institutionassessmentpercentile'),
    ]

    operations = [
        migrations.AddField(
            model_name='locality',
            name='gram_panchayat',
            field=models.ForeignKey(blank=True, to='schools.GramPanchayat', null=True),
            preserve_default=True,
        ),
    ]
