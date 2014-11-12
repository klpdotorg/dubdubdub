from __future__ import unicode_literals
from common.models import BaseModel
from .choices import CAT_CHOICES, MGMT_CHOICES, MT_CHOICES, SEX_CHOICES
from django.contrib.gis.db import models


class DiseDisplayMaster(BaseModel):
    '''
    View table:
    This is a table to map the key values of
    dise_facility_agg into readable text on the Webpage
    '''
    key = models.CharField(max_length=36, primary_key=True)
    value = models.CharField(max_length=200, blank=True)

    def __unicode__(self):
        return "%s" % self.key

    class Meta:
        managed = False
        db_table = 'mvw_dise_display_master'


class DiseFacilityAgg(BaseModel):
    '''
    View table:
    The Dise facilities data source also has many fields.
    This is an aggregation per school into 15 metrics and 4 groups.
    The view is from dise_all.
    '''
    dise_info = models.ForeignKey('DiseInfo', db_column='dise_code',
                                  primary_key=True)
    df_metric = models.ForeignKey('DiseDisplayMaster',
                                   db_column='df_metric', blank=True)
    score = models.DecimalField(max_digits=5, decimal_places=0, blank=True,
                                null=True)
    df_group = models.CharField(max_length=30, blank=True)

    def __unicode__(self):
        return "%s" % (self.dise_info,)

    class Meta:
        managed = False
        db_table = 'mvw_dise_facility_agg'


class AnganwadiDisplayMaster(BaseModel):
    '''
    View table:
    This is a table to map the key values of
    mvw_ang_display_master into readable text on the Webpage
    The view is from ang_infra.
    '''
    key = models.CharField(max_length=36, primary_key=True)
    value = models.CharField(max_length=200, blank=True)

    def __unicode__(self):
        return "%s" % self.key

    class Meta:
        managed = False
        db_table = 'mvw_ang_display_master'


class AnganwadiInfraAgg(BaseModel):
    '''
    View table:
    The Anganwadi infrastructure data source also has many fields.
    This is an aggregation per school into 15 metrics and 4 groups.
    The view is from ang_infra.
    '''
    school = models.ForeignKey('School', db_column='sid',
                                  primary_key=True)
    ai_metric = models.ForeignKey('AnganwadiDisplayMaster',
                                   db_column='ai_metric', blank=True)
    perc_score = models.DecimalField(max_digits=5, decimal_places=0, blank=True,
                                null=True)
    ai_group = models.CharField(max_length=30, blank=True)

    def __unicode__(self):
        return "%s" % (self.school,)

    class Meta:
        managed = False
        db_table = 'mvw_ang_infra_agg'


class DiseInfo(BaseModel):
    '''
    View table:
    This is a view of enrollment, finances, teacher & classroom count, etc
    from dise_all that help compare demographics in klp with dise and
    is the basis for everything on the Finance tab of the school page -
    http://www.klp.org.in/schoolpage/school/33166?tab=finances
    '''
    dise_code = models.CharField(max_length=32, primary_key=True)
    classroom_count = models.IntegerField(blank=True, null=True)
    teacher_count = models.IntegerField(blank=True, null=True)
    boys_count = models.IntegerField(blank=True, null=True)
    girls_count = models.IntegerField(blank=True, null=True)
    lowest_class = models.IntegerField(blank=True, null=True)
    highest_class = models.IntegerField(blank=True, null=True)
    acyear = models.CharField(max_length=15, blank=True)
    sg_recd = models.IntegerField(blank=True, null=True)
    sg_expnd = models.IntegerField(blank=True, null=True)
    tlm_recd = models.IntegerField(blank=True, null=True)
    tlm_expnd = models.IntegerField(blank=True, null=True)
    ffs_recd = models.IntegerField(blank=True, null=True)
    ffs_expnd = models.IntegerField(blank=True, null=True)
    books_in_library = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return self.dise_code

    class Meta:
        managed = False
        db_table = 'mvw_dise_info_olap'

    def get_rte_details(self):
        dise_rte = {}
        for rte in self.diserteagg_set.all().select_related('rte_metric'):
            if rte.rte_group not in dise_rte:
                dise_rte[rte.rte_group] = {}
            dise_rte[rte.rte_group][rte.rte_metric.value] = rte.status
        return dise_rte

    def get_facility_details(self):
        dise_facilities = {}
        for facility in self.disefacilityagg_set.all().select_related('df_metric'):
            if facility.df_group not in dise_facilities:
                dise_facilities[facility.df_group] = {}
            dise_facilities[facility.df_group][str(facility.df_metric.value).strip()] = (facility.score == 100)
        return dise_facilities


class PaisaData(BaseModel):
    '''
    This is a view from electrep_new and has the formulae that determine
    the financial allocation to each school.
    It's used along with vw_dise_info to build up the above finance page.
    '''
    grant_type = models.CharField(max_length=32, primary_key=True)
    grant_amount = models.IntegerField(blank=True, null=True)
    criteria = models.CharField(max_length=32, blank=True)
    operator = models.CharField(max_length=3, blank=True)
    factor = models.CharField(max_length=32, blank=True)

    def __unicode__(self):
        return self.grant_type

    class Meta:
        managed = False
        db_table = 'mvw_paisa_data'


