from __future__ import unicode_literals

import json

from common.utils import cached_property
from stories.models import StoryImage, Question
from common.models import BaseModel, GeoBaseModel

from django.conf import settings
from django.contrib.gis.db import models
from django.db.models import Sum, Count, Q
from django.core.urlresolvers import reverse

from .partners import DiseInfo
from .partners import LibLevelAgg
from .choices import (
    CAT_CHOICES, MGMT_CHOICES, MT_CHOICES,
    SEX_CHOICES, ALLOWED_GENDER_CHOICES, STATUS_CHOICES)


class StatusManager(models.Manager):
    def all_active(self):
        return self.filter(status=2)

    def all_inactive(self):
        return self.filter(status=1)

    def all_deleted(self):
        return self.filter(status=0)


class AcademicYear(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=20, blank=True)
    to_year = models.IntegerField(null=True, blank=True)
    from_year = models.IntegerField(null=True, blank=True)

    def __unicode__(self):
        return "%s-%s" % (self.from_year, self.to_year)

    class Meta:
        db_table = 'tb_academic_year'


class Address(BaseModel):
    address = models.CharField(max_length=1000, blank=True)
    area = models.CharField(max_length=1000, blank=True)
    pincode = models.CharField(max_length=20, blank=True)
    landmark = models.CharField(max_length=1000, blank=True)
    instidentification = models.CharField(max_length=1000, blank=True)
    bus = models.CharField(max_length=1000, blank=True)
    instidentification2 = models.CharField(max_length=1000, blank=True)

    def __unicode__(self):
        return self.full

    @property
    def full(self):
        return ', '.join(filter(lambda x: bool(x.strip()) if x else False, [
            self.address, self.area, self.pincode
        ]))

    @property
    def identifires(self):
        return self.get_identifiers()

    def get_identifiers(self):
        return ', '.join(filter(None, [
            self.instidentification, self.instidentification2
        ])) or None

    class Meta:
        managed = False
        db_table = 'tb_address'
        verbose_name_plural = 'Addresses'


class BoundaryHierarchy(BaseModel):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=300)

    def __unicode__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'tb_bhierarchy'


class Boundary(BaseModel):
    parent = models.ForeignKey("Boundary", blank=True, null=True,
                               db_column='parent', on_delete=models.SET_NULL)
    name = models.CharField(max_length=300)
    dise_slug = models.SlugField(max_length=300)
    hierarchy = models.ForeignKey('BoundaryHierarchy', db_column='hid')
    type = models.ForeignKey('BoundaryType', db_column='type')
    status = models.IntegerField(choices=STATUS_CHOICES)
    users = models.ManyToManyField('users.User', through='BoundaryUsers')

    objects = StatusManager()

    def __unicode__(self):
        return self.name

    def get_type(self):
        return self.hierarchy.name

    def get_school_type(self):
        if self.hierarchy_id in [9, 10, 11]:
            return 'primaryschool'
        elif self.hierarchy_id in [13, 14, 15]:
            return 'preschool'
        else:
            return 'school'

    def get_admin_level(self):
        if self.hierarchy_id in [9, 13]:
            return 1
        elif self.hierarchy_id in [10, 14]:
            return 2
        elif self.hierarchy_id in [11, 15]:
            return 3
        else:
            return False

    def get_geometry(self):
        if hasattr(self, 'boundarycoord'):
            return json.loads(self.boundarycoord.coord.geojson)
        else:
            return {}

    def schools(self):
        return School.objects.filter(
            Q(status=2),
            Q(schooldetails__admin1=self) | Q(schooldetails__admin2=self) | Q(schooldetails__admin3=self)
        )

    def dise_schools(self):
        return DiseInfo.objects.filter(
            Q(school__schooldetails__admin1=self) | Q(school__schooldetails__admin2=self) | Q(school__schooldetails__admin3=self)
        )

    class Meta:
        managed = False
        db_table = 'tb_boundary'
        verbose_name_plural = 'Boundaries'


class BoundaryUsers(BaseModel):
    user = models.ForeignKey('users.User')
    boundary = models.ForeignKey(Boundary)

    class Meta:
        unique_together = ('user', 'boundary')


