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

class Assembly(models.Model):
    ogc_fid = models.IntegerField(primary_key=True)
    wkb_geometry = models.PolygonField(blank=True, null=True)
    ac_id = models.IntegerField(blank=True, null=True)
    ac_no = models.FloatField(blank=True, null=True)
    ac_name = models.CharField(max_length=35, blank=True)
    state_ut = models.CharField(max_length=35, blank=True)
    objects = models.GeoManager()
    class Meta:
        managed = False
        db_table = 'assembly'

class TbAcademicYear(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_academic_year'

class TbAddress(models.Model):
    id = models.IntegerField(primary_key=True)
    address = models.CharField(max_length=1000, blank=True)
    area = models.CharField(max_length=1000, blank=True)
    pincode = models.CharField(max_length=20, blank=True)
    landmark = models.CharField(max_length=1000, blank=True)
    instidentification = models.CharField(max_length=1000, blank=True)
    bus = models.CharField(max_length=1000, blank=True)
    instidentification2 = models.CharField(max_length=1000, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_address'

class TbAngpre2011Agg(models.Model):
    sid = models.IntegerField(blank=True, null=True)
    gender = models.CharField(max_length=8, blank=True)
    stucount = models.IntegerField(blank=True, null=True)
    min_score = models.IntegerField(blank=True, null=True)
    max_score = models.IntegerField(blank=True, null=True)
    median_score = models.IntegerField(blank=True, null=True)
    avg_score = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_angpre_2011_agg'

class TbAssessment(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    pid = models.ForeignKey('TbProgramme', db_column='pid', blank=True, null=True)
    start = models.DateField(blank=True, null=True)
    end = models.DateField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_assessment'

class TbBhierarchy(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    class Meta:
        managed = False
        db_table = 'tb_bhierarchy'

class TbBoundary(models.Model):
    id = models.IntegerField(primary_key=True)
    parent = models.IntegerField(blank=True, null=True)
    name = models.CharField(max_length=300)
    hid = models.ForeignKey(TbBhierarchy, db_column='hid')
    type = models.ForeignKey('TbBoundaryType', db_column='type')
    class Meta:
        managed = False
        db_table = 'tb_boundary'

class TbBoundaryType(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    class Meta:
        managed = False
        db_table = 'tb_boundary_type'

class TbChild(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    dob = models.DateField(blank=True, null=True)
    sex = models.TextField() # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    class Meta:
        managed = False
        db_table = 'tb_child'

class TbClass(models.Model):
    id = models.IntegerField(primary_key=True)
    sid = models.IntegerField(blank=True, null=True)
    name = models.CharField(max_length=50)
    section = models.CharField(max_length=1, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_class'

class TbInstitutionAgg(models.Model):
    school_id = models.ForeignKey('TbSchool', db_column='id', blank=True, null=True)
    name = models.CharField(max_length=300, blank=True)
    bid = models.ForeignKey(TbBoundary, db_column='bid', blank=True, null=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_agg'

class TbInstitutionAssessmentAgg(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    aggval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_agg'

class TbInstitutionAssessmentAggCohorts(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    cohortsval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_agg_cohorts'

class TbInstitutionAssessmentGenderSinglescore(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    sex = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_gender_singlescore'

class TbInstitutionAssessmentMtSinglescore(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    mt = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_mt_singlescore'

class TbInstitutionAssessmentReadingAggCohorts(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    domain = models.CharField(max_length=100, blank=True)
    domain_order = models.IntegerField(blank=True, null=True)
    aggtext = models.CharField(max_length=100)
    aggtext_order = models.IntegerField()
    cohortsval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_reading_agg_cohorts'

class TbInstitutionAssessmentSinglescore(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid')
    pid = models.ForeignKey('TbProgramme', db_column='pid')
    asstext = models.CharField(max_length=50)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore'

class TbInstitutionAssessmentSinglescoreGender(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid')
    pid = models.ForeignKey('TbProgramme', db_column='pid')
    asstext = models.CharField(max_length=50)
    sex = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore_gender'

class TbInstitutionAssessmentSinglescoreMt(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid')
    pid = models.ForeignKey('TbProgramme', db_column='pid')
    asstext = models.CharField(max_length=50)
    mt = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    order = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_assessment_singlescore_mt'

class TbInstitutionBasicAssessmentInfo(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_basic_assessment_info'

class TbInstitutionBasicAssessmentInfoCohorts(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    studentgroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    cohortsnum = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_institution_basic_assessment_info_cohorts'

class TbPartner(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    status = models.IntegerField()
    info = models.CharField(max_length=500, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_partner'

class TbPreschoolAssessmentAgg(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    agegroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    aggtext = models.CharField(max_length=100)
    aggval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_preschool_assessment_agg'

class TbPreschoolBasicAssessmentInfo(models.Model):
    sid = models.ForeignKey('TbSchool', db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    agegroup = models.CharField(max_length=50, blank=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_preschool_basic_assessment_info'

class TbProgramme(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)
    start = models.DateField(blank=True, null=True)
    end = models.DateField(blank=True, null=True)
    type = models.ForeignKey(TbBoundaryType, db_column='type')
    ayid = models.ForeignKey(TbAcademicYear, db_column='ayid', blank=True, null=True)
    partnerid = models.ForeignKey(TbPartner, db_column='partnerid', blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_programme'

class TbQuestion(models.Model):
    id = models.IntegerField(primary_key=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    desc = models.CharField(max_length=100)
    qtype = models.IntegerField(blank=True, null=True)
    maxmarks = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)
    minmarks = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)
    grade = models.CharField(max_length=100, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_question'

class TbSchool(models.Model):
    id = models.IntegerField(primary_key=True)
    bid = models.ForeignKey(TbBoundary, db_column='bid')
    aid = models.ForeignKey(TbAddress, db_column='aid', blank=True, null=True)
    dise_code = models.CharField(max_length=14, blank=True)
    name = models.CharField(max_length=300)
    cat = models.TextField(blank=True) # This field type is a guess.
    sex = models.TextField(blank=True) # This field type is a guess.
    moi = models.TextField(blank=True) # This field type is a guess.
    mgmt = models.TextField(blank=True) # This field type is a guess.
    status = models.IntegerField()
    assembly_id = models.IntegerField(blank=True, null=True)
    assembly_name = models.CharField(max_length=35, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_school'

class TbSchoolAgg(models.Model):
    school_id = models.IntegerField(db_column='id', blank=True, null=True)
    name = models.CharField(max_length=300, blank=True)
    bid = models.IntegerField(blank=True, null=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_agg'

class TbSchoolAssessmentAgg(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    clid = models.ForeignKey(TbClass, db_column='clid', blank=True, null=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    aggtext = models.CharField(max_length=100)
    aggval = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_assessment_agg'

class TbSchoolBasicAssessmentInfo(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid', blank=True, null=True)
    assid = models.ForeignKey(TbAssessment, db_column='assid', blank=True, null=True)
    clid = models.ForeignKey(TbClass, db_column='clid', blank=True, null=True)
    sex = models.TextField(blank=True) # This field type is a guess.
    mt = models.TextField(blank=True) # This field type is a guess.
    num = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_school_basic_assessment_info'

class TbStudent(models.Model):
    id = models.IntegerField(primary_key=True)
    cid = models.ForeignKey(TbChild, db_column='cid')
    otherstudentid = models.CharField(max_length=100, blank=True)
    status = models.IntegerField()
    class Meta:
        managed = False
        db_table = 'tb_student'

class TbStudentClass(models.Model):
    stuid = models.ForeignKey(TbStudent, db_column='stuid')
    clid = models.ForeignKey(TbClass, db_column='clid')
    ayid = models.ForeignKey(TbAcademicYear, db_column='ayid')
    status = models.IntegerField()
    class Meta:
        managed = False
        db_table = 'tb_student_class'

class TbStudentEval(models.Model):
    qid = models.ForeignKey(TbQuestion, db_column='qid')
    stuid = models.ForeignKey(TbStudent, db_column='stuid')
    mark = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    grade = models.CharField(max_length=30, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_student_eval'

class TbStudentgroupAssessmentGenderSinglescore(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    studentgroup = models.CharField(max_length=50)
    sex = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_gender_singlescore'

class TbStudentgroupAssessmentMtSinglescore(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    studentgroup = models.CharField(max_length=50)
    mt = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_mt_singlescore'

class TbStudentgroupAssessmentSinglescore(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    studentgroup = models.CharField(max_length=50)
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore'

class TbStudentgroupAssessmentSinglescoreGender(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    studentgroup = models.CharField(max_length=50)
    sex = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore_gender'

class TbStudentgroupAssessmentSinglescoreMt(models.Model):
    sid = models.ForeignKey(TbSchool, db_column='sid')
    assid = models.ForeignKey(TbAssessment, db_column='assid')
    studentgroup = models.CharField(max_length=50)
    mt = models.TextField() # This field type is a guess.
    singlescore = models.DecimalField(max_digits=6, decimal_places=2, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_studentgroup_assessment_singlescore_mt'

class TbTeacher(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    sex = models.TextField() # This field type is a guess.
    status = models.IntegerField(blank=True, null=True)
    mt = models.TextField(blank=True) # This field type is a guess.
    dateofjoining = models.DateField(blank=True, null=True)
    type = models.CharField(max_length=50, blank=True)
    class Meta:
        managed = False
        db_table = 'tb_teacher'

class TbTeacherClass(models.Model):
    teacherid = models.ForeignKey(TbTeacher, db_column='teacherid', blank=True, null=True)
    clid = models.ForeignKey(TbClass, db_column='clid')
    ayid = models.ForeignKey(TbAcademicYear, db_column='ayid')
    status = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'tb_teacher_class'

class TbTeacherQual(models.Model):
    tid = models.ForeignKey(TbTeacher, db_column='tid')
    qualification = models.CharField(max_length=100)
    class Meta:
        managed = False
        db_table = 'tb_teacher_qual'

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

