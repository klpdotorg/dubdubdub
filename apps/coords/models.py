# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Remove `managed = False` lines for those models you wish to give write DB access
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.
from __future__ import unicode_literals

from django.contrib.gis.db import models

class BoundaryCoord(models.Model):
    id_bndry = models.IntegerField(primary_key=True)
    type = models.CharField(max_length=20)
    coord = models.PointField(blank=True, null=True)
    objects = models.GeoManager()
    class Meta:
        managed = False
        db_table = 'boundary_coord'

class ElectoralCoord(models.Model):
    const_ward_id = models.IntegerField(primary_key=True)
    const_ward_type = models.CharField(max_length=20)
    coord = models.PointField(srid=-1, blank=True, null=True)
    objects = models.GeoManager()
    class Meta:
        managed = False
        db_table = 'electoral_coord'

class InstCoord(models.Model):
    instid = models.IntegerField(primary_key=True)
    coord = models.PointField(blank=True, null=True)
    objects = models.GeoManager()
    class Meta:
        managed = False
        db_table = 'inst_coord'

