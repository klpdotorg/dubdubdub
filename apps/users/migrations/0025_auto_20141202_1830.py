# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0024_remove_organization_website'),
    ]

    operations = [
        migrations.AddField(
            model_name='donationitemcategory',
            name='image',
            field=models.ImageField(default='', upload_to=b'donation_type_images', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='donationitemcategory',
            name='slug',
            field=models.SlugField(max_length=128, null=True, blank=True),
            preserve_default=True,
        ),
    ]
