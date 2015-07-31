from django.db import models
from common.models import BaseModel


class AggregationBase(BaseModel):
    academic_year = models.ForeignKey('AcademicYear')

    num_school = models.IntegerField()
    num_preschool = models.IntegerField()

    num_boys_school = models.IntegerField()
    num_girls_school = models.IntegerField()

    num_boys = models.IntegerField()
    num_girls = models.IntegerField()

    class Meta:
        abstract = True
