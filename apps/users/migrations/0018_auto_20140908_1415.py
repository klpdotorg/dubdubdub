# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0017_auto_20140908_1402'),
    ]

    operations = [
        migrations.CreateModel(
            name='DonationItem',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=256)),
                ('quantity', models.IntegerField(null=True, blank=True)),
                ('unit', models.CharField(max_length=64, blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DonationItemCategory',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=128)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DonationRequirement',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('description', models.TextField(blank=True)),
                ('end_date', models.DateField(null=True)),
                ('organization', models.ForeignKey(to='users.Organization')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='UserDonationItem',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('quantity', models.IntegerField(null=True, blank=True)),
                ('date', models.DateField()),
                ('completed', models.BooleanField(default=False)),
                ('pickup_address', models.TextField(blank=True)),
                ('donation_item', models.ForeignKey(to='users.DonationItem')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.RemoveField(
            model_name=b'donorrequirement',
            name=b'organization',
        ),
        migrations.RemoveField(
            model_name=b'donorrequirement',
            name=b'school',
        ),
        migrations.RemoveField(
            model_name=b'donorrequirement',
            name=b'type',
        ),
        migrations.DeleteModel(
            name='DonationType',
        ),
        migrations.RemoveField(
            model_name=b'donorrequirement',
            name='users',
        ),
        migrations.RemoveField(
            model_name='userdonorrequirement',
            name='donor_requirement',
        ),
        migrations.DeleteModel(
            name='DonorRequirement',
        ),
        migrations.RemoveField(
            model_name='userdonorrequirement',
            name='user',
        ),
        migrations.DeleteModel(
            name='UserDonorRequirement',
        ),
        migrations.AddField(
            model_name='donationitem',
            name='category',
            field=models.ForeignKey(to='users.DonationItemCategory'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='donationitem',
            name='requirement',
            field=models.ForeignKey(to='users.DonationRequirement'),
            preserve_default=True,
        ),
    ]
