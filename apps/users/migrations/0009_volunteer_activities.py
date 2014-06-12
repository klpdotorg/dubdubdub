# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0008_volunteervolunteeractivity'),
    ]

    operations = [
        migrations.AddField(
            model_name='volunteer',
            name='activities',
            field=models.ManyToManyField(to='users.VolunteerActivity', through='users.VolunteerVolunteerActivity'),
            preserve_default=True,
        ),
    ]
