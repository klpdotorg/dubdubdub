from django.db import models
from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from django.conf import settings
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser,\
    PermissionsMixin
from rest_framework.authtoken.models import Token
from schools.models import School
import uuid
import random
import datetime

import string
from django.core.mail import send_mail
from django.core.urlresolvers import reverse
from common.utils import send_templated_mail
from django.contrib.sites.models import Site
from django.utils.text import slugify

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
        return super(User, self).save(*args, **kwargs)

    def generate_email_token(self):
        token = uuid.uuid4().get_hex()
        self.email_verification_code = token

    def generate_sms_pin(self):
        pin = ''.join([str(random.choice(range(1, 9))) for i in range(4)])
        self.sms_verification_pin = int(pin)

    def get_token(self):
        return Token.objects.get(user=self).key

    def get_short_name(self):
        return self.first_name or ''

    @property
    def is_staff(self):
        return self.is_superuser

    def send_user_created_verify_email_mail(self):
        email_verification_code = ''.join([random.choice(string.hexdigits) for x in range(32)])
        self.email_verification_code = email_verification_code
        url = reverse('user_email_verify') + '?token={token}&email={email}'.format(
            token=email_verification_code,
            email=self.email
        )

        send_templated_mail(
            from_email=settings.EMAIL_DEFAULT_FROM,
            to_emails=[self.email],
            subject='Please verify your email address',
            template_name='register',
            context={
                'user': self,
                'site_url': Site.objects.get_current().domain,
                'url': url
            }
        )

        self.save()

    def __unicode__(self):
        return self.email


@receiver(post_save, sender=User)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)

@receiver(post_save, sender=User)
def user_created_verify_email(sender, instance=None, created=False, **kwargs):
    if not created:
        return

    instance.send_user_created_verify_email_mail()

#Q: should these models go into a separate app?
class Organization(models.Model):
    name = models.CharField(max_length=128)
    slug = models.SlugField(max_length=128, blank=True, null=True)
    url = models.URLField(blank=True)
    logo = models.ImageField(upload_to='organization_logos', blank=True)
    email = models.EmailField()
    address = models.TextField(blank=True)
    contact_name = models.CharField(max_length=256)
    users = models.ManyToManyField('User', through='UserOrganization')

    def generate_slug(self, regenerate=False):
        if not self.slug or regenerate:
            slug = slugify(self.name)
            if Organization.objects.filter(slug=slug).count() > 0:
                slug = '-'.join([slug, str(random.randint(1, 9))])
            self.slug = slug
        self.save()

    def get_absolute_url(self):
        return reverse('organization_page', kwargs={'pk': self.id})

    def get_manager_emails(self):
        '''
            Get emails (as list) of all addresses management emails should be sent to.
        '''
        org_email = self.email
        users_emails = [u.email for u in self.users.all()]
        return [org_email] + users_emails

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
                                           role__lte=1).count() > 0:
            return True
        else:
            return False

    def __unicode__(self):
        return self.name

@receiver(post_save, sender=Organization)
def generate_slug_if_no_slug(sender, instance=None, created=False, **kwargs):
    if instance.slug:
        return

    instance.generate_slug()


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


TYPE_COLOR_CHOICES = (
    ('red', 'Red'),
    ('green', 'Green'),
    ('purple', 'Purple'),
)

class VolunteerActivityType(models.Model):
    name = models.CharField(max_length=64)
    image = models.ImageField(upload_to='activity_type_images')
    text = models.TextField(blank=True)
    color = models.CharField(choices=TYPE_COLOR_CHOICES, max_length=64)

    def __unicode__(self):
        return self.name


# class DonationType(models.Model):
#     name = models.CharField(max_length=64)
#     image = models.ImageField(upload_to='donation_type_images')
#     text = models.TextField(blank=True)

#     def __unicode__(self):
#         return self.name


class VolunteerActivity(models.Model):
    organization = models.ForeignKey('Organization')
    date = models.DateField()
    type = models.ForeignKey('VolunteerActivityType')
    school = models.ForeignKey(School)
    text = models.TextField(blank=True)
    users = models.ManyToManyField('User', through='UserVolunteerActivity')

    def get_geometry(self):
        return self.school.get_geometry()

