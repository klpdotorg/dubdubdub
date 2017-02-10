# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations

from stories.models import Questiongroup
from ivrs.models import QuestionGroupType, IncomingNumber

PRI = "08039236431"
PRE = "08039510414"
GKA_DEV = "08039510185"
GKA_SMS = "08039514048"
GKA_SERVER = "08039591332"

def forwards_func(apps, schema_editor):
    '''We are populating:

    1. IncomingNumber data for the numbers we have. We will populate
    the corresponding qg_type for the ones that we have and leave the
    others' qg_type blank.

    2. Versions 2, 3, 4 and 5 of IVRS. Version 1 was populated just to
    import Mahiti data. 1 was re-implemented to V-3 for Primary School
    and not implemented for Pre School.

    3. Version 1 of SMS. 'coz that's all that we have for SMS.

    '''

    GKA_IVRS_SERVER, created = IncomingNumber.objects.get_or_create(
        name="gka_ivrs_server",
        number=GKA_SERVER
    )

    GKA_IVRS_DEV, created = IncomingNumber.objects.get_or_create(
        name="gka_ivrs_dev",
        number=GKA_DEV
    )

    GKA_SMS_SERVER, created = IncomingNumber.objects.get_or_create(
        name="gka_sms_server",
        number=GKA_SMS
    )

    PRI_SCHOOL_IVRS_SERVER, created = IncomingNumber.objects.get_or_create(
        name="prischool_ivrs_server",
        number=PRI
    )


    # GKA Number 1. Version=2. (Version=1 was already used for
    # Mahiti)
    questiongroup = Questiongroup.objects.get(
        version=2,
        source__name='ivrs'
    )
    QuestionGroupType.objects.get_or_create(
        name='gkav1',
        is_active=False,
        questiongroup=questiongroup
    )

    # GKA Number 2. Version=4. (Version=3 was already used for
    # Primary School IVRS)
    questiongroup = Questiongroup.objects.get(
        version=4,
        source__name='ivrs'
    )
    QuestionGroupType.objects.get_or_create(
        name='gkav2',
        is_active=False,
        questiongroup=questiongroup
    )

    # GKA Number 3. Version=5.
    questiongroup = Questiongroup.objects.get(
        version=5,
        source__name='ivrs'
    )
    qg_type, created = QuestionGroupType.objects.get_or_create(
        name='gkav3',
        is_active=True,
        questiongroup=questiongroup
    )
    GKA_IVRS_SERVER.qg_type = qg_type
    GKA_IVRS_SERVER.save()

    # Primary School Number 1. Version=3.
    questiongroup = Questiongroup.objects.get(
        version=3,
        source__name='ivrs'
    )
    qg_type, created = QuestionGroupType.objects.get_or_create(
        name='prischoolv1',
        is_active=True,
        questiongroup=questiongroup
    )
    PRI_SCHOOL_IVRS_SERVER.qg_type = qg_type
    PRI_SCHOOL_IVRS_SERVER.save()

    # GKA Number 4. Version=1.
    questiongroup = Questiongroup.objects.get(
        version=1,
        source__name='sms'
    )
    qg_type, created = QuestionGroupType.objects.get_or_create(
        name='gkav4',
        is_active=True,
        questiongroup=questiongroup
    )
    GKA_SMS_SERVER.qg_type = qg_type
    GKA_SMS_SERVER.save()


def reverse_func(apps, schema_editor):
    QuestionGroupType.objects.all().delete()
    IncomingNumber.objects.all().delete()


class Migration(migrations.Migration):

    dependencies = [
        ('ivrs', '0017_auto_20161027_1205'),
    ]

    operations = [
        migrations.RunPython(forwards_func, reverse_func),
    ]
