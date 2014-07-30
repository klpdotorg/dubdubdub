from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser,\
    PermissionsMixin
from rest_framework.authtoken.models import Token
from schools.models import School
import uuid
import random
import datetime

USER_TYPE_CHOICES = (
    (0, 'Volunteer'),
    (1, 'Developer'),
    (2, 'OrganizationManager'),
)

STATUS_CHOICES = (
    (0, 'Pending'),
    (1, 'Cancelled'),
    (2, 'Completed')
)


class UserManager(BaseUserManager):

    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Users must have an email address')

        user = self.model(
            email=UserManager.normalize_email(email),
            **extra_fields
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        user = self.create_user(email, password=password, **extra_fields)
        user.is_admin = True
        user.save(using=self._db)
        return user

   # def delete_user(self, email)



class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)

    #Better field type to use?
    mobile_no = models.CharField(max_length=32, blank=True)
    first_name = models.CharField(max_length=64, blank=True)
    last_name = models.CharField(max_length=64, blank=True)
    email_verification_code = models.CharField(max_length=128)
    sms_verification_pin = models.IntegerField(max_length=16)
    is_email_verified = models.BooleanField(default=False)
    is_mobile_verified = models.BooleanField(default=False)
    #type = models.IntegerField(choices=USER_TYPE_CHOICES, default=0)
    changed = models.DateTimeField(null=True, editable=False)
    created = models.DateTimeField(null=True, editable=False)
    is_active = models.BooleanField('active', default=True,
        help_text='Designates whether this user should be treated as '
                    'active. Unselect this instead of deleting accounts.')

    objects = UserManager()
    USERNAME_FIELD = 'email'

    def save(self, *args, **kwargs):
        if not self.id:
            self.created = datetime.datetime.today()
            self.generate_email_token()
            self.generate_sms_pin()
        self.changed = datetime.datetime.today()
        if self.created is None:
            self.created = self.changed
        super(User, self).save(*args, **kwargs)

    def generate_email_token(self):
        token = uuid.uuid4().get_hex()
        self.email_verification_code = token

    def generate_sms_pin(self):
        pin = ''.join([str(random.choice(range(1, 9))) for i in range(4)])
        self.sms_verification_pin = int(pin)

    def get_token(self):
        return Token.objects.get(user=self).key

    def __unicode__(self):
        return self.email


@receiver(post_save, sender=User)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)


#Q: should these models go into a separate app?
class Organization(models.Model):
    name = models.CharField(max_length=128)
    url = models.URLField(blank=True)
    logo = models.ImageField(upload_to='organization_logos', blank=True)
    email = models.EmailField()
    address = models.TextField(blank=True)
    contact_name = models.CharField(max_length=256)
    users = models.ManyToManyField('User', through='UserOrganization')

    def has_read_perms(self, user):
        '''
            A user has read permmissions on the org if they are admin,
            manager or member
        '''
        if not user.is_authenticated():
            return False
        if user.is_superuser:
            return True
        if UserOrganization.objects.filter(user=user, organization=self)\
                .count() > 0:
            return True
        else:
            return False

    def has_write_perms(self, user):
        '''
            Only admin users have write perms on the organization
        '''
        if not user.is_authenticated():
            return False
        if user.is_superuser:
            return True
        if UserOrganization.objects.filter(user=user,
                                           organization=self,
                                           role=0).count() > 0:
            return True
        else:
            return False

    def __unicode__(self):
        return self.name

USER_ROLE_CHOICES = (
    (0, 'admin'),
    (1, 'manager'),
    (2, 'member')
)


class UserOrganization(models.Model):
    user = models.ForeignKey('User')
    organization = models.ForeignKey('Organization')
    role = models.IntegerField(choices=USER_ROLE_CHOICES)

    class Meta:
        unique_together = ('user', 'organization',)


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
    users = models.ManyToManyField('User', through='UserVolunteerActivity')


class DonorRequirement(models.Model):
    organization = models.ForeignKey('Organization')
    type = models.ForeignKey('DonationType')
    school = models.ForeignKey(School)
    text = models.TextField(blank=True)
    users = models.ManyToManyField('User', through='UserDonorRequirement')


class UserVolunteerActivity(models.Model):
    user = models.ForeignKey('User')
    activity = models.ForeignKey('VolunteerActivity')
    status = models.IntegerField(choices=STATUS_CHOICES, default=0)

    class Meta:
        unique_together = ('user', 'activity',)


class UserDonorRequirement(models.Model):
    user = models.ForeignKey('User')
    donor_requirement = models.ForeignKey('DonorRequirement')
    date = models.DateField()

    #what was donated
    donation = models.CharField(max_length=256)
    status = models.IntegerField(choices=STATUS_CHOICES, default=0)
