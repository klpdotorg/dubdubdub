from common.models import BaseModel, GeoBaseModel
from django.db import models
import json
from schools.models.choices import CAT_CHOICES, MGMT_CHOICES, MT_CHOICES,\
    SEX_CHOICES, ALLOWED_GENDER_CHOICES


class EMSAddress(BaseModel):
    address = models.CharField(max_length=1000, blank=True)
    area = models.CharField(max_length=1000, blank=True)
    pincode = models.CharField(max_length=20, blank=True)
    landmark = models.CharField(max_length=1000, blank=True)
    instidentification = models.CharField(max_length=1000, blank=True)
    bus = models.CharField(max_length=1000, blank=True, db_column="route_information")
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
        db_table = 'ems_tb_address'
        verbose_name_plural = 'Addresses'


class EMSBoundary(BaseModel):
    parent = models.ForeignKey("EMSBoundary", blank=True, null=True,
                               db_column='parent', on_delete=models.SET_NULL)
    name = models.CharField(max_length=300)
    hierarchy = models.ForeignKey('schools.BoundaryHierarchy', db_column='hid')
    type = models.ForeignKey('schools.BoundaryType', db_column='type')

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

    def get_geometry(self):
        if hasattr(self, 'boundarycoord'):
            return json.loads(self.boundarycoord.coord.geojson)
        else:
            return {}

    class Meta:
        managed = False
        db_table = 'ems_tb_boundary'
        verbose_name_plural = 'Boundaries'


class EMSSchool(GeoBaseModel):
    admin3 = models.ForeignKey('schools.Boundary', db_column='boundary_id')

    address = models.OneToOneField('EMSAddress', db_column='inst_address_id',
                                   blank=True, null=True)
    dise_info = models.OneToOneField('schools.DiseInfo', db_column='dise_code',
                                     blank=True, null=True)
    name = models.CharField(max_length=300, db_column='inst_name')
    cat = models.CharField(max_length=128, choices=CAT_CHOICES, db_column='inst_category')
    sex = models.CharField(max_length=128, choices=ALLOWED_GENDER_CHOICES, db_column='institution_gender')
    moi = models.CharField(max_length=128, choices=MT_CHOICES)
    mgmt = models.CharField(max_length=128, choices=MGMT_CHOICES, db_column='management')
    status = models.IntegerField(db_column='active')

    def __unicode__(self):
        return '%s: %s' % (self.id, self.name)

    class Meta:
        managed = False
        db_table = 'ems_tb_school'


class EMSChild(BaseModel):
    id = models.IntegerField(primary_key=True)
    first_name = models.CharField(max_length=300, blank=True)
    middle_name = models.CharField(max_length=300, blank=True)
    last_name = models.CharField(max_length=300, blank=True)
    dob = models.DateField(blank=True, null=True)
    sex = models.CharField(max_length=128, choices=SEX_CHOICES, db_column='gender')
    mt = models.CharField(max_length=128, choices=MT_CHOICES)

    def __unicode__(self):
        return self.name

    @property
    def name(self):
        return ' '.join(filter(None, [self.first_name, self.middle_name, self.last_name]))

    class Meta:
        managed = False
        db_table = 'ems_tb_child'


class EMSStudent(BaseModel):
    id = models.IntegerField(primary_key=True)
    child = models.ForeignKey('EMSChild', db_column='cid')
    otherstudentid = models.CharField(max_length=100, blank=True)
    status = models.IntegerField()

    def __unicode__(self):
        return "%s" % self.child

    class Meta:
        managed = False
        db_table = 'ems_tb_student'
