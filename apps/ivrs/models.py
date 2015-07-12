from django.db import models
from django.utils import timezone

from djorm_pgarray.fields import TextArrayField

# Create your models here.

class State(models.Model):
    session_id = models.CharField(max_length=100,unique=True)
    school_id = models.IntegerField(null=True, blank=True)
    telephone = models.CharField(max_length=50, blank=True)
    date_of_visit = models.DateField(default=timezone.now)
    is_title_verified = models.BooleanField(default=False)
    question_number = models.IntegerField(default=1)
    answers = TextArrayField(
        dimension=1,
        null=True,
        blank=True,
        default={}
    )

    def __unicode__(self):
        return self.session_id

class Chapter(models.Model):
    class_number = models.IntegerField()
    chapter_number = models.IntegerField()
    title = models.CharField(max_length=300)

    def __unicode__(self):
        return self.title

class GKATLM(models.Model):
    number = models.IntegerField()
    title = models.CharField(max_length=300)

    def __unicode__(self):
        return self.title
