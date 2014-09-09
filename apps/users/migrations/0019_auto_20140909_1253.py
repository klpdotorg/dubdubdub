# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '__first__'),
        ('users', '0018_auto_20140908_1415'),
    ]

    operations = [
        migrations.RenameField(
            model_name='userdonationitem',
            old_name='pickup_address',
            new_name='notes',
        ),
        migrations.RemoveField(
            model_name='userdonationitem',
            name='completed',
        ),
        migrations.AddField(
            model_name='donationitem',
            name='description',
            field=models.TextField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='donationitem',
            name='users',
            field=models.ManyToManyField(to=settings.AUTH_USER_MODEL, through='users.UserDonationItem'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='donationrequirement',
            name='school',
            field=models.ForeignKey(default=3537, to='schools.School'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='donationrequirement',
            name='title',
            field=models.CharField(default='', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='userdonationitem',
            name='status',
            field=models.IntegerField(default=0, choices=[(0, b'New'), (1, b'In Progress'), (2, b'Completed'), (3, b'Cancelled')]),
            preserve_default=True,
        ),
    ]
