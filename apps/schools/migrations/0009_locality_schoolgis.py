# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.contrib.gis.db.models.fields


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0008_meetingreport'),
    ]

    operations = [
        migrations.CreateModel(
            name='SchoolGIS',
            fields=[
                ('code', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=150)),
                ('centroid', django.contrib.gis.db.models.fields.PointField(srid=4326)),
            ],
            options={
                'db_table': 'mvw_gis_master',
                'managed': False,
            },
            bases=(models.Model,),
        ),

        # The migration says that assembly, parliament and pincode are integer
        # fields because they actually are. Those tables are materialized views
        # hence can't be foreign key-ed. So we're creating them as indexed
        # integer fields and then just updating model code to trick django into
        # thinking that they are foreign keys.
        migrations.CreateModel(
            name='Locality',
            fields=[
                ('school', models.ForeignKey(primary_key=True, serialize=False, to='schools.School')),
                ('assembly', models.IntegerField(db_index=True, null=True, blank=True)),
                ('parliament', models.IntegerField(db_index=True, null=True, blank=True)),
                ('pincode', models.IntegerField(db_index=True, null=True, blank=True)),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
