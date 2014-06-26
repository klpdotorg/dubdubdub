from __future__ import unicode_literals
from common.models import BaseModel
from .choices import CAT_CHOICES, MGMT_CHOICES, MT_CHOICES, SEX_CHOICES
from django.contrib.gis.db import models


class Assessment(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    programme = models.ForeignKey('Programme', db_column='pid', blank=True,
                                  null=True)
    start = models.DateField(blank=True, null=True)
    end = models.DateField(blank=True, null=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_assessment'


class InstitutionAgg(BaseModel):
    school = models.ForeignKey('School', db_column='id', primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    bid = models.ForeignKey("Boundary", db_column='bid', blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_institution_agg'


class InstitutionAssessmentAgg(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    aggval = models.DecimalField(max_digits=6, decimal_places=2,
                                 blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" % (self.school, self.sex, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_agg'


class InstitutionAssessmentAggCohorts(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    cohortsval = models.DecimalField(max_digits=6, decimal_places=2,
                                     blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" % (self.school, self.sex, self.mt,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssAggCohorts'
        managed = False
        db_table = 'tb_institution_assessment_agg_cohorts'


class InstitutionAssessmentGenderSinglescore(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid')
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2,
                                      blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.sex,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssGenderSingleScore'
        managed = False
        db_table = 'tb_institution_assessment_gender_singlescore'


class InstitutionAssessmentMtSinglescore(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid')
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2,
                                      blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssMtSingleScore'
        managed = False
        db_table = 'tb_institution_assessment_mt_singlescore'


class InstitutionAssessmentReadingAggCohorts(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    cohortsval = models.DecimalField(max_digits=6, decimal_places=2,
                                     blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssReadingAggCohorts'
        managed = False
        db_table = 'tb_institution_assessment_reading_agg_cohorts'


class InstitutionAssessmentSinglescore(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2,
                                      blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)

    def __unicode__(self):

        #FIXME: add singlescore?
        return "%s: %s" (self.school, self.programme,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssSingleScore'
        managed = False
        db_table = 'tb_institution_assessment_singlescore'


class InstitutionAssessmentSinglescoreGender(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2,
                                      blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)

    def __unicode__(self):

        #FIXME: add singlescore?
        return "%s: %s" (self.school, self.programme,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssSingleScoreGender'
        managed = False
        db_table = 'tb_institution_assessment_singlescore_gender'


class InstitutionAssessmentSinglescoreMt(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2,
                                      blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.programme, self.mt,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstAssSingleScoreMt'
        managed = False
        db_table = 'tb_institution_assessment_singlescore_mt'


class InstitutionBasicAssessmentInfo(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstBasicAssInfo'
        managed = False
        db_table = 'tb_institution_basic_assessment_info'


class InstitutionBasicAssessmentInfoCohorts(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    cohortsnum = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:

        #workaround for https://code.djangoproject.com/ticket/8162
        verbose_name = 'InstBasicAssInfoCohorts'
        managed = False
        db_table = 'tb_institution_basic_assessment_info_cohorts'


class Partner(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    status = models.IntegerField()
    info = models.CharField(max_length=500, blank=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_partner'


class PreschoolAssessmentAgg(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    agegroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    aggtext = models.CharField(max_length=100)
    aggval = models.DecimalField(max_digits=6, decimal_places=2,
                                 blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_preschool_assessment_agg'


class PreschoolBasicAssessmentInfo(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    agegroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_preschool_basic_assessment_info'


class Programme(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    start = models.DateField(blank=True, null=True)
    end = models.DateField(blank=True, null=True)
    boundary_type = models.ForeignKey('BoundaryType', db_column='type')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid',
                                      blank=True, null=True)
    partner = models.ForeignKey('Partner', db_column='partnerid',
                                blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.academic_year, self.name,)

    class Meta:
        managed = False
        db_table = 'tb_programme'


class Question(BaseModel):
    id = models.IntegerField(primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    desc = models.CharField(max_length=100)
    qtype = models.IntegerField(blank=True, null=True)
    maxmarks = models.DecimalField(max_digits=65535, decimal_places=65535,
                                   blank=True, null=True)
    minmarks = models.DecimalField(max_digits=65535, decimal_places=65535,
                                   blank=True, null=True)
    grade = models.CharField(max_length=100, blank=True)

    def __unicode__(self):
        return self.desc

    class Meta:
        managed = False
        db_table = 'tb_question'


class SchoolAgg(BaseModel):
    school = models.ForeignKey('School', db_column='id', primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    boundary = models.ForeignKey('Boundary', blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.school, self.name,)

    class Meta:
        managed = False
        db_table = 'tb_school_agg'


class SchoolAssessmentAgg(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    student_group = models.ForeignKey('StudentGroup', db_column='clid',
                                      blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    aggtext = models.CharField(max_length=100)
    aggval = models.DecimalField(max_digits=6, decimal_places=2,
                                 blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.school, self.assessment)

    class Meta:
        managed = False
        db_table = 'tb_school_assessment_agg'


class SchoolBasicAssessmentInfo(BaseModel):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid',
                                   blank=True, null=True)
    student_group = models.ForeignKey('StudentGroup', db_column='clid',
                                      blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.school, self.assessment)

    class Meta:
        managed = False
        db_table = 'tb_school_basic_assessment_info'


class StudentEval(BaseModel):
    question = models.ForeignKey('Question', db_column='qid', primary_key=True)
    student = models.ForeignKey('Student', db_column='stuid')
    mark = models.DecimalField(max_digits=5, decimal_places=2,
                               blank=True, null=True)
    grade = models.CharField(max_length=30, blank=True)

    def __unicode__(self):
        return "%s: %s" % (self.school, self.assessment)

    class Meta:
        managed = False
        db_table = 'tb_student_eval'


class SchoolEval(BaseModel):
    '''
    View table
    '''
    school = models.IntegerField(db_column='sid', primary_key=True)
    dise_info = models.ForeignKey('DiseInfo', db_column='disecode',
                                  max_length=100, blank=True)
    domain = models.CharField(max_length=100, blank=True)
    question = models.ForeignKey('Question', db_column='qid',
                                 blank=True, null=True)
    value = models.CharField(max_length=50, blank=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.question, self.value,)

    class Meta:
        managed = False
        db_table = 'vw_school_eval'


class AngInfraAgg(BaseModel):
    '''
        View table:
        Akshara does a 70 question anganwadi infrastructure
        assessment every year.
        This is an aggregation table that groups the responses per school
        into 17 ai_metrics and 5 groups - the logic is here -
        https://github.com/klpdotorg/importers/blob/master/ang_infra/db_scripts/agg_infra.sql.
        The view is from ang_infra
    '''
    school = models.ForeignKey('School', primary_key=True, db_column='sid')
    ai_metric = models.CharField(max_length=30)
    perc = models.IntegerField()
    ai_group = models.CharField(max_length=30)

    def __unicode__(self):
        return "%s: %s: %d" % (self.school, self.ai_metric, self.perc,)

    class Meta:
        managed = False
        db_table = 'vw_anginfra_agg'


class AngDisplayMaster(BaseModel):
    '''
        View table:
        This is a table to map the key values of anginfra_agg
        into readable text on the Webpage
        QUESTION: Should 'key' be a ForeignKey? To what?
    '''
    key = models.CharField(max_length=30, primary_key=True)
    value = models.CharField(max_length=200)

    def __unicode__(self):
        return "%s: %s" % (self.key, self.value,)

    class Meta:
        managed = False
        db_table = 'vw_ang_display_master'