class BoundaryType(BaseModel):
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
    admin3 = models.ForeignKey('Boundary', db_column='bid')

    address = models.OneToOneField('Address', db_column='aid',
                                   blank=True, null=True)
    dise_info = models.OneToOneField('DiseInfo', db_column='dise_code',
                                     blank=True, null=True)
    name = models.CharField(max_length=300)
    cat = models.CharField(max_length=128, choices=CAT_CHOICES)
    sex = models.CharField(max_length=128, choices=ALLOWED_GENDER_CHOICES)
    moi = models.CharField(max_length=128, choices=MT_CHOICES)
    mgmt = models.CharField(max_length=128, choices=MGMT_CHOICES)
    status = models.IntegerField(choices=STATUS_CHOICES)

    objects = StatusManager()

    def __unicode__(self):
        return "%s: %s" % (self.id, self.name)

    def get_absolute_url(self):
        return reverse('school_page', kwargs={'pk': self.id})

    def get_dise_code(self):
        return self.dise_info_id

    def get_ward(self):
        try:
            return self.electedrep.ward
        except:
            return None

    def get_images(self):
        return [image.image.url for image in StoryImage.objects.filter(
            is_verified=True, story__is_verified=True, story__school=self
        )]

    @cached_property
    def has_volunteer_activities(self):
        return self.volunteeractivity_set.all().count() > 0

    @cached_property
    def full_address(self):
        return self.address.full if (self.address and self.address.full) else self.admin3.name.title()

    def get_basic_facilities(self):
        facilities = {
            'computer_lab': False,
            'library': False,
            'playground': False
        }

        try:
            # self.dise_info can be None or raise DoesNotExist
            # Need to handle both
            if not self.dise_info:
                raise Exception('no dise')
        except Exception:
            return facilities

        for facility in self.dise_info.disefacilityagg_set.all():
            if facility.df_metric_id in facilities.keys():
                facilities[facility.df_metric_id] = (facility.score == 100)

        return facilities

    def get_questions(self):
        questions = Question.objects.filter(
            school_type=self.schooldetails.type,
            is_active=True
        )
        return questions

    def get_mt_profile(self):
        profile = {}
        acyear = AcademicYear.objects.get(name=settings.DEFAULT_ACADEMIC_YEAR)
        for agg in self.institutionagg_set.filter(academic_year=acyear):
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
            print e
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
            temp = self.schoolclasstotalyear_set.all().select_related('academic_year')
            data = list()

            for t in temp:
                d = dict()
                d['clas'] = t.clas
                d['total'] = t.total
                d['academic_year'] = t.academic_year.name
                data.append(d)
        except Exception, e:
            print e
        return data

    def get_geometry(self):
        if hasattr(self, 'instcoord'):
            return json.loads(self.instcoord.coord.geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'tb_school'


class SchoolExtra(BaseModel):
    school = models.ForeignKey('School')
    academic_year = models.ForeignKey('AcademicYear')

    num_boys = models.IntegerField(blank=True, null=True, db_column='num_boys')
    num_girls = models.IntegerField(blank=True, null=True, db_column='num_girls')

    class Meta:
        managed = False
        db_table = 'mvw_school_extra'


class SchoolDetails(BaseModel):
    school = models.OneToOneField('School', db_column='id', primary_key=True)
    admin3 = models.ForeignKey("Boundary", db_column="cluster_or_circle_id",
                               related_name="sd_admin3")
    admin2 = models.ForeignKey("Boundary", db_column="block_or_project_id",
                               related_name="sd_admin2")
    admin1 = models.ForeignKey("Boundary", db_column="district_id",
                               related_name="sd_admin1")
    type = models.ForeignKey('BoundaryType', db_column='stype')
    assembly = models.ForeignKey('Assembly', db_column='assembly_id')
    parliament = models.ForeignKey('Parliament', db_column='parliament_id')
    postal = models.ForeignKey('Postal', db_column='pin_id')

    def __unicode__(self):
        return str(self.pk)

    @cached_property
    def num_boys(self):
        acyear = AcademicYear.objects.get(name=settings.DEFAULT_ACADEMIC_YEAR)
        try:
            extra = SchoolExtra.objects.get(school=self.school, academic_year=acyear)
            return extra.num_boys
        except Exception, e:
            return None

    @cached_property
    def num_girls(self):
        acyear = AcademicYear.objects.get(name=settings.DEFAULT_ACADEMIC_YEAR)
        try:
            extra = SchoolExtra.objects.get(school=self.school, academic_year=acyear)
            return extra.num_girls
        except Exception, e:
            return None

    class Meta:
        managed = False
        db_table = 'mvw_school_details'


class SchoolClassTotalYear(BaseModel):
    school = models.ForeignKey('School', db_column='schid', primary_key=True)
    clas = models.IntegerField(db_column='clas')
    total = models.IntegerField(db_column='total')
    academic_year = models.ForeignKey('AcademicYear', db_column='academic_year')

    class Meta:
        managed = False
        db_table = 'mvw_school_class_total_year'


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


class MeetingReport(BaseModel):
    school = models.ForeignKey('School')
    pdf = models.FileField(upload_to='meeting_reports')
    language = models.CharField(max_length=128)
    generated_at = models.DateField(blank=True, null=True)

    def __unicode__(self):
        return "%d: %s" % (self.school.id, self.language,)



class SchoolAggregation(BaseModel):
    school = models.ForeignKey('School')
    academic_year = models.ForeignKey('AcademicYear')
    boundary= models.ForeignKey("Boundary", db_column="boundary_id")
    gender= models.CharField(max_length=128, choices=ALLOWED_GENDER_CHOICES)
    mt = models.CharField(max_length=128, choices=MT_CHOICES)
    num= models.IntegerField(blank=True, null=True, db_column='num')

    class Meta:
        managed = False
        db_table = 'mvw_institution_aggregations'



