# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0007_auto_20150507_2108'),
    ]

    operations = [
        migrations.CreateModel(
            name='MeetingReport',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('pdf', models.FileField(upload_to='meeting_reports')),
                ('language', models.CharField(max_length=128)),
                ('school', models.ForeignKey(to='schools.School')),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
