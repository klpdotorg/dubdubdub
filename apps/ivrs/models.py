from django.db import models
from django.utils import timezone

from djorm_pgarray.fields import TextArrayField

from stories.models import Questiongroup


class State(models.Model):
    is_invalid = models.BooleanField(default=False)
    is_processed = models.BooleanField(default=False)
    raw_data = models.TextField(null=True, blank=True)
    comments = models.TextField(null=True, blank=True)
    school_id = models.IntegerField(null=True, blank=True)
    telephone = models.CharField(max_length=50, blank=True)
    date_of_visit = models.DateTimeField(default=timezone.now)
    session_id = models.CharField(max_length=100, unique=True)
    qg_type = models.ForeignKey('QuestionGroupType', blank=True, null=True)
    answers = TextArrayField(
        dimension=1,
        null=True,
        blank=True,
        default={}
    )

    def __unicode__(self):
        return str(self.date_of_visit) + " - " + str(self.qg_type.questiongroup.source.name)


class QuestionGroupType(models.Model):
    name = models.CharField(max_length=25)
    is_active = models.BooleanField(default=True)
    questiongroup = models.OneToOneField(Questiongroup)

    def __unicode__(self):
        return self.name


class IncomingNumber(models.Model):
    name = models.CharField(max_length=50)
    number = models.CharField(max_length=50)
    qg_type = models.ForeignKey(QuestionGroupType, blank=True, null=True)

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
