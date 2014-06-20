# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('users', '0012_auto_20140620_1649'),
    ]

    operations = [
        migrations.CreateModel(
            name='UserDonorRequirement',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('date', models.DateField()),
                ('donation', models.CharField(max_length=256)),
                ('status', models.IntegerField(default=0, choices=[(0, b'Pending'), (1, b'Cancelled'), (2, b'Completed')])),
                ('donor_requirement', models.ForeignKey(to='users.DonorRequirement', to_field='id')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL, to_field='id')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='UserVolunteerActivity',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('status', models.IntegerField(default=0, choices=[(0, b'Pending'), (1, b'Cancelled'), (2, b'Completed')])),
                ('activity', models.ForeignKey(to='users.VolunteerActivity', to_field='id')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL, to_field='id')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='donorrequirement',
            name='users',
            field=models.ManyToManyField(to=settings.AUTH_USER_MODEL, through='users.UserDonorRequirement'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='volunteeractivity',
            name='users',
            field=models.ManyToManyField(to=settings.AUTH_USER_MODEL, through='users.UserVolunteerActivity'),
            preserve_default=True,
        ),
    ]
