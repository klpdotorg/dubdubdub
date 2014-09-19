from __future__ import unicode_literals
from common.models import BaseModel, GeoBaseModel
from django.contrib.gis.db import models
from django.db.models import Sum, Count
import json


class Answer(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    story = models.ForeignKey('Story')
    question = models.ForeignKey('Question')
    text = models.TextField()

    class Meta:
        managed = False
        db_table = 'stories_answer'


class Question(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    text = models.TextField()
    data_type = models.IntegerField()
    question_type = models.ForeignKey('QuestionType')
    options = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    school_type = models.ForeignKey('schools.BoundaryType', db_column='school_type', blank=True, null=True)
    qid = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return ' - '.join([self.text, self.question_type.name])

    class Meta:
        managed = False
        db_table = 'stories_question'


class Questiongroup(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    version = models.IntegerField()
    source = models.ForeignKey('Source')

    class Meta:
        managed = False
        db_table = 'stories_questiongroup'


class QuestiongroupQuestions(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    questiongroup = models.ForeignKey('Questiongroup')
    question = models.ForeignKey('Question')
    sequence = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stories_questiongroup_questions'


class QuestionType(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    name = models.CharField(max_length=64)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'stories_questiontype'


class Source(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    name = models.CharField(max_length=64)

    class Meta:
        managed = False
        db_table = 'stories_source'


class Story(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    user = models.ForeignKey('users.User', blank=True, null=True)
    school = models.ForeignKey('schools.School')
    group = models.ForeignKey('Questiongroup')
    is_verified = models.BooleanField(default=False)
    name = models.CharField(max_length=100, blank=True)
    email = models.CharField(max_length=100, blank=True)
    date = models.CharField(max_length=50, blank=True)
    telephone = models.CharField(max_length=50, blank=True)
    entered_timestamp = models.DateTimeField(blank=True, null=True)
    comments = models.CharField(max_length=2000, blank=True)
    sysid = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stories_story'


class StoryImage(models.Model):
    id = models.IntegerField(primary_key=True)  # AutoField?
    story = models.ForeignKey('Story')
    image = models.CharField(max_length=100)
    is_verified = models.BooleanField(default=False)
    filename = models.CharField(max_length=50, blank=True)

    class Meta:
        managed = False
        db_table = 'stories_storyimage'
