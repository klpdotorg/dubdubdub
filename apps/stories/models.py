from __future__ import unicode_literals
from common.models import BaseModel, GeoBaseModel
from django.contrib.gis.db import models
from django.db.models import Sum, Count
import json


class Answer(models.Model):
    story = models.ForeignKey('Story')
    question = models.ForeignKey('Question')
    text = models.TextField()

    def __unicode__(self):
        return ' - '.join([self.story.name, self.question.text, self.text])

    class Meta:
        managed = False
        db_table = 'stories_answer'


class Question(models.Model):
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
    version = models.IntegerField()
    source = models.ForeignKey('Source')
    questions = models.ManyToManyField('Question', through='QuestiongroupQuestions')

    class Meta:
        managed = False
        db_table = 'stories_questiongroup'


class QuestiongroupQuestions(models.Model):
    questiongroup = models.ForeignKey('Questiongroup')
    question = models.ForeignKey('Question')
    sequence = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stories_questiongroup_questions'


class QuestionType(models.Model):
    name = models.CharField(max_length=64)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'stories_questiontype'


class Source(models.Model):
    name = models.CharField(max_length=64)

    class Meta:
        managed = False
        db_table = 'stories_source'


class Story(models.Model):
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

    def get_geometry(self):
        return self.school.get_geometry() or None


class StoryImage(models.Model):
    story = models.ForeignKey('Story')
    image = models.ImageField(upload_to='sys_images')
    is_verified = models.BooleanField(default=False)
    filename = models.CharField(max_length=50, blank=True)

    class Meta:
        managed = False
        db_table = 'stories_storyimage'
