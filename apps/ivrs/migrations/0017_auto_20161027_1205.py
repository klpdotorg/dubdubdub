# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0021_auto_20160523_2237'),
        ('ivrs', '0016_auto_20161004_2318'),
    ]

    operations = [
        migrations.AddField(
            model_name='incomingnumber',
            name='name',
            field=models.CharField(default=1, max_length=50),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='questiongrouptype',
            name='is_active',
            field=models.BooleanField(default=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='questiongrouptype',
            name='questiongroup',
            field=models.OneToOneField(default=1, to='stories.Questiongroup'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='incomingnumber',
            name='qg_type',
            field=models.ForeignKey(blank=True, to='ivrs.QuestionGroupType', null=True),
            preserve_default=True,
        ),
    ]
