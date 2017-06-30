# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '0022_auto_20170602_0617'),
    ]

    operations = [
        migrations.RunSQL("ALTER TYPE school_management ADD VALUE 'ur';"),
        migrations.RunSQL(
            "UPDATE pg_enum SET enumlabel = 'central-g' WHERE enumtypid = 'school_management'::regtype AND enumlabel = 'central govt';"),
        migrations.RunSQL("ALTER TYPE school_management ADD VALUE 'madrasa-r';"),
        migrations.RunSQL("ALTER TYPE school_management ADD VALUE 'madrasa-ur';"),

    ]
