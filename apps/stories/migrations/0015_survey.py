# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0014_auto_20160420_1115'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('stories', '0014_auto_20160503_1351'),
    ]

    operations = [
        migrations.CreateModel(
            name='Survey',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created_at', models.DateTimeField(default=django.utils.timezone.now, auto_now_add=True)),
                ('updated_at', models.DateTimeField(default=django.utils.timezone.now, auto_now=True)),
                ('is_active', models.BooleanField(default=False)),
                ('end_date', models.DateField(null=True, blank=True)),
                ('start_date', models.DateField(null=True, blank=True)),
                ('name', models.CharField(max_length=150, null=True, blank=True)),
                ('partner', models.CharField(max_length=150, null=True, blank=True)),
                ('created_by', models.ForeignKey(blank=True, to=settings.AUTH_USER_MODEL, null=True)),
                ('school_type', models.ForeignKey(db_column='school_type', blank=True, to='schools.BoundaryType', null=True)),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
