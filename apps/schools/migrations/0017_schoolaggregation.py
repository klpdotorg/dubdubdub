# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0016_meetingreport_generated_at'),
    ]

    operations = [
        migrations.CreateModel(
            name='SchoolAggregation',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('gender', models.CharField(max_length=128, choices=[('boys', 'Boys'), ('girls', 'Girls'), ('co-ed', 'Co-education')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('num', models.IntegerField(null=True, db_column='num', blank=True)),
            ],
            options={
                'db_table': 'mvw_institution_aggregations',
                'managed': False,
            },
            bases=(models.Model,),
        ),
    ]
