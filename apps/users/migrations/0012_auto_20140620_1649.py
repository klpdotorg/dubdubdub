# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0011_auto_20140618_1956'),
    ]

    operations = [
        migrations.RemoveField(
            model_name=b'organizationmanager',
            name=b'organization',
        ),
        migrations.RemoveField(
            model_name=b'organizationmanager',
            name=b'user',
        ),
        migrations.DeleteModel(
            name='OrganizationManager',
        ),
        migrations.RemoveField(
            model_name=b'volunteer',
            name=b'activities',
        ),
        migrations.RemoveField(
            model_name=b'volunteer',
            name=b'donations',
        ),
        migrations.RemoveField(
            model_name=b'volunteer',
            name=b'user',
        ),
        migrations.RemoveField(
            model_name=b'volunteerdonorrequirement',
            name=b'donor_requirement',
        ),
        migrations.RemoveField(
            model_name=b'volunteerdonorrequirement',
            name=b'volunteer',
        ),
        migrations.DeleteModel(
            name='VolunteerDonorRequirement',
        ),
        migrations.RemoveField(
            model_name=b'volunteervolunteeractivity',
            name=b'activity',
        ),
        migrations.RemoveField(
            model_name=b'volunteervolunteeractivity',
            name=b'volunteer',
        ),
        migrations.DeleteModel(
            name='Volunteer',
        ),
        migrations.DeleteModel(
            name='VolunteerVolunteerActivity',
        ),
        migrations.RemoveField(
            model_name='user',
            name=b'type',
        ),
    ]
