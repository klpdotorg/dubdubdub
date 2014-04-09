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
import json
from coords.models import InstCoord

CAT_CHOICES = (
    ('Model Primary', 'Model Primary'),
    ('Anganwadi', 'Anganwadi'),
    ('Lower Primary', 'Lower Primary'),
    ('Secondary', 'Secondary'),
    ('Akshara Balwadi', 'Akshara Balwadi'),
    ('Independent Balwadi', 'Independent Balwadi'),
    ('Upper Primary', 'Upper Primary'),
)

#FIXME: Add mgmt choices from DISE list, @BibhasC
#FIXME: change verbose names to something nicer
MGMT_CHOICES = (
    ('p-a', 'p-a'),
    ('ed', 'ed'),
    ('p-ua', 'p-ua'),
)

MT_CHOICES = (
    ('bengali', 'Bengali'),
    ('english', 'English'),
    ('gujarathi', 'Gujarathi'),
    ('hindi', 'Hindi'),
    ('kannada', 'Kannada'),
    ('konkani', 'Konkani'),
    ('malayalam', 'Malayalam'),
    ('marathi', 'Marathi'),
    ('nepali', 'Nepali'),
    ('oriya', 'Oriya'),
    ('sanskrit', 'Sanskrit'),
    ('sindhi', 'Sindhi'),
    ('tamil', 'Tamil'),
    ('telugu', 'Telugu'),
    ('urdu', 'Urdu'),
    ('multi lng', 'Multi Lingual'),
    ('other', 'Other'),
    ('not known', 'Not known'),
)

SEX_CHOICES = (
    ('male', 'Male'),
    ('female', 'Female'),
)

class Assembly(models.Model):
    ogc_fid = models.IntegerField(primary_key=True)
    wkb_geometry = models.PolygonField(blank=True, null=True)
    ac_id = models.IntegerField(blank=True, null=True)
    ac_no = models.FloatField(blank=True, null=True)
    ac_name = models.CharField(max_length=35, blank=True)
    state_ut = models.CharField(max_length=35, blank=True)
    objects = models.GeoManager()

    def __unicode__(self):
        return self.ac_name

    class Meta:
        managed = False
        db_table = 'assembly'

