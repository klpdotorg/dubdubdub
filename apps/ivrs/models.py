from django.db import models

from djorm_pgarray.fields import TextArrayField

# Create your models here.

class State(models.Model):
    session_id = models.IntegerField(unique=True)
    school_id = models.IntegerField(null=True, blank=True)
    question_number = models.IntegerField(default=1)
    answers = TextArrayField(
        dimension=1,
        null=True,
        blank=True,
        default=[]
    )
