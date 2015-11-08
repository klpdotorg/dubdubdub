# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0009_locality_schoolgis'),
    ]

    operations = [
        migrations.RunSQL(
            'insert into schools_locality (school_id, assembly, parliament, pincode) select id, assembly_id, parliament_id, pin_id from mvw_school_details',
            'truncate table schools_locality restart identity'
        )
    ]
