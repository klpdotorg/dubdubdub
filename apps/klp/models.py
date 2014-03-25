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
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid')
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.sex,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_gender_singlescore'


class InstitutionAssessmentMtSinglescore(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    assessment = models.ForeignKey('Assessment', db_column='assid')
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return "%s: %s: %s" (self.school, self.assessment, self.mt,)

    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_mt_singlescore'


class InstitutionAssessmentReadingAggCohorts(models.Model):
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    school = models.ForeignKey('School', db_column='sid')
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore'

class InstitutionAssessmentSinglescoreGender(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore_gender'

class InstitutionAssessmentSinglescoreMt(models.Model):
    school = models.ForeignKey('School', db_column='sid')
    programme = models.ForeignKey('Programme', db_column='pid')
    asstext = models.CharField(max_length=50)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore_mt'

class InstitutionBasicAssessmentInfo(models.Model):
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
    assessment = models.ForeignKey('Assessment', db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_basic_assessment_info'

class InstitutionBasicAssessmentInfoCohorts(models.Model):
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    dise_code = models.CharField(max_length=14, blank=True)
    name = models.CharField(max_length=300)
    cat = models.CharField(max_length=128, choices=CAT_CHOICES)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    moi = models.CharField(max_length=128, choices=MT_CHOICES)
    mgmt = models.CharField(max_length=128, choices=MGMT_CHOICES)
    status = models.IntegerField()
    #QUESTIONS: is assembly really a foreign key to Assembly?
    #Why is assembly_name a field here?
    #assembly = models.ForeignKey('Assembly', blank=True, null=True, db_column='assembly_id')
    #assembly_name = models.CharField(max_length=35, blank=True)
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
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    school = models.ForeignKey('School', db_column='sid', blank=True, null=True)
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
    student = models.ForeignKey('Student', db_column='stuid')
    klass = models.ForeignKey('Class', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField()
    class Meta:
        managed = False
        db_table = 'tb_student_class'

class StudentEval(models.Model):
    question = models.ForeignKey('Question', db_column='qid')
    student = models.ForeignKey('Student', db_column='stuid')
    mark = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    grade = models.CharField(max_length=30, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_student_eval'

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
    assessment = models.ForeignKey('Assessment', db_column='assid')
    studentgroup = models.CharField(max_length=50)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore_mt'

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
    teacher = models.ForeignKey('Teacher', db_column='teacherid', blank=True, null=True)
    klass = models.ForeignKey('Class', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_teacher_class'

class TeacherQualification(models.Model):
    teacher = models.ForeignKey('Teacher', db_column='tid')
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
        This is a table to map the key values of anginfra_agg
        into readable text on the Webpage
        QUESTION: Should 'key' be a ForeignKey? To what?
    '''
    key = models.CharField(max_length=30, primary_key=True)
    value = models.CharField(max_length=200)
    class Meta:
        managed = False
        db_table = 'vw_ang_display_master'





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

