from django.db import models
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser,\
    PermissionsMixin
from schools.models import School

USER_TYPE_CHOICES = (
    (0, 'Volunteer'),
    (1, 'Developer'),
    (2, 'OrganizationManager'),
)

ACTIVITY_STATUS_CHOICES = (
    (0, 'Pending'),
    (1, 'Cancelled'),
    (2, 'Completed')
)

class KLPUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    mobile_no = models.CharField(max_length=32) #Better field type to use?
    first_name = models.CharField(max_length=64, blank=True)
    last_name = models.CharField(max_length=64, blank=True)
    email_verification_code = models.CharField(max_length=128)
    sms_verification_pin = models.IntegerField(max_length=16)
    is_email_verified = models.BooleanField(default=False)
    is_mobile_verified = models.BooleanField(default=False)
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
    url = models.URLField(blank=True)
    email = models.EmailField()
    address = models.TextField(blank=True)
    contact_name = models.CharField(max_length=256)

    def __unicode__(self):
        return self.name


class VolunteerActivityType(models.Model):
    name = models.CharField(max_length=64)
    image = models.ImageField(upload_to='activity_type_images')
    text = models.TextField(blank=True)

    def __unicode__(self):
        return self.name


class DonationType(models.Model):
    name = models.CharField(max_length=64)
    image = models.ImageField(upload_to='donation_type_images')
    text = models.TextField(blank=True)

    def __unicode__(self):
        return self.name    


class VolunteerActivity(models.Model):
    organization = models.ForeignKey('Organization')
    date = models.DateField()
    type = models.ForeignKey('VolunteerActivityType')
    school = models.ForeignKey(School)
    text = models.TextField(blank=True)


class DonorRequirement(models.Model):
    organization = models.ForeignKey('Organization')
    type = models.ForeignKey('DonationType')
    school = models.ForeignKey(School)
    text = models.TextField(blank=True)


class VolunteerVolunteerActivity(models.Model):
    volunteer = models.ForeignKey('Volunteer')
    activity = models.ForeignKey('VolunteerActivity')
    status = models.IntegerField(choices=ACTIVITY_STATUS_CHOICES, default=0)


class VolunteerDonorRequirement(models.Model):
    volunteer = models.ForeignKey('Volunteer')
    donor_requirement = models.ForeignKey('DonorRequirement')
    date = models.DateField()
    donation = models.CharField(max_length=256) #what was donated
    #Q: Do we need a 'status' of donation to keep track of whether items were delivered, etc?