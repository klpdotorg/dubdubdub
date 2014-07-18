# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0015_auto_20140715_1431'),
    ]

    operations = [
        migrations.AddField(
            model_name='organization',
            name='logo',
            field=models.ImageField(default='', upload_to=b'organization_logos', blank=True),
            preserve_default=False,
        ),
    ]
