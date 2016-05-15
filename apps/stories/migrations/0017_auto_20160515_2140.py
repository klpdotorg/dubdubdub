# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0016_auto_20160515_2119'),
    ]

    operations = [
        migrations.AlterField(
            model_name='survey',
            name='partner',
            field=models.ForeignKey(blank=True, to='users.Organization', null=True),
            preserve_default=True,
        ),
    ]
