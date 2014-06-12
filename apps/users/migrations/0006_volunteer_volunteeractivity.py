# encoding: utf8
from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        ('schools', '__first__'),
        ('users', '0005_donorrequirement'),
    ]

    operations = [
        migrations.CreateModel(
            name='VolunteerActivity',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('organization', models.ForeignKey(to='users.Organization', to_field=u'id')),
                ('date', models.DateField()),
                ('type', models.ForeignKey(to='users.VolunteerActivityType', to_field=u'id')),
                ('school', models.ForeignKey(to='schools.School', to_field='id')),
                ('text', models.TextField(blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Volunteer',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL, to_field=u'id')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
