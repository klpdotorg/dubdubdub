# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0006_volunteer_volunteeractivity'),
    ]

    operations = [
        migrations.CreateModel(
            name='VolunteerDonorRequirement',
            fields=[
                (u'id', models.AutoField(verbose_name=u'ID', serialize=False, auto_created=True, primary_key=True)),
                ('volunteer', models.ForeignKey(to='users.Volunteer', to_field=u'id')),
                ('donor_requirement', models.ForeignKey(to='users.DonorRequirement', to_field=u'id')),
                ('date', models.DateField()),
                ('donation', models.CharField(max_length=256)),
                ('status', models.IntegerField(default=0, choices=[(0, 'Pending'), (1, 'Cancelled'), (2, 'Completed')])),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
