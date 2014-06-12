# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0009_volunteer_activities'),
    ]

    operations = [
        migrations.AddField(
            model_name='volunteer',
            name='donations',
            field=models.ManyToManyField(to='users.DonorRequirement', through='users.VolunteerDonorRequirement'),
            preserve_default=True,
        ),
    ]
