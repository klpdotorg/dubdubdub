from __future__ import unicode_literals
from common.models import BaseModel, GeoBaseModel
from .choices import CAT_CHOICES, MGMT_CHOICES, MT_CHOICES,\
    SEX_CHOICES, ALLOWED_GENDER_CHOICES
from .partners import LibLevelAgg
from django.contrib.gis.db import models
from django.db.models import Sum, Count
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
        return ', '.join(filter(lambda x: bool(x.strip()) if x else False, [
            self.address, self.area, self.pincode
        ]))

    def get_identifiers(self):
        return ', '.join(filter(None, [
            self.instidentification, self.instidentification2
        ])) or None

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
    parent = models.ForeignKey("Boundary", blank=True, null=True,
                               db_column='parent', on_delete=models.SET_NULL)
    name = models.CharField(max_length=300)
    hierarchy = models.ForeignKey(BoundaryHierarchy, db_column='hid')
    type = models.ForeignKey('BoundaryType', db_column='type')

    def __unicode__(self):
        return self.name

    def get_type(self):
        return self.hierarchy.name

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
    # Note: Because these have reference to Boundary,
    # we can get the schools belonging to these using that.
    # so, self.cluster.school_set.all() sould return all schools belonging
    # to that cluster. Needs more testing.

    cluster = models.ForeignKey("Boundary", primary_key=True,
                                db_column="cluster_id",
                                related_name="boundary_ps_cluster")
    block = models.ForeignKey("Boundary", db_column="block_id",
                              related_name="boundary_ps_block")
    district = models.ForeignKey("Boundary", db_column="district_id",
                                 related_name="boundary_ps_district")

    def __unicode__(self):
        return self.cluster.name

    class Meta:
        managed = False
        db_table = 'mvw_boundary_primary'

    def get_schools_in_cluster(self):
        return self.cluster.school_set.all()


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
    school = models.ForeignKey("School", blank=True, null=True,
                               db_column="sid", on_delete=models.SET_NULL)
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

    boundary_cluster = models.ForeignKey('Boundary', db_column='bid')

    # TODO: check if address should be ForeignKey or OneToOneField
    # CHECK: http://hastebin.com/awotomoven aid appears once for each school
    address = models.OneToOneField('Address', db_column='aid',
                                   blank=True, null=True)
    dise_info = models.OneToOneField('DiseInfo', db_column='dise_code',
                                     blank=True, null=True)
    name = models.CharField(max_length=300)
    cat = models.CharField(max_length=128, choices=CAT_CHOICES)
    sex = models.CharField(max_length=128, choices=ALLOWED_GENDER_CHOICES)
    moi = models.CharField(max_length=128, choices=MT_CHOICES)
    mgmt = models.CharField(max_length=128, choices=MGMT_CHOICES)
    status = models.IntegerField()

    def __unicode__(self):
        return self.name

    def get_dise_code(self):
        return self.dise_info_id

    def get_boundary(self):
        if self.boundary_cluster.type_id == 1:
            return BoundaryPrimarySchool.objects.\
                get(cluster_id=self.boundary_cluster_id) if \
                self.boundary_cluster_id else None
        else:
            # TBD: return BoundaryPreschool when ready
            return None

    def get_num_boys(self):
        sum_query = self.institutionagg_set.filter(sex='male').\
            aggregate(Sum('num'))
        return sum_query['num__sum']

    def get_num_girls(self):
        sum_query = self.institutionagg_set.filter(sex='female').\
            aggregate(Sum('num'))
        return sum_query['num__sum']

    def get_ward(self):
        try:
            return self.electedrep.ward
        except:
            return None

    def get_mt_profile(self):
        profile = {}
        for agg in self.institutionagg_set.all():
            if agg.mt in profile:
                profile[agg.mt] += agg.num
            else:
                profile[agg.mt] = agg.num
        return profile

    def get_lib_infra(self):
        lib_infra = {}
        try:
            lib_infra['Status of the Library'] = self.libinfra.libstatus
            lib_infra['Type in Hub-Spoke model'] = self.libinfra.libtype
            lib_infra['Number of Books'] = self.libinfra.numbooks
            lib_infra['Number of Racks'] = self.libinfra.numracks
            lib_infra['Number of Tables'] = self.libinfra.numtables
            lib_infra['Number of Chairs'] = self.libinfra.numchairs
            lib_infra['Number of Computers'] = self.libinfra.numcomputers
            lib_infra['Number of UPS(s)'] = self.libinfra.numups
        except Exception, e:
            pass
        return lib_infra

    def get_lib_level_agg(self):
        data = None

        from collections import defaultdict
        data_grouped_by_color = defaultdict(list)

        try:
            data = self.liblevelagg_set.all().values()
            for d in data:
                data_grouped_by_color[d['book_level']].append(d)
                # delete above and uncomment following to remove
                # book_level from data
                # data_grouped_by_color[d.pop('book_level')].append(d)
        except:
            pass
        return data_grouped_by_color

    def get_lib_lang_agg(self):
        data = None

        from collections import defaultdict
        data_grouped_by_lang = defaultdict(list)

        try:
            data = self.liblangagg_set.all().values()
            for d in data:
                data_grouped_by_lang[d['book_lang']].append(d)
                # delete above and uncomment following to remove
                # book_level from data
                # data_grouped_by_color[d.pop('book_level')].append(d)
        except:
            pass
        return data_grouped_by_lang

    def get_lib_borrow_agg(self):
        data = None
        try:
            data = self.libborrow_set.extra(
                select={
                    'trans_month': 'getmonth(split_part(issue_date,\'/\',2))'
                }
            ).values('trans_year', 'class_name', 'trans_month').annotate(child_count=Count('child_id'))
        except Exception, e:
            raise e
        return data

    def get_total_students_in_class(self):
        data = None
        try:
            data = self.studentgroup_set.filter(
                students__studentstudentgroup__student__status=2,
                students__studentstudentgroup__academic_year__name__in=LibLevelAgg.objects.values_list('year').distinct(),
            ).extra(
                select={
                    'class_name': 'trim("tb_class"."name")',
                    'academic_year': '"tb_academic_year"."name"',
                }
            ).annotate(Count('students__studentstudentgroup__student', distinct=True)).values()
        except Exception, e:
            raise e
        return data

    def get_geometry(self):
        if hasattr(self, 'instcoord'):
            return json.loads(self.instcoord.coord.geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'tb_school'


class SchoolDetails(BaseModel):
    school = models.OneToOneField('School', db_column='id', primary_key=True)
    admin3 = models.ForeignKey("Boundary", db_column="cluster_or_circle_id",
                               related_name="sd_admin3")
    admin2 = models.ForeignKey("Boundary", db_column="block_or_project_id",
                               related_name="sd_admin2")
    admin1 = models.ForeignKey("Boundary", db_column="district_id",
                               related_name="sd_admin1")
    type = models.ForeignKey('BoundaryType', db_column='type')
    assembly = models.ForeignKey('Assembly', db_column='assembly_id')
    parliament = models.ForeignKey('Parliament', db_column='parliament_id')
    postal = models.ForeignKey('Postal', db_column='pin_id')

    def __unicode__(self):
        return str(self.pk)

    class Meta:
        managed = False
        db_table = 'mvw_school_details'


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
        return "%s: %s in %s" % (self.student, self.student_group,
                                 self.academic_year,)

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
    teacher = models.ForeignKey('Teacher', db_column='teacherid',
                                primary_key=True)
    student_group = models.ForeignKey('StudentGroup', db_column='clid')
    academic_year = models.ForeignKey('AcademicYear', db_column='ayid')
    status = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return "%s: %s in %s" % (self.teacher, self.student_group,
                                 self.academic_year,)

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