class DiseRteAgg(BaseModel):
    '''
    View table:
    This is a view, also from dise_all of mid day meal availability
    and source, and SDMC (school development monitoring committee)
    being available and functional in the school.
    '''
    dise_info = models.ForeignKey('DiseInfo', db_column='dise_code',
                                  primary_key=True)
    rte_metric = models.ForeignKey('DiseDisplayMaster',
                                   db_column='rte_metric', blank=True)
    status = models.CharField(max_length=30, blank=True)
    rte_group = models.CharField(max_length=32, blank=True)

    def __unicode__(self):
        return "%s" % self.dise_info

    class Meta:
        managed = False
        db_table = 'mvw_dise_rte_agg'


class LibBorrow(BaseModel):
    '''
    View table:
    This is the base table from which the two aggregations
    below have been generated,

    I suppose to provide some text summaries for the graphs.
    All the logic is here : https://github.com/klpdotorg/library
    '''
    trans_year = models.CharField(max_length=30, blank=True)
    class_name = models.DecimalField(db_column='class', max_digits=3,
                                     decimal_places=0, blank=True,
                                     null=True)
    issue_date = models.CharField(max_length=20, blank=True)
    #school not unique, but we set primary key to true
    school = models.ForeignKey("School", db_column='klp_school_id',
                               primary_key=True)
    school_name = models.CharField(max_length=50, blank=True)
    '''
    Child ID sometimes has ids like TMP00045 . What does this mean?

    How to handle this problem of the ForeignKey sometimes
    being an arbitrary string?

    It's possibly okay / we write it in to some sort of exception handler.
    '''
    child = models.ForeignKey('Child', blank=True, db_column='klp_child_id')

    def __unicode__(self):
        return "%s: %s" % (self.trans_year, self.school,)

    class Meta:
        managed = False
        db_table = 'mvw_lib_borrow'


class LibLangAgg(BaseModel):
    '''
    View table:
    View from library that a school level aggregates
    how many children borrowed books in a given month
    in a given language in an Akshara library
    '''
    #school is not unique
    school = models.ForeignKey('School', db_column='klp_school_id',
                               primary_key=True)

    #Field renamed because it was a Python reserved word.
    class_name = models.IntegerField(db_column='class',
                                     blank=True, null=True)
    month = models.CharField(max_length=10, blank=True)
    year = models.CharField(max_length=10, blank=True)
    #Does this map to MT_CHOICES?
    book_lang = models.CharField(max_length=50, blank=True)
    child_count = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %d" % (self.school, self.class_name,)

    class Meta:
        managed = False
        db_table = 'mvw_lib_lang_agg'


class LibLevelAgg(BaseModel):
    '''
    View from library that a school level aggregates
    how many children borrowed books in a given month
    in a given difficulty level in an Akshara library
    '''
    #school is not unique, but we set primary key=True to keep django happy
    school = models.ForeignKey('School', db_column='klp_school_id',
                               primary_key=True)

    # Field renamed because it was a Python reserved word.
    class_name = models.IntegerField(db_column='class', blank=True, null=True)
    month = models.CharField(max_length=10, blank=True)
    year = models.CharField(max_length=10, blank=True)
    #FIXME: this should be defined as choices somewhere?
    book_level = models.CharField(max_length=50, blank=True)
    child_count = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %d" % (self.school, self.class_name,)

    class Meta:
        managed = False
        db_table = 'mvw_lib_level_agg'


class Libinfra(BaseModel):
    '''
    This is a view from libinfra and at a school level tells
    the status of a library and the infrastructure provided
    to it as part of the Akshara Library programme
    '''
    school = models.OneToOneField('School', db_column='sid', primary_key=True)
    libstatus = models.CharField(max_length=300, blank=True)
    handoveryear = models.IntegerField(blank=True, null=True)
    libtype = models.CharField(max_length=300, blank=True)
    numbooks = models.IntegerField(blank=True, null=True)
    numracks = models.IntegerField(blank=True, null=True)
    numtables = models.IntegerField(blank=True, null=True)
    numchairs = models.IntegerField(blank=True, null=True)
    numcomputers = models.IntegerField(blank=True, null=True)
    numups = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.school, self.libstatus,)

    class Meta:
        managed = False
        db_table = 'mvw_libinfra'


class MdmAgg(BaseModel):
    '''
    This is a view from the db apmdm that aggregates the daily entry of
    indent and attendance to a weekly view per school. The logic is here -
    https://github.com/klpdotorg/importers/blob/master/apmdm/agg_apmdm.sql
    '''
    #we set primary_key=True to make django happy, though school is not unique
    school = models.ForeignKey("School", primary_key=True, db_column='klpid')
    mon = models.CharField(max_length=15, blank=True)
    wk = models.IntegerField(blank=True, null=True)
    indent = models.IntegerField(blank=True, null=True)
    attend = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %d" % (self.school, self.mon, self.wk,)

    class Meta:
        managed = False
        db_table = 'mvw_mdm_agg'
        unique_together = ('school', 'mon', 'wk',)
