# encoding: utf8
from django.db import models, migrations
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('auth', '__first__'),
        ('users', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('password', models.CharField(max_length=128, verbose_name=u'password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name=u'last login')),
                ('is_superuser', models.BooleanField(default=False, help_text=u'Designates that this user has all permissions without explicitly assigning them.', verbose_name=u'superuser status')),
                ('email', models.EmailField(unique=True, max_length=75)),
                ('mobile_no', models.CharField(max_length=32)),
                ('first_name', models.CharField(max_length=64, blank=True)),
                ('last_name', models.CharField(max_length=64, blank=True)),
                ('email_verification_code', models.CharField(max_length=128)),
                ('sms_verification_pin', models.IntegerField(max_length=16)),
                ('is_email_verified', models.BooleanField(default=False)),
                ('is_mobile_verified', models.BooleanField(default=False)),
                ('type', models.IntegerField(choices=[(0, 'Volunteer'), (1, 'Developer'), (2, 'OrganizationManager')])),
                ('changed', models.DateTimeField(null=True, editable=False)),
                ('created', models.DateTimeField(null=True, editable=False)),
                ('groups', models.ManyToManyField(to='auth.Group', verbose_name=u'groups', blank=True)),
                ('user_permissions', models.ManyToManyField(to='auth.Permission', verbose_name=u'user permissions', blank=True)),
            ],
            options={
                u'abstract': False,
            },
            bases=(models.Model,),
        ),
    ]
