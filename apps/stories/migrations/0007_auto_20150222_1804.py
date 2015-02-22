# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0006_auto_20141222_2030'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='story',
            options={'ordering': ['-created_at'], 'verbose_name_plural': 'Stories'},
        ),
        migrations.AddField(
            model_name='story',
            name='user_type',
            field=models.CharField(max_length=100, null=True, blank=True),
            preserve_default=True,
        ),
    ]
