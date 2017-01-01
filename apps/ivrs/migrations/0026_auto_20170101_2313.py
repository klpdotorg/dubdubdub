# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations


def forwards_func(apps, schema_editor):
    State = apps.get_model("ivrs", "State")
    User = apps.get_model("users", "User")

    states = State.objects.all()
    for state in states:
        try:
            # Trimming the starting 0. Have checked to make sure
            # all telephones on the State table have 11 digits
            # including the 0 at the beginning.
            user = User.objects.get(mobile_no=state.telephone[1:])
        except:
            continue
        state.user = user
        state.save()

def reverse_func(apps, schema_editor):
    State = apps.get_model("ivrs", "State")

    states = State.objects.all()
    for state in states:
        state.user = None
        state.save()


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0025_state_user'),
    ]

    operations = [
        migrations.RunPython(forwards_func, reverse_func),
    ]
