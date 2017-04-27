# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0021_auto_20160523_2237'),
    ]

    operations = [
        migrations.AlterField(
            model_name='usertype',
            name='name',
            field=models.CharField(default='VR', max_length=2, choices=[('PR', 'Parents'), ('CH', 'Children'), ('TR', 'Teachers'), ('VR', 'Volunteer'), ('CM', 'CBO_Member'), ('HM', 'Headmaster'), ('SM', 'SDMC_Member'), ('LL', 'Local Leader'), ('AS', 'Akshara_Staff'), ('EY', 'Educated_Youth'), ('EO', 'Education_Official'), ('ER', 'Elected_Representative')]),
            preserve_default=True,
        ),
    ]
