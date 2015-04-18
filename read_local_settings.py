#Simple script that reads django settings and returns a value

import sys
from django.conf import settings
import os

# Reads the django settings file and returns the DB name
def parse_local_settings():
    os.environ['DJANGO_SETTINGS_MODULE'] = 'dubdubdub.settings'
    db_properties= settings.DATABASES['default']
    dbName=db_properties['NAME']
    return dbName

#Standard boilerplate main function. Writes the return value of a function to stdout, so it can be read by a shell script
if __name__ == "__main__":  
    sys.stdout.write(parse_local_settings())


