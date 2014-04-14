from __future__ import unicode_literals
from .base import BaseModel, BaseGeoModel
from django.contrib.gis.db import models


class ElectedrepMaster(BaseModel):
    '''
    View table:
    This is a complete listing of elected reps for mla, mp constituencies
    and ward with const_ward_ids.
    The view is from the db electrep_new
    '''
    id = models.IntegerField(primary_key=True)
    parent = models.ForeignKey('ElectedrepMaster', db_column='parent', blank=True, null=True)
    elec_comm_code = models.IntegerField(blank=True, null=True)
    const_ward_name = models.CharField(max_length=300, blank=True)
    const_ward_type = models.TextField(blank=True)  # This field type is a guess.
    neighbours = models.CharField(max_length=100, blank=True)
    current_elected_rep = models.CharField(max_length=300, blank=True)
    current_elected_party = models.CharField(max_length=300, blank=True)

    class Meta:
        managed = False
        db_table = 'vw_electedrep_master'


class SchoolElectedrep(BaseModel):
    '''
    The constituency/ward id- const_ward_id is linked
    to a klp school/preschool id in this view.
    The view is from the db electrep_new
    '''
    #Is this a OneToOne mapping?
    school = models.ForeignKey('School', primary_key=True, db_column='sid')
    ward_id = models.ForeignKey('ElectedrepMaster', related_name='school_ward', db_column='ward_id', blank=True, null=True)
    mla_const_id = models.ForeignKey('ElectedrepMaster', related_name='school_mla_const', db_column='mla_const_id', blank=True, null=True)
    mp_const_id = models.ForeignKey('ElectedrepMaster', related_name='school_mp_const', db_column='mp_const_id', blank=True, null=True)
    heirarchy = models.ForeignKey('BoundaryType', db_column='hierarchy', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'vw_school_electedrep'
