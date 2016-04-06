# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0011_auto_20151211_0324'),
    ]

    operations = [
        migrations.CreateModel(
            name='BoundaryAssessmentPercentile',
            fields=[
                ('boundary', models.ForeignKey(primary_key=True, db_column='bid', serialize=False, to='schools.Boundary')),
                ('percentile', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'BoundaryAssPercentile',
                'db_table': 'tb_boundary_assessment_percentile',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentPercentile',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('percentile', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssPercentile',
                'db_table': 'tb_institution_assessment_percentile',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='GramPanchayat',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=150)),
                ('assembly_id', models.IntegerField(db_index=True)),
                ('parliament_id', models.IntegerField(db_index=True)),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
