# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0014_auto_20140620_1656'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='is_active',
            field=models.BooleanField(default=True, help_text=b'Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name=b'active'),
            preserve_default=True,
        ),
        migrations.AlterUniqueTogether(
            name='userorganization',
            unique_together=set([(b'user', b'organization')]),
        ),
        migrations.AlterUniqueTogether(
            name='uservolunteeractivity',
            unique_together=set([(b'user', b'activity')]),
        ),
    ]
