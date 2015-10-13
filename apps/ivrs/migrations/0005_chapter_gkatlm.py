# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0004_state_answers'),
    ]

    operations = [
        migrations.CreateModel(
            name='Chapter',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('class_number', models.IntegerField()),
                ('chapter_number', models.IntegerField()),
                ('title', models.CharField(max_length=300)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='GKATLM',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('number', models.IntegerField()),
                ('title', models.CharField(max_length=300)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
