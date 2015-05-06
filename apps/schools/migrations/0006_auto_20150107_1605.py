# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


def fill_years(apps, schema_editor):
    AcademicYear = apps.get_model('schools', 'AcademicYear')
    for year in AcademicYear.objects.all():
        year.from_year, year.to_year = year.name.split('-')
        year.save()


def empty_years(apps, schema_editor):
    AcademicYear = apps.get_model('schools', 'AcademicYear')
    for year in AcademicYear.objects.all():
        year.from_year, year.to_year = '', ''
        year.save()


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0005_auto_20150107_1605'),
    ]

    operations = [
        migrations.RunPython(
            fill_years,  # forward
            empty_years  # backward
        )
    ]