class AcademicYear(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20, blank=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_academic_year'

class Address(models.Model):
    id = models.IntegerField(primary_key=True)
    address = models.CharField(max_length=1000, blank=True)
    area = models.CharField(max_length=1000, blank=True)
    pincode = models.CharField(max_length=20, blank=True)
    landmark = models.CharField(max_length=1000, blank=True)
    instidentification = models.CharField(max_length=1000, blank=True)
    bus = models.CharField(max_length=1000, blank=True)
    instidentification2 = models.CharField(max_length=1000, blank=True)

    def __unicode__(self):
        return self.address

    class Meta:
        managed = False
        db_table = 'tb_address'

# This table is not used - commenting out from models
# class TbAngpre2011Agg(models.Model):
#     sid = models.IntegerField(blank=True, null=True)
#     gender = models.CharField(max_length=8, blank=True)
#     stucount = models.IntegerField(blank=True, null=True)
#     min_score = models.IntegerField(blank=True, null=True)
#     max_score = models.IntegerField(blank=True, null=True)
#     median_score = models.IntegerField(blank=True, null=True)
#     avg_score = models.IntegerField(blank=True, null=True)
#     class Meta:
#         managed = False
#         db_table = 'tb_angpre_2011_agg'

class Assessment(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    programme = models.ForeignKey('Programme', db_column='pid', blank=True, null=True)
    start = models.DateField(blank=True, null=True)
    end = models.DateField(blank=True, null=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_assessment'

class BoundaryHierarchy(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_bhierarchy'

class Boundary(models.Model):
    id = models.IntegerField(primary_key=True)
    parent = models.ForeignKey("Boundary", blank=True, null=True, db_column='parent')
    name = models.CharField(max_length=300)
    hierarchy = models.ForeignKey(BoundaryHierarchy, db_column='hid')
    type = models.ForeignKey('BoundaryType', db_column='type')

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_boundary'

class BoundaryType(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_boundary_type'


class Child(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    dob = models.DateField(blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)

    class Meta:
        managed = False
        db_table = 'tb_child'

class Class(models.Model):
    id = models.IntegerField(primary_key=True)
    school = models.ForeignKey("School", blank=True, null=True, db_column="sid")
    name = models.CharField(max_length=50)
    section = models.CharField(max_length=1, blank=True)

    def __unicode__(self):
        return self.id

    class Meta:
        managed = False
        db_table = 'tb_class'

class InstitutionAgg(models.Model):
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

class InstitutionAssessmentAgg(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True, blank=True, null=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    aggval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" % (self.school, self.sex, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_agg'

class InstitutionAssessmentAggCohorts(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True, blank=True, null=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    cohortsval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" % (self.school, self.sex, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_agg_cohorts'

class InstitutionAssessmentGenderSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid')
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.sex,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_gender_singlescore'


class InstitutionAssessmentMtSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid')
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_mt_singlescore'


class InstitutionAssessmentReadingAggCohorts(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    cohortsval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_reading_agg_cohorts'

class InstitutionAssessmentSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore'

class InstitutionAssessmentSinglescoreGender(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore_gender'

class InstitutionAssessmentSinglescoreMt(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore_mt'

class InstitutionBasicAssessmentInfo(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_basic_assessment_info'

class InstitutionBasicAssessmentInfoCohorts(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    cohortsnum = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_basic_assessment_info_cohorts'

class Partner(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    status = models.IntegerField()
    info = models.CharField(max_length=500, blank=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_partner'

class PreschoolAssessmentAgg(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    agegroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    aggtext = models.CharField(max_length=100)
    aggval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_preschool_assessment_agg'

class PreschoolBasicAssessmentInfo(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    agegroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_preschool_basic_assessment_info'

class Programme(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    start = models.DateField(blank=True, null=True)
    end = models.DateField(blank=True, null=True)
    boundary_type = models.ForeignKey('BoundaryType', db_column='type')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid', blank=True, null=True)
    partner = models.ForeignKey('Partner', db_column='partnerid', blank=True, null=True)

    def __unicode__(self):
        return "%s: %s" % (self.academic_year, self.name,)

    class Meta:
        managed = False
        db_table = 'tb_programme'


class Question(models.Model):
    id = models.IntegerField(primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    desc = models.CharField(max_length=100)
    qtype = models.IntegerField(blank=True, null=True)
    maxmarks = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)
    minmarks = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)
    grade = models.CharField(max_length=100, blank=True)

    def __unicode__(self):
        return self.desc

    class Meta:
        managed = False
        db_table = 'tb_question'

class School(models.Model):
    id = models.IntegerField(primary_key=True)
    boundary = models.ForeignKey('Boundary', db_column='bid')
    #TODO: check if address should be ForeignKey or OneToOneField
    address = models.ForeignKey('Address', db_column='aid', blank=True, null=True)
    dise_info = models.OneToOneField('DiseInfo', db_column='dise_code', blank=True, null=True)
    name = models.CharField(max_length=300)
    cat = models.CharField(max_length=128, choices=CAT_CHOICES)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    moi = models.CharField(max_length=128, choices=MT_CHOICES)
    mgmt = models.CharField(max_length=128, choices=MGMT_CHOICES)
    status = models.IntegerField()
    objects = models.GeoManager()

    def __unicode__(self):
        return self.name

    def get_properties(self):
        return {
            'id': self.id,
            'name': self.name
        }

    def get_geometry(self):
        if self.instcoord is not None:
            return json.loads(self.instcoord.coord.geojson)
        else:
            return {}


    def get_geojson(self):
        return {
            'geometry': self.get_geometry(),
            'properties': self.get_properties()
        }

    class Meta:
        managed = False
        db_table = 'tb_school'

class SchoolAgg(models.Model):
    school = models.ForeignKey('School', db_column='id', primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    boundary = models.ForeignKey('Boundary', blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_agg'

class SchoolAssessmentAgg(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    klass = models.ForeignKey('Class', db_column='clid', blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    aggtext = models.CharField(max_length=100)
    aggval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_assessment_agg'

class SchoolBasicAssessmentInfo(models.Model):
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    klass = models.ForeignKey('Class', db_column='clid', blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_basic_assessment_info'

class Student(models.Model):
    id = models.IntegerField(primary_key=True)
    child = models.ForeignKey('Child', db_column='cid')
    otherstudentid = models.CharField(max_length=100, blank=True)
    status = models.IntegerField()

    def __unicode__(self):
        return self.id

    class Meta:
        managed = False
        db_table = 'tb_student'

class StudentClass(models.Model):
    student = models.ForeignKey('Student', db_column='stuid', primary_key=True)
    klass = models.ForeignKey('Class', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField()
    class Meta:
        managed = False
        db_table = 'tb_student_class'

class StudentEval(models.Model):
    question = models.ForeignKey('Question', db_column='qid', primary_key=True)
    student = models.ForeignKey('Student', db_column='stuid')
    mark = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    grade = models.CharField(max_length=30, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_student_eval'

'''
THESE TABLES DO NOT EXIST IN NEW DB. REMOVE IF NOT NEEDED.

class StudentgroupAssessmentGenderSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid')
    studentgroup = models.CharField(max_length=50)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_gender_singlescore'

class StudentgroupAssessmentMtSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid')
    studentgroup = models.CharField(max_length=50)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_mt_singlescore'

class StudentgroupAssessmentSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid')
    studentgroup = models.CharField(max_length=50)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore'

class StudentgroupAssessmentSinglescoreGender(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid')
    studentgroup = models.CharField(max_length=50)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore_gender'

class StudentgroupAssessmentSinglescoreMt(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore_mt'
'''

class Teacher(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    status = models.IntegerField(blank=True, null=True)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    dateofjoining = models.DateField(blank=True, null=True)
    type = models.CharField(max_length=50, blank=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_teacher'

class TeacherClass(models.Model):
    teacher = models.ForeignKey('Teacher', db_column='teacherid', primary_key=True)
    klass = models.ForeignKey('Class', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_teacher_class'

class TeacherQualification(models.Model):
    teacher = models.ForeignKey('Teacher', db_column='tid', primary_key=True)
    qualification = models.CharField(max_length=100)
    class Meta:
        managed = False
        db_table = 'tb_teacher_qual'


class InstCoord(models.Model):
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

class BoundaryCoord(models.Model):
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

class AngInfraAgg(models.Model):
    '''
        View table:
        Akshara does a 70 question anganwadi infrastructure assessment every year.
        This is an aggregation table that groups the responses per school
        into 17 ai_metrics and 5 groups - the logic is here - 
        https://github.com/klpdotorg/importers/blob/master/ang_infra/db_scripts/agg_infra.sql.
        The view is from ang_infra 
    '''
    school = models.ForeignKey('School', primary_key=True, db_column='sid')
    ai_metric = models.CharField(max_length=30)
    perc = models.IntegerField()
    ai_group = models.CharField(max_length=30)
    class Meta:
        managed = False
        db_table = 'vw_anginfra_agg'


class AngDisplayMaster(models.Model):
    '''
        View table:
        This is a table to map the key values of anginfra_agg
        into readable text on the Webpage
        QUESTION: Should 'key' be a ForeignKey? To what?
    '''
    key = models.CharField(max_length=30, primary_key=True)
    value = models.CharField(max_length=200)
    class Meta:
        managed = False
        db_table = 'vw_ang_display_master'


class DiseDisplayMaster(models.Model):
    '''
    View table:
    This is a table to map the key values of 
    dise_facility_agg into readable text on the Webpage
    '''
    key = models.CharField(max_length=36, primary_key=True)
    value = models.CharField(max_length=200, blank=True)

    class Meta:
        managed = False
        db_table = 'vw_dise_display_master'


class DiseFacilityAgg(models.Model):
    '''
    View table:
    The Dise facilities data source also has many fields. 
    This is an aggregation per school into 15 metrics and 4 groups.
    The view is from dise_all.
    '''
    dise_info = models.ForeignKey('DiseInfo', db_column='dise_code', primary_key=True)
    df_metric = models.CharField(max_length=30, blank=True)
    score = models.DecimalField(max_digits=5, decimal_places=0, blank=True, null=True)
    df_group = models.CharField(max_length=30, blank=True)

    class Meta:
        managed = False
        db_table = 'vw_dise_facility_agg'


class DiseInfo(models.Model):
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

    class Meta:
        managed = False
        db_table = 'vw_dise_info'


class PaisaData(models.Model):
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

    class Meta:
        managed = False
        db_table = 'vw_paisa_data'



class DiseRteAgg(models.Model):
    '''
    View table:
    This is a view, also from dise_all of mid day meal availability 
    and source, and SDMC (school development monitoring committee)
    being available and functional in the school.  
    '''
    dise_info = models.ForeignKey('DiseInfo', db_column='dise_code', primary_key=True)
    rte_metric = models.CharField(max_length=36, blank=True)
    status = models.CharField(max_length=30, blank=True)
    rte_group = models.CharField(max_length=32, blank=True)

    class Meta:
        managed = False
        db_table = 'vw_dise_rte_agg'


class ElectedrepMaster(models.Model):
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


class LibBorrow(models.Model):
    '''
    View table:
    This is the base table from which the two aggregations below have been generated,
    I suppose to provide some text summaries for the graphs.
    All the logic is here : https://github.com/klpdotorg/library
    '''
    trans_year = models.CharField(max_length=30, blank=True)
    class_name = models.DecimalField(db_column='class', max_digits=3, decimal_places=0, blank=True, null=True)
    issue_date = models.CharField(max_length=20, blank=True)
    #school not unique, but we set primary key to true
    school = models.ForeignKey("School", db_column='klp_school_id', primary_key=True)
    school_name = models.CharField(max_length=50, blank=True)
    '''
    Child ID sometimes has ids like TMP00045 . What does this mean?
    How to handle this problem of the ForeignKey sometimes being an arbitrary string?    
    It's possibly okay / we write it in to some sort of exception handler.
    '''
    child = models.ForeignKey('Child', blank=True, db_column='klp_child_id')
    class Meta:
        managed = False
        db_table = 'vw_lib_borrow'


class LibLangAgg(models.Model):
    '''
    View table: 
    View from library that a school level aggregates
    how many children borrowed books in a given month
    in a given language in an Akshara library
    '''
    #school is not unique
    school = models.ForeignKey('School', db_column='klp_school_id', primary_key=True)
    class_name = models.IntegerField(db_column='class', blank=True, null=True)  # Field renamed because it was a Python reserved word.
    month = models.CharField(max_length=10, blank=True)
    year = models.CharField(max_length=10, blank=True)
    #Does this map to MT_CHOICES?
    book_lang = models.CharField(max_length=50, blank=True)
    child_count = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'vw_lib_lang_agg'


class LibLevelAgg(models.Model):
    '''
    View from library that a school level aggregates
    how many children borrowed books in a given month
    in a given difficulty level in an Akshara library
    '''
    #school is not unique, but we set primary key=True to keep django happy
    school = models.ForeignKey('School', db_column='klp_school_id', primary_key=True)
    class_name = models.IntegerField(db_column='class', blank=True, null=True)  # Field renamed because it was a Python reserved word.
    month = models.CharField(max_length=10, blank=True)
    year = models.CharField(max_length=10, blank=True)
    #FIXME: this should be defined as choices somewhere?
    book_level = models.CharField(max_length=50, blank=True)
    child_count = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'vw_lib_level_agg'


class Libinfra(models.Model):
    '''
    This is a view from libinfra and at a school level tells
    the status of a library and the infrastructure provided
    to it as part of the Akshara Library programme
    '''
    #QUESTION: should this be a OneToOneField?
    school = models.ForeignKey('School', db_column='sid', primary_key=True)
    libstatus = models.CharField(max_length=300, blank=True)
    handoveryear = models.IntegerField(blank=True, null=True)
    libtype = models.CharField(max_length=300, blank=True)
    numbooks = models.IntegerField(blank=True, null=True)
    numracks = models.IntegerField(blank=True, null=True)
    numtables = models.IntegerField(blank=True, null=True)
    numchairs = models.IntegerField(blank=True, null=True)
    numcomputers = models.IntegerField(blank=True, null=True)
    numups = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'vw_libinfra'




class MdmAgg(models.Model):
    '''
    This is a view from the db apmdm that aggregates the daily entry of 
    indent and attendance to a weekly view per school. The logic is here - 
    https://github.com/klpdotorg/importers/blob/master/apmdm/agg_apmdm.sql
    '''
    #we set primary_key=True to make django happy, though school is not unique
    school = models.ForeignKey("School", primary_key=True, db_column='id')
    mon = models.CharField(max_length=15, blank=True)
    wk = models.IntegerField(blank=True, null=True)
    indent = models.IntegerField(blank=True, null=True)
    attend = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'vw_mdm_agg'
        unique_together = ('school', 'mon', 'wk',)


class SchoolElectedrep(models.Model):
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


class SchoolEval(models.Model):
    '''

    '''
    school = models.IntegerField(db_column='sid', primary_key=True)
    dise_info = models.ForeignKey('DiseInfo', db_column='disecode', max_length=100, blank=True)
    domain = models.CharField(max_length=100, blank=True)
    question = models.ForeignKey('Question', db_column='qid', blank=True, null=True)
    value = models.CharField(max_length=50, blank=True)

    class Meta:
        managed = False
        db_table = 'vw_school_eval'


class Temp(models.Model):
    klpid = models.IntegerField(blank=True, null=True)
    name = models.TextField(blank=True)
    category = models.TextField(blank=True) # This field type is a guess.
    status = models.IntegerField(blank=True, null=True)
    type = models.CharField(max_length=300, blank=True)
    district = models.IntegerField(blank=True, null=True)
    block = models.IntegerField(blank=True, null=True)
    cluster = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'temp'

