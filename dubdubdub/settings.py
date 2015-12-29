import os

DEBUG = False

PROJECT_ROOT = os.path.realpath(os.path.dirname(os.path.dirname(__file__)))

TEMPLATE_DEBUG = DEBUG

ADMINS = (
    ('Dev Team', 'dev@klp.org.in'),
)

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'testpercentile',
        'USER': 'klp',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
    }
}

DATA_IMPORT_DIR = os.path.join(PROJECT_ROOT, 'data')
IVRS_VOICE_FILES_DIR = os.environ.get('IVRS_VOICE_FILES_DIR', None)

DEFAULT_ACADEMIC_YEAR = '2013-2014'

EMAIL_DEFAULT_FROM = 'Karnataka Learning Partnership <dev@klp.org.in>'

TEST_RUNNER = 'common.testrunner.NoDbTestRunner'
# TEST_RUNNER='django.test.runner.DiscoverRunner'
# Hosts/domain names that are valid for this site; required if DEBUG is False
# See https://docs.djangoproject.com/en/1.5/ref/settings/#allowed-hosts
ALLOWED_HOSTS = ['.klp.org.in']

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# In a Windows environment this must be set to your system time zone.
TIME_ZONE = 'Asia/Kolkata'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-us'

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale.
USE_L10N = True

# If you set this to False, Django will not use timezone-aware datetimes.
USE_TZ = False

# Absolute filesystem path to the directory that will hold user-uploaded files.
# Example: "/var/www/example.com/media/"
MEDIA_ROOT = os.path.join(PROJECT_ROOT, 'media')

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash.
# Examples: "http://example.com/media/", "http://media.example.com/"
MEDIA_URL = '/media/'

# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/var/www/example.com/static/"
STATIC_ROOT = os.path.join(PROJECT_ROOT, 'assets', 'collected-static')

# URL prefix for static files.
# Example: "http://example.com/static/", "http://static.example.com/"
STATIC_URL = '/static/'

# Additional locations of static files
STATICFILES_DIRS = (
    os.path.join(PROJECT_ROOT, 'assets', 'static'),
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
)

# List of finder classes that know how to find static files in
# various locations.
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
    'django.contrib.staticfiles.finders.FileSystemFinder',
    # 'django.contrib.staticfiles.finders.DefaultStorageFinder',

    # compressor finder:
    'compressor.finders.CompressorFinder',
)

# Make this unique, creates random key first at first time.
try:
    SECRET_KEY
except NameError:
    SECRET_FILE = os.path.join(PROJECT_ROOT, 'secret.txt')
    try:
        SECRET_KEY = open(SECRET_FILE).read().strip()
    except IOError:
        try:
            from random import choice
            SECRET_KEY = ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)')
                                 for i in range(50)])
            secret = file(SECRET_FILE, 'w')
            secret.write(SECRET_KEY)
            secret.close()
        except IOError:
            Exception('''Please create a %s file with random characters
                      to generate your secret key!''' % SECRET_FILE)


# List of callables that know how to import templates from various sources.
# TEMPLATE_LOADERS = (
#     'django.template.loaders.filesystem.Loader',
#     'django.template.loaders.app_directories.Loader',
# #     'django.template.loaders.eggs.Loader',
# )

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    # Uncomment the next line for simple clickjacking protection:
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    # 'debug_toolbar.middleware.DebugToolbarMiddleware',
)

ROOT_URLCONF = 'dubdubdub.urls'

# Python dotted path to the WSGI application used by Django's runserver.
WSGI_APPLICATION = 'dubdubdub.wsgi.application'

TEMPLATE_DIRS = (
    os.path.join(PROJECT_ROOT, 'templates'),
    # Put strings here, like "/home/html/django_templates"
    # or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
)

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    "django.contrib.gis",
    'suit',
    'compressor',
    'django.contrib.admin',

    # third party
    'django_extensions',
    'rest_framework',
    'rest_framework.authtoken',
    'rest_framework_swagger',

    # in-project
    'common',
    'schools',
    'users',
    'stories',
    'imports',
    'ivrs',
)

from django.conf.global_settings import TEMPLATE_CONTEXT_PROCESSORS as TCP

TEMPLATE_CONTEXT_PROCESSORS = TCP + (
    'django.core.context_processors.request',
)

INTERNAL_IPS = ('127.0.0.1',)
DEBUG_TOOLBAR_CONFIG = {
    'INTERCEPT_REDIRECTS': False
}

AUTH_USER_MODEL = 'users.User'
# AUTHENTICATION_BACKENDS = ('account.backends.ModelEmailBackend', )
# LOGIN_URL = '/login/'
# LOGIN_REDIRECT_URL = '/'

# EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# A sample logging configuration. The only tangible logging
# performed by this configuration is to send an email to
# the site admins on every HTTP 500 error when DEBUG=False.
# See http://docs.djangoproject.com/en/dev/topics/logging for
# more details on how to customize your logging configuration.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'filters': {
        'require_debug_false': {
            '()': 'django.utils.log.RequireDebugFalse'
        }
    },
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'filters': ['require_debug_false'],
            'class': 'django.utils.log.AdminEmailHandler'
        },
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django.request': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': True,
        },
        # Uncomment following to turn on sql logging
        'django.db.backends': {
            'level': 'DEBUG',
            'handlers': ['console'],
        },
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.filebased.FileBasedCache',
        'LOCATION': '/tmp/dubdubdub_cache',
    }
}

# How long will the cache last?
CACHE_TIMEOUT = 60 * 60 * 24

# Should cache be used or not? A: Yes
CACHE_ENABLED = True

# REST Framework config options:
REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': (
        'common.renderers.KLPJSONRenderer',
        'common.renderers.KLPCSVRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.TokenAuthentication',
        # 'rest_framework.authentication.SessionAuthentication',
    ),
    'DEFAULT_FILTER_BACKENDS': (
        'rest_framework.filters.DjangoFilterBackend',
        'rest_framework.filters.SearchFilter',
    ),
}

# Should be used by management commands, etc. to log files
LOGS_FOLDER = os.path.join(PROJECT_ROOT, 'logs',)

TESTS_SCHOOLS_INPUT = {
    'SCHOOLS_LIB_ID': '33312',
    'SCHOOLS_LIB_ID2': '33313',
    'SCHOOL_INFO_ID': '33312',
    'SCHOOL_DEMOGRAPHICS_ID': '33312',
    'SCHOOL_PROGRAMMES_ID': '25139',
    'SCHOOL_FINANCE_ID': '4708',
    'SCHOOL_INFRA_ID': '33141',
}

BLOG_FEED_URL = 'http://blog.klp.org.in/feeds/posts/default?alt=json'

SUIT_CONFIG = {
    'ADMIN_NAME': 'KLP Admin',
}

SWAGGER_SETTINGS = {
    'enabled_methods': ['get', ]
}

try:
    from local_settings import *
except ImportError:
    pass
