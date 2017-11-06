# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0029_auto_20170825_1217'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='user_type',
            field=models.CharField(blank=True, max_length=50, null=True, choices=[('PR', 'Parents'), ('CH', 'Children'), ('TR', 'Teachers'), ('VR', 'Volunteer'), ('CM', 'CBO_Member'), ('HM', 'Headmaster'), ('SM', 'SDMC_Member'), ('LL', 'Local Leader'), ('AS', 'Akshara_Staff'), ('EY', 'Educated_Youth'), ('EO', 'Education_Official'), ('ER', 'Elected_Representative'), ('GO', 'Government Official'), ('CRP', 'CRP')]),
            preserve_default=True,
        ),
    ]
