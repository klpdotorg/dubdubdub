# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0025_auto_20141202_1830'),
    ]

    operations = [
        migrations.AlterField(
            model_name='donationrequirement',
            name='end_date',
            field=models.DateField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
