# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('schools', '0017_schoolaggregation'),
        ('users', '0002_user')
    ]

    operations = [
        migrations.CreateModel(
            name='BoundaryUsers',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('boundary', models.ForeignKey(to='schools.Boundary')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AlterUniqueTogether(
            name='boundaryusers',
            unique_together=set([('user', 'boundary')]),
        ),
    ]
