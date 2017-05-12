# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0018_auto_20170512_1123'),
    ]

    operations = [
        migrations.CreateModel(
            name='AssessmentsV2',
            fields=[
                ('assess_uid', models.CharField(max_length=128, serialize=False, primary_key=True)),
                ('student_uid', models.CharField(max_length=256, blank=True)),
                ('device_id', models.CharField(max_length=256, blank=True)),
                ('session_id', models.CharField(max_length=256, blank=True)),
                ('question_id', models.CharField(max_length=128, blank=True)),
                ('ekstep_tag', models.CharField(max_length=20, blank=True)),
                ('question_idx', models.IntegerField(null=True, blank=True)),
                ('pass_field', models.CharField(max_length=16, db_column='pass', blank=True)),
                ('score', models.DecimalField(null=True, max_digits=65535, decimal_places=65535, blank=True)),
                ('result', models.TextField(blank=True)),
                ('time_taken', models.IntegerField(null=True, blank=True)),
                ('ex_time_taken', models.IntegerField(null=True, blank=True)),
                ('params', models.TextField(blank=True)),
                ('uri', models.TextField(blank=True)),
                ('assessed_ts', models.DateTimeField(null=True, blank=True)),
            ],
            options={
                'db_table': 'assessments_v2',
                'managed': False,
            },
            bases=(models.Model,),
        ),
    ]
