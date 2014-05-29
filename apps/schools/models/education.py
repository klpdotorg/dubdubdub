from __future__ import unicode_literals
from common.models import BaseModel, GeoBaseModel
from .choices import CAT_CHOICES, MGMT_CHOICES, MT_CHOICES, SEX_CHOICES
from django.contrib.gis.db import models
import json


class AcademicYear(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20, blank=True)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_academic_year'


class Address(BaseModel):
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

    @property
    def full(self):
        return ', '.join(filter(None, [
            self.address, self.area, self.pincode
        ]))

    def get_identifiers(self):
        return ', '.join(filter(None, [
            self.instidentification, self.instidentification2
        ]))

    class Meta:
        managed = False
        db_table = 'tb_address'


class BoundaryHierarchy(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_bhierarchy'


class Boundary(BaseModel):
    id = models.IntegerField(primary_key=True)
    parent = models.ForeignKey("Boundary", blank=True, null=True, db_column='parent')
    name = models.CharField(max_length=300)
    hierarchy = models.ForeignKey(BoundaryHierarchy, db_column='hid')
    type = models.ForeignKey('BoundaryType', db_column='type')

    def __unicode__(self):
        return self.name

    def get_type(self):
        return self.type.name

    def get_geometry(self):
        if hasattr(self, 'boundarycoord'):
            return json.loads(self.boundarycoord.coord.geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'tb_boundary'


class BoundaryType(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_boundary_type'


class BoundaryPrimarySchool(BaseModel):
    cluster = models.ForeignKey("Boundary", primary_key=True, db_column="cluster_id", related_name="boundary_ps_cluster")
    block = models.ForeignKey("Boundary", db_column="block_id", related_name="boundary_ps_block")
    district = models.ForeignKey("Boundary", db_column="district_id", related_name="boundary_ps_district")

    def __unicode__(self):
        return self.cluster.name

    class Meta:
        managed = False
        db_table = 'mvw_boundary_primary'


class Child(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300, blank=True)
    dob = models.DateField(blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_child'


class StudentGroup(BaseModel):
    id = models.IntegerField(primary_key=True)
    school = models.ForeignKey("School", blank=True, null=True, db_column="sid")
    name = models.CharField(max_length=50)
    section = models.CharField(max_length=1, blank=True)
    students = models.ManyToManyField("Student", through="StudentStudentGroup")
    teachers = models.ManyToManyField("Teacher", through="TeacherStudentGroup")

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_class'


class School(GeoBaseModel):
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

    def __unicode__(self):
        return self.name

    def get_dise_code(self):
        return self.dise_info_id

    '''
    def get_info_properties(self):
        data = self.get_list_properties()

        # dise_info field itself has the dise_code,
        # calling related field makes unnecessary queries
        data['dise_code'] = self.dise_info_id

        #QUESTION: how to get 'type'? #ANSWER School > Boundary > BoundaryType
        data['type'] = self.boundary.type_id

        data['management'] = self.get_mgmt_display()
        data['category'] = self.get_cat_display()
        data['medium_of_instruction'] = self.get_moi_display()

        data['address'] = self.address.full if self.address else ''

        #FIXME: add data['photos'] - where does this come from?
        return data
    '''

    def get_geometry(self):
        if hasattr(self, 'instcoord'):
            return json.loads(self.instcoord.coord.geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'tb_school'


class Student(BaseModel):
    id = models.IntegerField(primary_key=True)
    child = models.ForeignKey('Child', db_column='cid')
    otherstudentid = models.CharField(max_length=100, blank=True)
    status = models.IntegerField()

    def __unicode__(self):
        return "%s" % self.child

    class Meta:
        managed = False
        db_table = 'tb_student'


class StudentStudentGroup(BaseModel):
    student = models.ForeignKey('Student', db_column='stuid', primary_key=True)
    student_group = models.ForeignKey('StudentGroup', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField()

    def __unicode__(self):
        return "%s: %s in %s" % (self.student, self.student_group, self.academic_year,)
    class Meta:
        managed = False
        db_table = 'tb_student_class'


class Teacher(BaseModel):
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


class TeacherStudentGroup(BaseModel):
    teacher = models.ForeignKey('Teacher', db_column='teacherid', primary_key=True)
    student_group = models.ForeignKey('StudentGroup', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s in %s" % (self.teacher, self.student_group, self.academic_year,)

    class Meta:
        managed = False
        db_table = 'tb_teacher_class'


class TeacherQualification(BaseModel):
    teacher = models.ForeignKey('Teacher', db_column='tid', primary_key=True)
    qualification = models.CharField(max_length=100)

    def __unicode__(self):
        return "%s: %s" % (self.teacher, self.qualification,)

    class Meta:
        managed = False
        db_table = 'tb_teacher_qual'
