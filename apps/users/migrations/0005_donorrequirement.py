# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0004_organizationmanager'),
        ('schools', '__first__'),
    ]

    operations = [
        migrations.CreateModel(
            name='DonorRequirement',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('organization', models.ForeignKey(to='users.Organization', to_field=u'id')),
                ('type', models.ForeignKey(to='users.DonationType', to_field=u'id')),
                ('school', models.ForeignKey(to='schools.School', to_field='id')),
                ('text', models.TextField(blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
