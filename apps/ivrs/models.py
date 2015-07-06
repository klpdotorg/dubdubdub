from django.db import models

# Create your models here.

class State(models.Model):
    session_id = models.IntegerField(unique=True)
    school_id = models.IntegerField(null=True, blank=True)
    question_number = models.IntegerField(null=True, blank=True)
