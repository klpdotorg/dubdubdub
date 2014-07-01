from common.serializers import KLPSerializer, KLPSimpleGeoSerializer
from rest_framework import serializers
from schools.models import School, Boundary, DiseInfo, ElectedrepMaster,\
    BoundaryType, Assembly, Parliament, Postal, PaisaData


class SchoolListSerializer(KLPSerializer):

    class Meta:
        model = School
        fields = ('id', 'name',)


class BoundaryTypeSerializer(KLPSerializer):
    class Meta:
        model = BoundaryType
        fields = ('id', 'name')


class BoundarySerializer(KLPSerializer):
    type = serializers.CharField(source='get_type')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type')


class BoundaryWithParentSerializer(KLPSerializer):
    type = serializers.CharField(source='get_type')
    parent = BoundarySerializer(source='parent')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type', 'parent')


class ElectedrepSerializer(KLPSerializer):
    name = serializers.CharField(source='const_ward_name')
    type = serializers.CharField(source='const_ward_type')

    class Meta:
        model = ElectedrepMaster
        fields = ('id', 'name', 'type')


class AssemblySerializer(KLPSimpleGeoSerializer):
    class Meta:
        model = Assembly
        fields = ('id', 'name')


class ParliamentSerializer(KLPSimpleGeoSerializer):
    class Meta:
        model = Parliament
        fields = ('id', 'name')


class PincodeSerializer(KLPSimpleGeoSerializer):
    class Meta:
        model = Postal
        fields = ('id', 'pincode')


class SchoolInfoSerializer(KLPSerializer):
    dise_code = serializers.CharField(source='dise_info_id')
    admin3 = BoundarySerializer(source='schooldetails.admin3')
    admin2 = BoundarySerializer(source='schooldetails.admin2')
    admin1 = BoundarySerializer(source='schooldetails.admin1')

    type = BoundaryTypeSerializer(source='schooldetails.type')
    address_full = serializers.CharField(source='address.full')
    landmark = serializers.CharField(source='address.landmark')
    buses = serializers.CharField(source='address.bus')
    identifiers = serializers.CharField(source='address.get_identifiers')

    assembly = AssemblySerializer(source="schooldetails.assembly")
    parliament = ParliamentSerializer(source="schooldetails.parliament")
    ward = ElectedrepSerializer(source="get_ward")

    class Meta:
        model = School
        fields = ('id', 'name', 'mgmt', 'cat', 'moi', 'sex', 'address_full',
                  'landmark', 'identifiers', 'admin3', 'admin2', 'admin1',
                  'buses', 'parliament', 'assembly', 'ward',
                  'dise_code', 'type',)


class SchoolDemographicsSerializer(KLPSerializer):
    num_boys_dise = serializers.IntegerField(source='dise_info.boys_count')
    num_girls_dise = serializers.IntegerField(source='dise_info.girls_count')
    num_boys = serializers.IntegerField(source='get_num_boys')
    num_girls = serializers.IntegerField(source='get_num_girls')
    mt_profile = serializers.CharField(source='get_mt_profile')
    acyear = serializers.IntegerField(source='dise_info.acyear')

    class Meta:
        model = School
        fields = ('id', 'name', 'sex', 'moi', 'mgmt', 'num_boys_dise',
                  'num_girls_dise', 'num_boys', 'num_girls', 'mt_profile',
                  'acyear')


class SchoolProgrammesSerializer(KLPSerializer):
    class Meta:
        model = School
        fields = ('id', 'name',)


class SchoolInfraSerializer(KLPSerializer):
    acyear = serializers.CharField(source="dise_info.acyear")
    num_boys_dise = serializers.IntegerField(source='dise_info.boys_count')
    num_girls_dise = serializers.IntegerField(source='dise_info.girls_count')
    classroom_count = serializers.IntegerField(source='dise_info.classroom_count')
    lowest_class = serializers.IntegerField(source='dise_info.lowest_class')
    highest_class = serializers.IntegerField(source='dise_info.highest_class')
    teacher_count = serializers.IntegerField(source='dise_info.teacher_count')
    dise_books = serializers.IntegerField(source='dise_info.books_in_library')

    dise_rte = serializers.CharField(source='dise_info.get_rte_details')
    dise_facility = serializers.CharField(source='dise_info.get_facility_details')

    class Meta:
        model = School
        fields = ('id', 'name', 'dise_info', 'num_boys_dise',
            'num_girls_dise', 'classroom_count', 'lowest_class',
            'highest_class', 'status', 'teacher_count',
            'dise_books', 'dise_rte', 'dise_facility')


