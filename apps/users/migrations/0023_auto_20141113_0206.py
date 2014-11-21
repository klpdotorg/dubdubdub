# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0022_auto_20141113_0157'),
    ]

    operations = [
        migrations.AddField(
            model_name='organization',
            name='about',
            field=models.TextField(default='', help_text=b'Short blurb / about text', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='organization',
            name='blog_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='organization',
            name='fb_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='organization',
            name='photos_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='organization',
            name='twitter_handle',
            field=models.CharField(default='', max_length=255, blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='organization',
            name='website',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='organization',
            name='youtube_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
    ]
