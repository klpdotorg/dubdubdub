from settings import *

TEST_RUNNER = 'common.testrunner.NoDbTestRunner'

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'test_klpwww_ver4',
        'USER': 'klp',
        'PASSWORD': 'klp',
        'HOST': '',
        'PORT': '',
    }
}

try:
    from local_test_settings import *
except:
    pass