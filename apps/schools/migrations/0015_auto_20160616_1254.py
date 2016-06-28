# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0014_auto_20160420_1115'),
    ]

    operations = [
        migrations.RunSQL(
            'ALTER TABLE tb_boundary ADD COLUMN status integer',
            'ALTER TABLE tb_boundary DROP COLUMN status'
        )
    ]
