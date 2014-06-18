# encoding: utf8
from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0010_volunteer_donations'),
    ]

    operations = [
        migrations.DeleteModel(
            name='Developer',
        ),
        migrations.AlterField(
            model_name='user',
            name='mobile_no',
            field=models.CharField(max_length=32, blank=True),
        ),
        migrations.AlterField(
            model_name='user',
            name='type',
            field=models.IntegerField(default=0, choices=[(0, 'Volunteer'), (1, 'Developer'), (2, 'OrganizationManager')]),
        ),
    ]
