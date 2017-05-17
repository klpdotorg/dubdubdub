# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0020_studentsv2'),
    ]

    operations = [
        migrations.CreateModel(
            name='SchoolProgrammes',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('programme', models.ForeignKey(related_name='schools', to='schools.Programme')),
                ('school', models.ForeignKey(related_name='programmes', to='schools.School')),
            ],
            options={
                'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
