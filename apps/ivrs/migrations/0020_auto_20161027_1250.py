# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations

from ivrs.models import State, QuestionGroupType

def forwards_func(apps, schema_editor):
    states = State.objects.all()
    for state in states:
        if state.ivrs_type == 'gka':
            qg_type = QuestionGroupType.objects.get(name='gkav1')
            state.qg_type = qg_type
            state.save()
        elif state.ivrs_type == 'gka-new':
            qg_type = QuestionGroupType.objects.get(name='gkav2')
            state.qg_type = qg_type
            state.save()
        elif state.ivrs_type == 'gka-v3':
            qg_type = QuestionGroupType.objects.get(name='gkav3')
            state.qg_type = qg_type
            state.save()
        elif state.ivrs_type == 'gka-sms':
            qg_type = QuestionGroupType.objects.get(name='gkav4')
            state.qg_type = qg_type
            state.save()
        elif state.ivrs_type == 'ivrs-pri':
            qg_type = QuestionGroupType.objects.get(name='prischoolv1')
            state.qg_type = qg_type
            state.save()
        else:
            pass

def reverse_func(apps, schema_editor):
    states = State.objects.all()
    for state in states:
        state.qg_type = None
        state.save()


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0019_state_qg_type'),
    ]

    operations = [
        migrations.RunPython(forwards_func, reverse_func),
    ]
