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

class TbElectedrepMaster(models.Model):
    id = models.IntegerField(primary_key=True)
    parent = models.IntegerField(blank=True, null=True)
    elec_comm_code = models.IntegerField(blank=True, null=True)
    const_ward_name = models.CharField(max_length=300, blank=True)
    const_ward_type = models.TextField(blank=True) # This field type is a guess.
    neighbours = models.CharField(max_length=100, blank=True)
    current_elected_rep = models.CharField(max_length=300, blank=True)
    current_elected_party = models.CharField(max_length=300, blank=True)
    losing_elected_party = models.CharField(max_length=300, blank=True)
    prev_elected_rep = models.CharField(max_length=300, blank=True)
    status = models.TextField(blank=True) # This field type is a guess.
    class Meta:
        managed = False
        db_table = 'tb_electedrep_master'

class TbSchoolElectedrep(models.Model):
    sid = models.IntegerField(primary_key=True)
    ward_id = models.IntegerField(blank=True, null=True)
    mla_const_id = models.IntegerField(blank=True, null=True)
    mp_const_id = models.IntegerField(blank=True, null=True)
    heirarchy = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_electedrep'

class TbSchoolStuCounts(models.Model):
    sid = models.IntegerField(blank=True, null=True)
    moi = models.TextField(blank=True) # This field type is a guess.
    cat = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    sex = models.TextField(blank=True) # This field type is a guess.
    numstu = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_stu_counts'
