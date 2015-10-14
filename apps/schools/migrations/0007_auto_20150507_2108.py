# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0006_auto_20150107_1605'),
    ]

    operations = [
        migrations.CreateModel(
            name='BoundaryAssessmentSinglescore',
            fields=[
                ('boundary', models.ForeignKey(primary_key=True, db_column='bid', serialize=False, to='schools.Boundary')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
                ('percentile', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'BoundaryAssSingleScore',
                'db_table': 'tb_boundary_assessment_singlescore',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryAssessmentSinglescoreGender',
            fields=[
                ('boundary', models.ForeignKey(primary_key=True, db_column='bid', serialize=False, to='schools.Boundary')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
                ('percentile', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'BoundaryAssSingleScoreGender',
                'db_table': 'tb_boundary_assessment_singlescore_gender',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryAssessmentSinglescoreMt',
            fields=[
                ('boundary', models.ForeignKey(primary_key=True, db_column='bid', serialize=False, to='schools.Boundary')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
                ('percentile', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'BoundaryAssSingleScoreMt',
                'db_table': 'tb_boundary_assessment_singlescore_mt',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentCohorts',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('cohortsnum', models.IntegerField()),
            ],
            options={
                'verbose_name': 'InstAssAggCohorts',
                'db_table': 'tb_institution_assessment_cohorts',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolExtra',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('num_boys', models.IntegerField(null=True, db_column='num_boys', blank=True)),
                ('num_girls', models.IntegerField(null=True, db_column='num_girls', blank=True)),
            ],
            options={
                'db_table': 'mvw_school_extra',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.AlterModelTable(
            name='institutionagg',
            table='mvw_institution_aggregations',
        ),
    ]
