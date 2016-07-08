from __future__ import unicode_literals

### Start common choices definitions

STATUS_CHOICES = (
    (0, 'Deleted'),
    (1, 'Inactive'),
    (2, 'Active')
)

CAT_CHOICES = (
    ('Model Primary', 'Model Primary'),
    ('Anganwadi', 'Anganwadi'),
    ('Lower Primary', 'Lower Primary'),
    ('Secondary', 'Secondary'),
    ('Akshara Balwadi', 'Akshara Balwadi'),
    ('Independent Balwadi', 'Independent Balwadi'),
    ('Upper Primary', 'Upper Primary'),
)

MGMT_CHOICES = (
    ('p-a', 'Private Aided'),
    ('ed', 'Department of Education'),
    ('p-ua', 'Private Unaided'),
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

ALLOWED_GENDER_CHOICES = (
    ('boys', 'Boys'),
    ('girls', 'Girls'),
    ('co-ed', 'Co-education')
)