# class DonorRequirement(models.Model):
#     organization = models.ForeignKey('Organization')
#     type = models.ForeignKey('DonationType')
#     school = models.ForeignKey(School)
#     text = models.TextField(blank=True)
#     users = models.ManyToManyField('User', through='UserDonorRequirement')


class UserVolunteerActivity(models.Model):
    user = models.ForeignKey('User')
    activity = models.ForeignKey('VolunteerActivity')
    status = models.IntegerField(choices=STATUS_CHOICES, default=0)

    class Meta:
        unique_together = ('user', 'activity',)

    def get_emails(self):
        '''
            Get emails where activity confirmation needs to be sent to
            (user who signed up + all org managers)
        '''
        org_emails = self.activity.organization.get_manager_emails()
        return list(set([self.user.email] + org_emails))

    def send_volunteer_activity_created_mail(self):
        send_templated_mail(
            from_email=settings.EMAIL_DEFAULT_FROM,
            to_emails=self.get_emails(),
            subject='Volunteering with {org} on {date}'.format(
                org=self.activity.organization.name,
                date=self.activity.date
            ),
            template_name='volunteer',
            context={
                'org': self.activity.organization,
                'user': self.user,
                'activity': self.activity,
                'school': self.activity.school,
                'site_url': Site.objects.get_current().domain,
                'school_url': self.activity.school.get_absolute_url()
            }
        )

@receiver(post_save, sender=UserVolunteerActivity)
def volunteer_activity_created(sender, instance=None, created=False, **kwargs):
    if not created:
        return

    instance.send_volunteer_activity_created_mail()

@receiver(pre_save, sender=UserVolunteerActivity)
def status_changed(sender, instance, **kwargs):
    try:
        obj = UserVolunteerActivity.objects.get(pk=instance.pk)
    except UserVolunteerActivity.DoesNotExist:
        pass # Object is new, so field hasn't technically changed, but you may want to do something else here.
    else:
        if not obj.status == instance.status and instance.status == 2: # Status is completed
            send_templated_mail(
                from_email=settings.EMAIL_DEFAULT_FROM,
                to_emails=instance.get_emails(),
                subject='Thank you for volunteering with {org} on {date}'.format(
                    org=instance.activity.organization.name,
                    date=instance.activity.date
                ),
                template_name='volunteer_completed',
                context={
                    'org': instance.activity.organization,
                    'org_url': instance.activity.organization.get_absolute_url(),
                    'user': instance.user,
                    'activity': instance.activity,
                    'school': instance.activity.school,
                    'site_url': Site.objects.get_current().domain,
                    'school_url': instance.activity.school.get_absolute_url(),
                    'volunteer_url': reverse('volunteer_map')
                }
            )

# class UserDonorRequirement(models.Model):
#     user = models.ForeignKey('User')
#     donor_requirement = models.ForeignKey('DonorRequirement')
#     date = models.DateField()

#     #what was donated
#     donation = models.CharField(max_length=256)
#     status = models.IntegerField(choices=STATUS_CHOICES, default=0)

class DonationRequirement(models.Model):
    school = models.ForeignKey(School)
    organization = models.ForeignKey('Organization')
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    end_date = models.DateField(null=True)

    def __unicode__(self):
        return self.description


class DonationItemCategory(models.Model):
    name = models.CharField(max_length=128)

    def __unicode__(self):
        return self.name

    class Meta:
        verbose_name_plural = "Donation item categories"


class DonationItem(models.Model):
    requirement = models.ForeignKey('DonationRequirement', related_name='items')
    name = models.CharField(max_length=256)
    description = models.TextField(blank=True)
    category = models.ForeignKey('DonationItemCategory')
    quantity = models.IntegerField(blank=True, null=True)
    unit = models.CharField(max_length=64, blank=True)
    users = models.ManyToManyField('User', through='UserDonationItem')

    def __unicode__(self):
        return self.name

DONATION_STATUS_CHOICES = (
    (0, 'New'),
    (1, 'In Progress'),
    (2, 'Completed'),
    (3, 'Cancelled'),
)

class UserDonationItem(models.Model):
    user = models.ForeignKey('User')
    donation_item = models.ForeignKey('DonationItem')
    quantity = models.IntegerField(blank=True, null=True)
    date = models.DateField()
    status = models.IntegerField(choices=DONATION_STATUS_CHOICES, default=0)
    notes = models.TextField(blank=True)
