# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stories', '0024_story_location'),
    ]

    operations = [
        migrations.AlterField(
            model_name='usertype',
            name='name',
            field=models.CharField(default='VR', unique=True, max_length=3, choices=[('PR', 'Parents'), ('CH', 'Children'), ('TR', 'Teachers'), ('VR', 'Volunteer'), ('CM', 'CBO_Member'), ('HM', 'Headmaster'), ('SM', 'SDMC_Member'), ('LL', 'Local Leader'), ('AS', 'Akshara_Staff'), ('EY', 'Educated_Youth'), ('EO', 'Education_Official'), ('ER', 'Elected_Representative'), ('GO', 'Government Official'), ('CRP', 'CRP')]),
            preserve_default=True,
        ),
    ]
