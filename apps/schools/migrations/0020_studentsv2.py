# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0019_assessmentsv2'),
    ]

    operations = [
        migrations.CreateModel(
            name='StudentsV2',
            fields=[
                ('uid', models.CharField(max_length=256, serialize=False, primary_key=True)),
                ('student_id', models.BigIntegerField(null=True, blank=True)),
                ('school_code', models.IntegerField(null=True, blank=True)),
                ('school_name', models.CharField(max_length=256, blank=True)),
                ('class_num', models.SmallIntegerField(null=True, blank=True)),
                ('cluster', models.CharField(max_length=256, blank=True)),
                ('block', models.CharField(max_length=256, blank=True)),
                ('district', models.CharField(max_length=256, blank=True)),
                ('child_name', models.CharField(max_length=256, blank=True)),
                ('dob', models.DateField(null=True, blank=True)),
                ('sex', models.CharField(max_length=16, blank=True)),
                ('father_name', models.CharField(max_length=256, blank=True)),
                ('mother_name', models.CharField(max_length=256, blank=True)),
                ('entry_ts', models.DateTimeField(null=True, blank=True)),
            ],
            options={
                'db_table': 'students_v2',
                'managed': False,
            },
            bases=(models.Model,),
        ),
    ]
