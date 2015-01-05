from django.db import models
from common.models import BaseModel
from schools.models import LibAggBase


class BoundaryLibLangAgg(LibAggBase):
    boundary = models.ForeignKey('Boundary')
    academic_year = models.ForeignKey('AcademicYear')
    book_lang = models.CharField(max_length=50, blank=True)


class BoundaryLibLevelAgg(LibAggBase):
    boundary = models.ForeignKey('Boundary')
    academic_year = models.ForeignKey('AcademicYear')
    book_level = models.CharField(max_length=50, blank=True)
