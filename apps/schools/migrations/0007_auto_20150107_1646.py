# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0006_auto_20150107_1605'),
    ]

    operations = [
        migrations.RunSQL(
            'alter table tb_institution_agg rename id to sid;',
            'alter table tb_institution_agg rename sid to id;'
        )
    ]
