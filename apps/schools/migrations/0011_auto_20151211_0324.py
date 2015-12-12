# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0010_data_fill_locality'),
    ]

    operations = [
        migrations.AlterField(
            model_name='locality',
            name='assembly',
            field=models.ForeignKey(blank=True, to='schools.Assembly', null=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='locality',
            name='parliament',
            field=models.ForeignKey(blank=True, to='schools.Parliament', null=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='locality',
            name='pincode',
            field=models.ForeignKey(blank=True, to='schools.Postal', null=True),
            preserve_default=True,
        ),
    ]
