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


class BoundarySchoolAgg(AggregationBase):
    admin3 = models.ForeignKey("Boundary", db_column="cluster_or_circle_id",
                               related_name="bagg_admin3")
    admin2 = models.ForeignKey("Boundary", db_column="block_or_project_id",
                               related_name="bagg_admin2")
    admin1 = models.ForeignKey("Boundary", db_column="district_id",
                               related_name="bagg_admin1")

    class Meta:
        db_table = 'mvw_boundary_school_agg'


class AssemblySchoolAgg(AggregationBase):
    assembly = models.ForeignKey('Assembly', db_column='assembly_id')

    class Meta:
        db_table = 'mvw_assembly_school_agg'


class ParliamentSchoolAgg(AggregationBase):
    parliament = models.ForeignKey('Parliament', db_column='parliament_id')

    class Meta:
        db_table = 'mvw_parliament_school_agg'


class PincodeSchoolAgg(AggregationBase):
    pincode = models.ForeignKey('Postal', db_column='pin_id')

    class Meta:
        db_table = 'mvw_pincode_school_agg'


# class BoundarySchoolAggMoi(BaseModel):
#     boundary_sch_agg = models.ForeignKey('BoundarySchoolDetailsAgg')
#     language_id = models.IntegerField()
#     num_students = models.IntegerField()
#     num_boys = models.IntegerField()


# class BoundarySchoolAggType(BaseModel):
#     boundary_sch_agg = models.ForeignKey('BoundarySchoolDetailsAgg')
#     boundary_type_id = models.IntegerField()
#     num_schools = models.IntegerField()
