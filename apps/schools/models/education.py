from __future__ import unicode_literals
from common.models import BaseModel, GeoBaseModel
from .choices import CAT_CHOICES, MGMT_CHOICES, MT_CHOICES, SEX_CHOICES
from django.contrib.gis.db import models
from schools.managers import SchoolsManager

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
    objects = SchoolsManager()

    def __unicode__(self):
        return self.name

    def get_list_properties(self):
        return {
            'id': self.id,
            'name': self.name
        }

    def get_info_properties(self):
        data = self.get_list_properties()

        try:
            # dise_info field itself has the dise_code,
            # calling related field makes unnecessary queries
            data['dise_code'] = self.dise_info_id
        except:
            data['dise_code'] = None

        #FIXME: add data['type'] #QUESTION: how to get 'type'?
        data['management'] = self.mgmt
        data['category'] = self.cat

        #FIXME: this should probably be a method of address to get formatted address
        if self.address:
            data['address'] = self.address.address
        else:
            data['address'] = ''

        #FIXME: add data['photos'] - where does this come from?
        return data

    def get_geometry(self):
        try:
            return json.loads(self.instcoord.coord.geojson)
        except:
            return {}

    def get_list_geojson(self):
        return {
            'geometry': self.get_geometry(),
            'properties': self.get_list_properties()
        }

    def get_info_geojson(self):
        return {
            'geometry': self.get_geometry(),
            'properties': self.get_info_properties()
        }

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
