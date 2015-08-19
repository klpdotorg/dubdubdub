from settings import *

DBNAME = DATABASES['default']['NAME']
USER = DATABASES['default']['USER']
PASSWORD = DATABASES['default']['PASSWORD']
print "Inside test_settings.."
print "Database name:" + DBNAME
print "User name:" + USER
print "Using password from the settings file..."


TEST_RUNNER = 'common.testrunner.NoDbTestRunner'

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'test_' + DBNAME,
        'USER': USER,
        'PASSWORD': PASSWORD,
        'HOST': '',
        'PORT': '',
    }
}

TESTS_STORIES_INPUT = {
    'SCHOOLS_TEST_ID1': '29600'

}

TESTS_ACTIVITIES_INPUT = {
    'ACTIVITY_ID': '4',
    'ORG_ID': '1'
}

try:
    from local_test_settings import *
except:
    pass
