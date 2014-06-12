# encoding: utf8
from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('users', '0003_developer'),
    ]

    operations = [
        migrations.CreateModel(
            name='OrganizationManager',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('user', models.OneToOneField(to=settings.AUTH_USER_MODEL, to_field=u'id')),
                ('organization', models.ForeignKey(to='users.Organization', to_field=u'id')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
