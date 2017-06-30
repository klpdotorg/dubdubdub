# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):
    print """
        PLEASE OPEN schools/migrations/0023_auto_20170630_0642.py 
        and run all the following RunSQL commands on the shell 
        manually. This is because Postgres doesn't allow
        any ALTER TYPE commands to be run in a transaction
        and Django doesn't support turning off transaction
        per migration file in 1.7.
    """

    dependencies = [
        ('schools', '0022_auto_20170602_0617'),
    ]

    operations = [
        # School Management
        # -----------------
        # migrations.RunSQL("ALTER TYPE school_management ADD VALUE 'ur';"),
        # migrations.RunSQL(
        #     "UPDATE pg_enum SET enumlabel = 'central-g' WHERE enumtypid = 'school_management'::regtype AND enumlabel = 'central govt';"),
        # migrations.RunSQL("ALTER TYPE school_management ADD VALUE 'madrasa-r';"),
        # migrations.RunSQL("ALTER TYPE school_management ADD VALUE 'madrasa-ur';"),

        # School MOI
        # ----------
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'bhutia';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'assamese';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'kashmiri';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'manipuri';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'limboo';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'french';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'garo';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'mizo';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'lepcha';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'bodo';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'mising';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'punjabi';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'dogri';"),
        # migrations.RunSQL("ALTER TYPE school_moi ADD VALUE 'khasi';"),        
    ]
