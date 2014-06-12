# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0007_volunteerdonorrequirement'),
    ]

    operations = [
        migrations.CreateModel(
            name='VolunteerVolunteerActivity',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('volunteer', models.ForeignKey(to='users.Volunteer', to_field=u'id')),
                ('activity', models.ForeignKey(to='users.VolunteerActivity', to_field=u'id')),
                ('status', models.IntegerField(default=0, choices=[(0, 'Pending'), (1, 'Cancelled'), (2, 'Completed')])),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
