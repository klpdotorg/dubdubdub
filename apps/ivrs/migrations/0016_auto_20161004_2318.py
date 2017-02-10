# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations

from stories.models import Question, Questiongroup

def forwards_func(apps, schema_editor):
    question_group = Questiongroup.objects.get(
        version=1,
        source__name='sms'
    )
    questions = question_group.questions.all().order_by(
        'questiongroupquestions__sequence'
    )
    for question in questions:
        question.options = "{'Yes','No','Unknown'}"
        question.save()

def reverse_func(apps, schema_editor):
    question_group = Questiongroup.objects.get(
        version=1,
        source__name='sms'
    )
    questions = question_group.questions.all().order_by(
        'questiongroupquestions__sequence'
    )
    for question in questions[1:]:
        question.options = "{'Yes','No'}"
        question.save()


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0015_auto_20161003_1113'),
        ('stories', '0021_auto_20160523_2237'),
    ]

    operations = [
        migrations.RunPython(forwards_func, reverse_func),
    ]
