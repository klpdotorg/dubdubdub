# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0019_auto_20140909_1253'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='donationitemcategory',
            options={'verbose_name_plural': 'Donation item categories'},
        ),
        migrations.AddField(
            model_name='volunteeractivitytype',
            name='color',
            field=models.CharField(default='red', max_length=64, choices=[(b'red', b'Red'), (b'green', b'Green'), (b'purple', b'Purple')]),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='donationitem',
            name='requirement',
            field=models.ForeignKey(related_name=b'items', to='users.DonationRequirement'),
        ),
    ]
