from django.db import models
from django.utils import timezone

from djorm_pgarray.fields import TextArrayField

from stories.models import Questiongroup


class State(models.Model):
    ivrs_type = models.CharField(max_length=10, default="gka")
    session_id = models.CharField(max_length=100, unique=True)
    is_processed = models.BooleanField(default=False)
    is_invalid = models.BooleanField(default=False)
    school_id = models.IntegerField(null=True, blank=True)
    telephone = models.CharField(max_length=50, blank=True)
    date_of_visit = models.DateTimeField(default=timezone.now)
    answers = TextArrayField(
        dimension=1,
        null=True,
        blank=True,
        default={}
    )

    def __unicode__(self):
        return self.session_id


class QuestionGroupType(models.Model):
    name = models.CharField(max_length=25)
    is_active = models.BooleanField(default=True)
    questiongroup = models.OneToOneField(Questiongroup)

    def __unicode__(self):
        return self.name


class IncomingNumber(models.Model):
    number = models.CharField(max_length=50)
    qg_type = models.ForeignKey(QuestionGroupType)

    def __unicode__(self):
        return self.qg_type.name + ":" + self.number


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
