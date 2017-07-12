# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):
    


    def migrate_questionids(apps, schema_editor):
        qdict = {
            'akshara.gka.1': 'do_30085843', 'akshara.gka.7': 'do_30086991', 'akshara.gka.6': 'do_30086990', 'akshara.gka.5': 'do_30086989',
            'akshara.gka.9': 'do_30086993', 'akshara.gka.8': 'do_30086992', 'akshara.gka.3': 'do_30085879', 'akshara.gka.2': 'do_30085847',
            'akshara.gka.4': 'do_30086987', 'akshara.gka.31': 'do_30087122', 'akshara.gka.30': 'do_30087121', 'akshara.gka.33': 'do_30087124',
            'akshara.gka.57': 'do_30086890', 'akshara.gka.56': 'do_30086888', 'akshara.gka.55': 'do_30086887', 'akshara.gka.54': 'do_30087482',
            'akshara.gka.53': 'do_30086844', 'akshara.gka.52': 'do_30086842', 'akshara.gka.51': 'do_30086828', 'akshara.gka.50': 'do_30086824',
            'akshara.gka.59': 'do_30086910', 'akshara.gka.58': 'do_30086893', 'akshara.gka.22': 'do_30087010', 'akshara.gka.23': 'do_30086574',
            'akshara.gka.20': 'do_30087008', 'akshara.gka.21': 'do_30087009', 'akshara.gka.26': 'do_30087104', 'akshara.gka.27': 'do_30087106',
            'akshara.gka.24': 'do_30086616', 'akshara.gka.25': 'do_30086618', 'akshara.gka.28': 'do_30087110', 'akshara.gka.29': 'do_30087119',
            'akshara.gka.32': 'do_30087123', 'akshara.gka.35': 'do_30087128', 'akshara.gka.34': 'do_30087127', 'akshara.gka.37': 'do_30087135',
            'akshara.gka.36': 'do_30087132', 'akshara.gka.39': 'do_30087237', 'akshara.gka.38': 'do_30087139', 'akshara.gka.84': 'do_30087386',
            'akshara.gka.85': 'do_30087388', 'akshara.gka.86': 'do_30087391', 'akshara.gka.87': 'do_30087393', 'akshara.gka.80': 'do_30087377',
            'akshara.gka.81': 'do_30087379', 'akshara.gka.82': 'do_30087381', 'akshara.gka.83': 'do_30087384', 'akshara.gka.88': 'do_30086249',
            'akshara.gka.89': 'do_30086272', 'akshara.gka.93': 'do_30086341', 'akshara.gka.92': 'do_30086329', 'akshara.gka.91': 'do_30086288',
            'akshara.gka.90': 'do_30087014', 'akshara.gka.97': 'do_30087060', 'akshara.gka.96': 'do_30087029', 'akshara.gka.95': 'do_30087017',
            'akshara.gka.94': 'do_30086346', 'akshara.gka.19': 'do_30087007', 'akshara.gka.18': 'do_30087006', 'akshara.gka.13': 'do_30086997',
            'akshara.gka.12': 'do_30086996', 'akshara.gka.11': 'do_30086995', 'akshara.gka.10': 'do_30086994', 'akshara.gka.17': 'do_30087005',
            'akshara.gka.16': 'do_30087000', 'akshara.gka.15': 'do_30086999', 'akshara.gka.14': 'do_30086998', 'akshara.gka.68': 'do_30087334',
            'akshara.gka.69': 'do_30087321', 'akshara.gka.66': 'do_30087712', 'akshara.gka.67': 'do_30087336', 'akshara.gka.64': 'do_30087697',
            'akshara.gka.65': 'do_30087705', 'akshara.gka.62': 'do_30087687', 'akshara.gka.63': 'do_30087693', 'akshara.gka.60': 'do_30086913',
            'akshara.gka.61': 'do_30086916', 'akshara.gka.79': 'do_30087375', 'akshara.gka.78': 'do_30087373', 'akshara.gka.75': 'do_30087366',
            'akshara.gka.74': 'do_30087364', 'akshara.gka.77': 'do_30087371', 'akshara.gka.76': 'do_30087368', 'akshara.gka.71': 'do_30087357',
            'akshara.gka.70': 'do_30087331', 'akshara.gka.73': 'do_30087362', 'akshara.gka.72': 'do_30087359', 'akshara.gka.48': 'do_30086221',
            'akshara.gka.49': 'do_30086661', 'akshara.gka.40': 'do_30087238', 'akshara.gka.41': 'do_30087239', 'akshara.gka.42': 'do_30087240',
            'akshara.gka.43': 'do_30087241', 'akshara.gka.44': 'do_30086205', 'akshara.gka.45': 'do_30086209', 'akshara.gka.46': 'do_30086214',
            'akshara.gka.47': 'do_30086217'
        }
        AssessmentsV2 = apps.get_model('schools', 'AssessmentsV2')
        for old_qid in qdict:
            AssessmentsV2.objects.filter(question_id=old_qid).update(question_id=qdict[old_qid])

    dependencies = [
        ('schools', '0022_auto_20170602_0617'),
    ]

    operations = [
        migrations.RunPython(migrate_questionids),
    ]
