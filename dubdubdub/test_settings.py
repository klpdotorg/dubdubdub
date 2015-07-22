from settings import *

# TEST_RUNNER = 'common.testrunner.NoDbTestRunner'

# DATABASES = {
#     'default': {
#         'ENGINE': 'django.contrib.gis.db.backends.postgis',
#         'NAME': 'test_klpwww_ver4',
#         'USER': 'klp',
#         'PASSWORD': 'klp',
#         'HOST': '',
#         'PORT': '',
#     }
# }

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
