from __future__ import unicode_literals
from common.models import BaseModel
from django.contrib.gis.db import models


class ElectedrepMaster(BaseModel):
    '''
    View table:
    This is a complete listing of elected reps for mla, mp constituencies
    and ward with const_ward_ids.
    The view is from the db electrep_new
    '''
    id = models.IntegerField(primary_key=True)
    parent = models.ForeignKey(
        'ElectedrepMaster', db_column='parent',
        blank=True, null=True, on_delete=models.SET_NULL
    )
    dise_slug = models.SlugField(max_length=300)

    elec_comm_code = models.IntegerField(blank=True, null=True)
    const_ward_name = models.CharField(max_length=300, blank=True)

    # This field type is a guess.
    const_ward_type = models.TextField(blank=True)
    neighbours = models.CharField(max_length=100, blank=True)
    current_elected_rep = models.CharField(max_length=300, blank=True)
    current_elected_party = models.CharField(max_length=300, blank=True)

    def __unicode__(self):
        return "%d: %s" % (self.elec_comm_code, self.const_ward_name,)

    class Meta:
        managed = False
        db_table = 'mvw_electedrep_master'


class SchoolElectedrep(BaseModel):
    '''
    The constituency/ward id- const_ward_id is linked
    to a klp school/preschool id in this view.
    The view is from the db electrep_new
    '''
    # Is this a OneToOne mapping?
    # all the values of sid are distinct, so Yes I think
    school = models.OneToOneField('School', primary_key=True, db_column='sid',
                                  related_name="electedrep")
    ward = models.ForeignKey('ElectedrepMaster', related_name='school_ward',
                             db_column='ward_id', blank=True, null=True, on_delete=models.SET_NULL)
    assembly = models.ForeignKey('Assembly',
                                 db_column='mla_const_id',
                                 blank=True, null=True, on_delete=models.SET_NULL)
    parliament = models.ForeignKey('Parliament',
                                   db_column='mp_const_id',
                                   blank=True, null=True, on_delete=models.SET_NULL)

    # TYPO IN DB ---------------------------------------------vv
    hierarchy = models.ForeignKey('BoundaryType', db_column='heirarchy',
                                  blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.school, self.ward_id,)

    class Meta:
        managed = False
        db_table = 'mvw_school_electedrep'
