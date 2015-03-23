# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('schools', '__first__'),
        ('users', '0002_user'),
        ('stories', '0002_auto_20141113_0157'),
    ]

    operations = [
        migrations.RunPython(lambda apps, schema_editor: None),
        migrations.CreateModel(
            name='Story',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('is_verified', models.BooleanField(default=False)),
                ('name', models.CharField(max_length=100, blank=True)),
                ('email', models.CharField(max_length=100, blank=True)),
                ('date', models.CharField(max_length=50, blank=True)),
                ('telephone', models.CharField(max_length=50, blank=True)),
                ('entered_timestamp', models.DateTimeField(auto_now_add=True, null=True)),
                ('comments', models.CharField(max_length=2000, blank=True)),
                ('sysid', models.IntegerField(null=True, blank=True)),
                ('group', models.ForeignKey(to='stories.Questiongroup')),
                ('school', models.ForeignKey(to='schools.School')),
                ('user', models.ForeignKey(blank=True, to=settings.AUTH_USER_MODEL, null=True)),
            ],
            options={
                'ordering': ['-entered_timestamp'],
                'db_table': 'stories_story',
                'verbose_name_plural': 'Stories',
            },
            bases=(models.Model,),
        ),
    ]
