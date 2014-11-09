from __future__ import unicode_literals
from common.models import GeoBaseModel
from django.contrib.gis.db import models
import json


class InstCoord(GeoBaseModel):
    '''
        View table:
        vw_inst_coord - This is a cooridnate for a school/preschool and
        can join with tb_school on school id. View is from klp_coord
    '''
    school = models.OneToOneField("School", primary_key=True,
                                  db_column='instid')
    coord = models.GeometryField()
    objects = models.GeoManager()

    def __unicode__(self):
        return "%s" % self.school

    class Meta:
        managed = False
        db_table = 'mvw_inst_coord'


class BoundaryCoord(GeoBaseModel):
    '''
        View table:
        This is a cooridnate for a boundary
        (district,block/project,cluster/circle)
        and can join with tb_boundary on boundary id. View is from klp_coord
    '''
    boundary = models.OneToOneField("Boundary", primary_key=True,
                                    db_column='id_bndry')
    typ = models.CharField(max_length=20, db_column='type')
    coord = models.GeometryField()
    objects = models.GeoManager()

    def __unicode__(self):
        return "%s" % self.boundary

    class Meta:
        managed = False
        db_table = 'mvw_boundary_coord'


class Assembly(GeoBaseModel):
    id = models.IntegerField(primary_key=True, db_column='ac_id')
    gid = models.IntegerField()
    number = models.IntegerField(db_column='ac_no')
    name = models.CharField(max_length=35, db_column='ac_name')
    state_ut = models.CharField(max_length=35)
    coord = models.GeometryField(db_column='the_geom')

    def __unicode__(self):
        return self.name

    def get_geometry(self):
        if hasattr(self, 'coord'):
            return json.loads(self.coord.geojson)
        else:
            return {}

    def get_simple_geometry(self):
        if hasattr(self, 'coord'):
            return json.loads(self.coord.simplify(0.01).geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'mvw_assembly'


class Parliament(GeoBaseModel):
    id = models.IntegerField(primary_key=True, db_column='pc_id')
    gid = models.IntegerField()
    number = models.IntegerField(db_column='pc_no')
    name = models.CharField(max_length=35, db_column='pc_name')
    state_ut = models.CharField(max_length=35)
    coord = models.GeometryField(db_column='the_geom')

    def __unicode__(self):
        return self.name

    def get_geometry(self):
        if hasattr(self, 'coord'):
            return json.loads(self.coord.geojson)
        else:
            return {}

    def get_simple_geometry(self):
        if hasattr(self, 'coord'):
            return json.loads(self.coord.simplify(0.01).geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'mvw_parliament'


class Postal(GeoBaseModel):
    id = models.IntegerField(primary_key=True, db_column='pin_id')
    gid = models.IntegerField()
    pincode = models.CharField(max_length=35)
    coord = models.GeometryField(db_column='the_geom')

    def __unicode__(self):
        return self.pincode

    def get_geometry(self):
        if hasattr(self, 'coord'):
            return json.loads(self.coord.geojson)
        else:
            return {}

    def get_simple_geometry(self):
        if hasattr(self, 'coord'):

            # Pincode geometry is fairly small. So less simplification.
            return json.loads(self.coord.simplify(0.001).geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'mvw_postal'
