# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0021_organization_slug'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='uservolunteeractivity',
            options={'verbose_name_plural': 'User-Volunteer Activities'},
        ),
        migrations.AlterModelOptions(
            name='volunteeractivity',
            options={'verbose_name_plural': 'Volunteer Activities'},
        ),
        migrations.AddField(
            model_name='user',
            name='about',
            field=models.TextField(default='', help_text=b'Short blurb / about text', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='fb_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='image',
            field=models.ImageField(default='', upload_to=b'profile_pics', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='opted_email',
            field=models.BooleanField(default=False, help_text=b'Opted in to receive emails'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='user',
            name='photos_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='twitter_handle',
            field=models.CharField(default='', max_length=255, blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='website',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='user',
            name='youtube_url',
            field=models.URLField(default='', blank=True),
            preserve_default=False,
        ),
    ]
