DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'dubdubdub',
        'USER': 'klp',
        'PASSWORD': 'klp',
        'HOST': '127.0.0.1',
        'PORT': '5432',
        'OPTIONS': {
            'autocommit': True,
        }
    }
}
