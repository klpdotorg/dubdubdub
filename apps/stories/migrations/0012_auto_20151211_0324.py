# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0011_auto_20150530_2311'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='story',
            options={'ordering': ['-date_of_visit'], 'verbose_name_plural': 'Stories'},
        ),
        migrations.AlterField(
            model_name='usertype',
            name='name',
            field=models.CharField(default='VR', max_length=2, choices=[('PR', 'Parents'), ('TR', 'Teachers'), ('VR', 'Volunteer'), ('CM', 'CBO_Member'), ('HM', 'Headmaster'), ('SM', 'SDMC_Member'), ('LL', 'Local Leader'), ('AS', 'Akshara_Staff'), ('EY', 'Educated_Youth'), ('EO', 'Education_Official'), ('ER', 'Elected_Representative')]),
            preserve_default=True,
        ),
    ]