class SchoolLibrarySerializer(KLPSerializer):
    acyear = serializers.CharField(source="dise_info.acyear")
    dise_books = serializers.IntegerField(source='dise_info.books_in_library')
    lowest_class = serializers.IntegerField(source='dise_info.lowest_class')
    highest_class = serializers.IntegerField(source='dise_info.highest_class')

    lib_infra = serializers.CharField(source='get_lib_infra')
    lib_level_agg = serializers.CharField(source='get_lib_level_agg')
    lib_lang_agg = serializers.CharField(source='get_lib_lang_agg')
    lib_borrow_agg = serializers.CharField(source='get_lib_borrow_agg')

    # classtotal = serializers.CharField(source='get_total_students_in_class')

    class Meta:
        model = School
        fields = ('id', 'name', 'dise_info', 'acyear',
            'dise_books', 'lib_infra', 'lowest_class',
            'highest_class', 'lib_borrow_agg',
            'lib_level_agg', 'lib_lang_agg')


class SchoolFinanceSerializer(KLPSerializer):
    sg_recd_dise = serializers.IntegerField(source="dise_info.sg_recd")
    sg_expnd_dise = serializers.CharField(source="dise_info.sg_expnd")
    tlm_recd_dise = serializers.IntegerField(source="dise_info.tlm_recd")
    tlm_expnd_dise = serializers.CharField(source="dise_info.tlm_expnd")
    classroom_count = serializers.IntegerField(source='dise_info.classroom_count')
    teacher_count = serializers.IntegerField(source='dise_info.teacher_count')

    sg_amount = serializers.SerializerMethodField('get_sg_amount')
    smg_amount = serializers.SerializerMethodField('get_smg_amount')
    tlm_amount = serializers.SerializerMethodField('get_tlm_amount')

    class Meta:
        model = School
        fields = ('id', 'name', 'sg_recd_dise', 'sg_expnd_dise',
            'tlm_recd_dise', 'tlm_expnd_dise', 'classroom_count',
            'teacher_count', 'sg_amount', 'smg_amount', 'tlm_amount')

    def get_sg_amount(self, obj):
        grant_amount = None
        try:
            paisa = PaisaData.objects.get(criteria='school_cat', factor=obj.cat)
            grant_amount = paisa.grant_amount
        except:
            pass
        return grant_amount

    def get_smg_amount(self, obj):
        #  grant_type  | grant_amount |    criteria     | operator |    factor
        # -------------+--------------+-----------------+----------+---------------
        #  maintenance |        10000 | classroom_count | gt       | 3
        #  maintenance |         5000 | classroom_count | lt       | 3

        grant_amount = None
        try:
            paisa_criterions = PaisaData.objects.filter(criteria='classroom_count')
            for paisa in paisa_criterions:
                if paisa.operator == 'gt' and obj.dise_info.classroom_count > int(paisa.factor):
                    grant_amount = paisa.grant_amount
                elif paisa.operator == 'lt' and obj.dise_info.classroom_count <= int(paisa.factor):
                    grant_amount = paisa.grant_amount
        except:
            pass
        return grant_amount

    def get_tlm_amount(self, obj):
        grant_amount = None
        try:
            paisa = PaisaData.objects.get(criteria='teacher_count')
            grant_amount = obj.dise_info.teacher_count * paisa.grant_amount
        except Exception, e:
            raise e
        return grant_amount


class SchoolDiseSerializer(KLPSerializer):
    id = serializers.IntegerField(source="school.id")
    name = serializers.CharField(source="school.name")

    class Meta:
        model = DiseInfo
        fields = ('id', 'name', ) + \
            tuple([f.name for f in DiseInfo._meta.fields])


class SchoolDetailsSerializer(KLPSerializer):
    class Meta:
        model = Boundary
        fields = ('cluster_or_circle', 'block_or_project', 'district')
