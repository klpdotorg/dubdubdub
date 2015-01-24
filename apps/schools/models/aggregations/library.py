from django.db import models
from common.models import BaseModel


class BoundaryLibLangAgg(BaseModel):
    boundary = models.ForeignKey('Boundary')
    academic_year = models.ForeignKey('AcademicYear')
    class_name = models.IntegerField(db_column='class', blank=True, null=True)
    month = models.CharField(max_length=10, blank=True)
    child_count = models.IntegerField(blank=True, null=True)
    book_lang = models.CharField(max_length=50, blank=True)


class BoundaryLibLevelAgg(BaseModel):
    boundary = models.ForeignKey('Boundary')
    academic_year = models.ForeignKey('AcademicYear')
    class_name = models.IntegerField(db_column='class', blank=True, null=True)
    month = models.CharField(max_length=10, blank=True)
    child_count = models.IntegerField(blank=True, null=True)
    book_level = models.CharField(max_length=50, blank=True)
