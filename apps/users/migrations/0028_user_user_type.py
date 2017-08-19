# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0027_auto_20161221_2124'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='user_type',
            field=models.CharField(blank=True, max_length=50, null=True, choices=[(b'parents', b'Parents'), (b'teachers', b'Teachers'), (b'volunteers', b'Volunteers'), (b'cbo-member', b'CBO Member'), (b'headmaster', b'Headmaster'), (b'sdmc-member', b'SDMC Member'), (b'local-leaders', b'Local Leaders'), (b'akshara-staff', b'Akshara Staff'), (b'educated-staff', b'Educated Staff'), (b'educated-youth', b'Educated Youth'), (b'education-official', b'Education Official'), (b'elected-representative', b'Elected Representative')]),
            preserve_default=True,
        ),
    ]
