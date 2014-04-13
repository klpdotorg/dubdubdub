from __future__ import unicode_literals
from django.contrib.gis.db import models


### Start common choices definitions

CAT_CHOICES = (
    ('Model Primary', 'Model Primary'),
    ('Anganwadi', 'Anganwadi'),
    ('Lower Primary', 'Lower Primary'),
    ('Secondary', 'Secondary'),
    ('Akshara Balwadi', 'Akshara Balwadi'),
    ('Independent Balwadi', 'Independent Balwadi'),
    ('Upper Primary', 'Upper Primary'),
)

#FIXME: Add mgmt choices from DISE list, @BibhasC
#FIXME: change verbose names to something nicer
MGMT_CHOICES = (
    ('p-a', 'p-a'),
    ('ed', 'ed'),
    ('p-ua', 'p-ua'),
)

MT_CHOICES = (
    ('bengali', 'Bengali'),
    ('english', 'English'),
    ('gujarathi', 'Gujarathi'),
    ('hindi', 'Hindi'),
    ('kannada', 'Kannada'),
    ('konkani', 'Konkani'),
    ('malayalam', 'Malayalam'),
    ('marathi', 'Marathi'),
    ('nepali', 'Nepali'),
    ('oriya', 'Oriya'),
    ('sanskrit', 'Sanskrit'),
    ('sindhi', 'Sindhi'),
    ('tamil', 'Tamil'),
    ('telugu', 'Telugu'),
    ('urdu', 'Urdu'),
    ('multi lng', 'Multi Lingual'),
    ('other', 'Other'),
    ('not known', 'Not known'),
)

SEX_CHOICES = (
    ('male', 'Male'),
    ('female', 'Female'),
)

### End common choices definitions


class BaseModel(models.Model):
    '''
    Base model class for all models
    '''

    class Meta:
        abstract = True


class BaseGeoModel(BaseModel):
    '''
    Base model class for all 'geo' models
    '''

    class Meta:
        abstract = True