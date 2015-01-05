# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='BoundaryLibLangAgg',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('class_name', models.IntegerField(null=True, db_column='class', blank=True)),
                ('month', models.CharField(max_length=10, blank=True)),
                ('year', models.CharField(max_length=10, blank=True)),
                ('child_count', models.IntegerField(null=True, blank=True)),
                ('book_lang', models.CharField(max_length=50, blank=True)),
                ('academic_year', models.ForeignKey(to='schools.AcademicYear')),
                ('boundary', models.ForeignKey(to='schools.Boundary')),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryLibLevelAgg',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('class_name', models.IntegerField(null=True, db_column='class', blank=True)),
                ('month', models.CharField(max_length=10, blank=True)),
                ('year', models.CharField(max_length=10, blank=True)),
                ('child_count', models.IntegerField(null=True, blank=True)),
                ('book_level', models.CharField(max_length=50, blank=True)),
                ('academic_year', models.ForeignKey(to='schools.AcademicYear')),
                ('boundary', models.ForeignKey(to='schools.Boundary')),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
