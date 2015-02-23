from __future__ import unicode_literals
from common.models import BaseModel, GeoBaseModel, TimestampedBaseModel
from common.utils import send_templated_mail
from django.contrib.gis.db import models
from django.db.models import Sum, Count
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.sites.models import Site
from django.utils import timezone

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

    def __unicode__(self):
        return '{} v{}'.format(self.source.name, self.version)


class QuestiongroupQuestions(models.Model):
    questiongroup = models.ForeignKey('Questiongroup')
    question = models.ForeignKey('Question')
    sequence = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stories_questiongroup_questions'

    def __unicode__(self):
        return '{}: {}'.format(self.questiongroup, self.question)


class QuestionType(models.Model):
    name = models.CharField(max_length=64)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'stories_questiontype'

class UserType(models.Model):
    PARENTS = "PR"
    TEACHERS = "TR"
    VOLUNTEER = "VR"
    CBO_MEMBER = "CM"
    HEADMASTER = "HM"
    SDMC_MEMBER = "SM"
    AKSHARA_STAFF = "AS"
    EDUCATED_YOUTH = "EY"
    EDUCATION_OFFICIAL = "EO"
    ELECTED_REPRESENTATIVE = "ER"

    USER_TYPE_CHOICES = (
        (PARENTS, 'Parents'),
        (TEACHERS, 'Teachers'),
        (VOLUNTEER, 'Volunteer'),
        (CBO_MEMBER, 'CBO_Member'),
        (HEADMASTER, 'Headmaster'),
        (SDMC_MEMBER, 'SDMC_Member'),
        (AKSHARA_STAFF, 'Akshara_Staff'),
        (EDUCATED_YOUTH, 'Educated_Youth'),
        (EDUCATION_OFFICIAL, 'Education_Official'),
        (ELECTED_REPRESENTATIVE, 'Elected_Representative'),
    )

    name = models.CharField(
        max_length=2,
        choices=USER_TYPE_CHOICES,
        default=VOLUNTEER,
    )

    def __unicode__(self):
        return self.name

class Source(models.Model):
    name = models.CharField(max_length=64)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'stories_source'


class Story(TimestampedBaseModel):
    user = models.ForeignKey('users.User', blank=True, null=True)
    school = models.ForeignKey('schools.School')
    group = models.ForeignKey('Questiongroup')
    is_verified = models.BooleanField(default=False)
    name = models.CharField(max_length=100, blank=True)
    email = models.CharField(max_length=100, blank=True)

    # adding date_of_visit to replace date in future
    date = models.CharField(max_length=50, blank=True)
    date_of_visit = models.DateField(default=timezone.now)

    telephone = models.CharField(max_length=50, blank=True)

    # inheriting TimestampedBaseModel to deprecate this field in future
    entered_timestamp = models.DateTimeField(auto_now_add=True, blank=True, null=True)

    comments = models.CharField(max_length=2000, blank=True)
    sysid = models.IntegerField(blank=True, null=True)

    class Meta:
        db_table = 'stories_story'
        verbose_name_plural = 'Stories'
        ordering = ['-created_at']

    def get_geometry(self):
        return self.school.get_geometry() or None

    def __unicode__(self):
        return "%s: %s at %s" % (self.email, self.school.name, self.created_at,)


@receiver(post_save, sender=Story)
def story_updated(sender, instance=None, created=False, **kwargs):
    if not created:
        return

    send_templated_mail(
        from_email=settings.EMAIL_DEFAULT_FROM,
        to_emails=[instance.email, 'team@klp.org.in'],
        subject='Thank you for Sharing Your Story at {}'.format(instance.school.name),
        template_name='post_sys',
        context={
            'school': instance.school,
            'site_url': Site.objects.get_current().domain,
            'school_url': instance.school.get_absolute_url(),
        }
    )


class StoryImage(models.Model):
    story = models.ForeignKey('Story')
    image = models.ImageField(upload_to='sys_images')
    is_verified = models.BooleanField(default=False)
    filename = models.CharField(max_length=50, blank=True)

    class Meta:
        managed = False
        db_table = 'stories_storyimage'

    def __unicode__(self):
        return "{}: {}".format(self.story.name, self.image)

    def image_tag(self):
        return '<img height="150" width="150" src="{url}" alt="" />'.format(url=self.image.url)
    image_tag.short_description = 'Image'
    image_tag.allow_tags = True
