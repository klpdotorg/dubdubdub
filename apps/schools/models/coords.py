from __future__ import unicode_literals
from common.models import GeoBaseModel
from django.contrib.gis.db import models

class InstCoord(GeoBaseModel):
    '''
        View table:
        vw_inst_coord - This is a cooridnate for a school/preschool and
        can join with tb_school on school id. View is from klp_coord
    '''
    school = models.OneToOneField("School", primary_key=True, db_column='instid')
    coord = models.GeometryField()
    objects = models.GeoManager()
    class Meta:
        managed = False
        db_table = 'vw_inst_coord'


class BoundaryCoord(GeoBaseModel):
    '''
        View table:
        This is a cooridnate for a boundary (district,block/project,cluster/circle)
        and can join with tb_boundary on boundary id. View is from klp_coord
    '''
    boundary = models.OneToOneField("Boundary", primary_key=True, db_column='id_bndry')
    typ = models.CharField(max_length=20, db_column='type')
    coord = models.GeometryField()
    objects = models.GeoManager()
    class Meta:
        managed = False
        db_table = 'vw_boundary_coord'


