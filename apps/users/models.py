from django.db import models
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser,\
    PermissionsMixin
from schools.models import School

USER_TYPE_CHOICES = (
    (1, 'Volunteer'),
    (2, 'Developer'),
    (3, 'OrganizationManager'),
)

#FIXME: correct activity types?
ACTIVITY_TYPE_CHOICES = (
    (1, 'Play'),
    (2, 'Teach'),
    (3, 'Blahblah')
)

class KLPUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    mobile_no = models.CharField(max_length=32) #Better field type to use?
    first_name = models.CharField(max_length=64, blank=True)
    last_name = models.CharField(max_length=64, blank=True)
    type = models.IntegerField(choices=USER_TYPE_CHOICES)
    changed = models.DateTimeField(null=True, editable=False)
    created = models.DateTimeField(null=True, editable=False)
    USERNAME_FIELD = 'email'

    def save(self, *args, **kwargs):
        if not self.id:
            self.created = datetime.datetime.today()
        self.changed = datetime.datetime.today()
        if self.created == None:
            self.created = self.changed
        super(MyUser, self).save(*args, **kwargs)

    def __unicode__(self):
        return self.email


class Volunteer(models.Model):
    user = models.OneToOneField(KLPUser)
    #Q: should verification apply to all users or only volunteers?
    email_verification_code = models.CharField(max_length=128)
    sms_verification_pin = models.IntegerField(max_length=16)
    is_email_verified = models.BooleanField(default=False)
    is_mobile_verified = models.BooleanField(default=False)
    activities = models.ManyToManyField('VolunteerActivity', through='VolunteerVolunteerActivity')
    donations = models.ManyToManyField('DonorRequirement', through='VolunteerDonorRequirement')


class Developer(models.Model):
    user = models.OneToOneField(KLPUser)
    api_key = models.CharField(max_length=64)


class OrganizationManager(models.Model):
    user = models.OneToOneField(KLPUser)
    organization = models.ForeignKey('Organization')


#Q: should these models go into a separate app?
class Organization(models.Model):
    name = models.CharField(max_length=128)
    #Q: What other fields do we need for orgs?
    def __unicode__(self):
        return self.name


class VolunteerActivity(models.Model):
    organization = models.ForeignKey('Organization')
    date = models.DateField()
    type = models.IntegerField(choices=ACTIVITY_TYPE_CHOICES)
    school = models.ForeignKey(School)
    text = models.TextField(blank=True) #Q: some additional text - do we need this?


class DonorRequirement(models.Model):
    organization = models.ForeignKey('Organization')
    #Q: Do we have DONATION_TYPES or something?
    school = models.ForeignKey(School)
    text = models.TextField(blank=True)


class VolunteerVolunteerActivity(models.Model):
    volunteer = models.ForeignKey('Volunteer')
    activity = models.ForeignKey('VolunteerActivity')
    #Q: What other fields do we need? is_completed?


class VolunteerDonorRequirement(models.Model):
    volunteer = models.ForeignKey('Volunteer')
    donor_requirement = models.ForeignKey('DonorRequirement')
    date = models.DateField() #date of donation
    #Q: what other fields? amount of donation? anything else?