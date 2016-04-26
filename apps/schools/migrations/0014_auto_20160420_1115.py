# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0013_locality_gram_panchayat'),
    ]

    operations = [
        migrations.RunSQL(
            'alter table tb_boundary add column dise_slug text',
            'alter table tb_boundary drop column dise_slug',
        ),
        migrations.RunSQL(
            'create index on tb_boundary(dise_slug)',
            'drop index tb_boundary_dise_slug_idx'
        )
    ]
