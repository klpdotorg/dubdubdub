from django.db.models import Sum
from common.serializers import KLPSerializer, KLPSimpleGeoSerializer
from rest_framework import serializers
from schools.models import (School, Boundary, DiseInfo, ElectedrepMaster,
    BoundaryType, Assembly, Parliament, Postal, PaisaData, MdmAgg,InstitutionAssessmentCohorts,InstitutionAssessmentSinglescore,InstitutionAssessmentSinglescoreGender,InstitutionAssessmentSinglescoreMt,BoundaryAssessmentSinglescore)


class BoundaryTypeSerializer(KLPSerializer):
    class Meta:
        model = BoundaryType
        fields = ('id', 'name')


class BoundarySerializer(KLPSerializer):
    type = serializers.CharField(source='hierarchy.name')
    school_type = serializers.CharField(source='get_school_type')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type', 'school_type')


class BoundaryWithParentSerializer(KLPSerializer):
    type = serializers.CharField(source='hierarchy.name')
    school_type = serializers.CharField(source='get_school_type')
    parent = BoundarySerializer(source='parent')

    class Meta:
        model = Boundary
        fields = ('id', 'name', 'type', 'school_type', 'parent')


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


class SchoolListSerializer(KLPSerializer):
    type = BoundaryTypeSerializer(source='schooldetails.type')
    address_full = serializers.CharField(source='address.full')

    class Meta:
        model = School
        fields = ('id', 'name', 'address_full', 'dise_info', 'type',)


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

    num_boys = serializers.IntegerField(source='schooldetails.num_boys')
    num_girls = serializers.IntegerField(source='schooldetails.num_girls')
    basic_facilities = serializers.CharField(source='get_basic_facilities')

    has_volunteer_activities = serializers.CharField(source='has_volunteer_activities')

    images = serializers.CharField(source='get_images')

    class Meta:
        model = School
        fields = ('id', 'name', 'mgmt', 'cat', 'moi', 'sex', 'address_full',
                  'landmark', 'identifiers', 'admin3', 'admin2', 'admin1',
                  'buses', 'parliament', 'assembly', 'ward',
                  'dise_code', 'type', 'num_boys', 'num_girls',
                  'basic_facilities', 'images', 'has_volunteer_activities')


class SchoolDemographicsSerializer(KLPSerializer):
    num_boys_dise = serializers.IntegerField(source='dise_info.boys_count')
    num_girls_dise = serializers.IntegerField(source='dise_info.girls_count')
    num_boys = serializers.IntegerField(source='schooldetails.num_boys')
    num_girls = serializers.IntegerField(source='schooldetails.num_girls')
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


class SchoolNutritionSerializer(KLPSerializer):
    num_boys_dise = serializers.IntegerField(source='dise_info.boys_count')
    num_girls_dise = serializers.IntegerField(source='dise_info.girls_count')
    num_boys = serializers.IntegerField(source='schooldetails.num_boys')
    num_girls = serializers.IntegerField(source='schooldetails.num_girls')

    mdm_agg = serializers.SerializerMethodField('get_mdm_agg')

    class Meta:
        model = School
        fields = ('id', 'name', 'num_boys_dise', 'num_girls_dise', 'num_boys',
            'num_girls', 'mdm_agg')

    def get_mdm_agg(self, obj):
        return obj.mdmagg_set.all().values()


class SchoolInfraSerializer(KLPSerializer):
    acyear = serializers.CharField(source="dise_info.acyear")
    num_boys_dise = serializers.IntegerField(source='dise_info.boys_count')
    num_girls_dise = serializers.IntegerField(source='dise_info.girls_count')
    num_boys = serializers.IntegerField(source='schooldetails.num_boys')
    num_girls = serializers.IntegerField(source='schooldetails.num_girls')

    classroom_count = serializers.IntegerField(source='dise_info.classroom_count')
    lowest_class = serializers.IntegerField(source='dise_info.lowest_class')
    highest_class = serializers.IntegerField(source='dise_info.highest_class')
    teacher_count = serializers.IntegerField(source='dise_info.teacher_count')
    dise_books = serializers.IntegerField(source='dise_info.books_in_library')

    dise_rte = serializers.CharField(source='dise_info.get_rte_details')
    facilities = serializers.CharField(source='dise_info.get_facility_details')

    class Meta:
        model = School
        fields = ('id', 'name', 'dise_info', 'num_boys_dise',
            'num_girls_dise', 'num_boys', 'num_girls', 'classroom_count', 'lowest_class',
            'highest_class', 'status', 'teacher_count',
            'dise_books', 'dise_rte', 'facilities')


class PrechoolInfraSerializer(KLPSerializer):
    num_boys = serializers.IntegerField(source='schooldetails.num_boys')
    num_girls = serializers.IntegerField(source='schooldetails.num_girls')

    facilities = serializers.SerializerMethodField('get_ang_facility_details')

    class Meta:
        model = School
        fields = ('id', 'name', 'num_boys', 'num_girls', 'facilities')

    def get_ang_facility_details(self, obj):
        data = {}
        ang_infras = obj.anganwadiinfraagg_set.all().select_related('ai_metric')
        for infra in ang_infras:
            if infra.ai_group not in data:
                data[infra.ai_group] = {}
            data[infra.ai_group][infra.ai_metric.value.strip()] = (infra.perc_score == 100)
        return data


class SchoolLibrarySerializer(KLPSerializer):
    acyear = serializers.CharField(source="dise_info.acyear")
    dise_books = serializers.IntegerField(source='dise_info.books_in_library')
    lowest_class = serializers.IntegerField(source='dise_info.lowest_class')
    highest_class = serializers.IntegerField(source='dise_info.highest_class')

    lib_infra = serializers.CharField(source='get_lib_infra')
    lib_level_agg = serializers.CharField(source='get_lib_level_agg')
    lib_lang_agg = serializers.CharField(source='get_lib_lang_agg')
    lib_borrow_agg = serializers.CharField(source='get_lib_borrow_agg')

    classtotal = serializers.CharField(source='get_total_students_in_class')

    class Meta:
        model = School
        fields = ('id', 'name', 'dise_info', 'acyear',
            'dise_books', 'lib_infra', 'lowest_class',
            'highest_class', 'lib_borrow_agg',
            'lib_level_agg', 'lib_lang_agg', 'classtotal')


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
            print "Finance: School {} has no paisa data".format(obj.id)
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
        except Exception, e:
            print "Finance: School {} has no dise data".format(obj.id)
        return grant_amount

    def get_tlm_amount(self, obj):
        grant_amount = None
        try:
            paisa = PaisaData.objects.get(criteria='teacher_count')
            grant_amount = obj.dise_info.teacher_count * paisa.grant_amount
        except Exception, e:
            print "Finance: School {} has no dise data".format(obj.id)
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


class AssessmentListSerializer(KLPSerializer):
    assid= serializers.IntegerField(source='assessment.id')
    studentgroup =  serializers.CharField(source='studentgroup')
    assessmentname = serializers.CharField(source='assessment.name')
    academicyear_name = serializers.CharField(source='assessment.programme.academic_year.name')

    class Meta:
        model = InstitutionAssessmentCohorts
        fields = ('assid','assessmentname', 'studentgroup','academicyear_name')


class AssessmentInfoSerializer(KLPSerializer):
    schoolname=serializers.CharField(source='school.name')
    studentgroup =  serializers.CharField(source='studentgroup')
    assessmentname = serializers.CharField(source='assessment.name')
    academicyear_name = serializers.CharField(source='assessment.programme.academic_year.name')
    singlescore=serializers.IntegerField(source='singlescore')
    percentile=serializers.IntegerField(source='percentile')
    cohortsdetails= serializers.SerializerMethodField('get_cohorts_details')
    singlescoredetails= serializers.SerializerMethodField('get_singlescore_details')


    class Meta:
        model = InstitutionAssessmentSinglescore
        fields = ('schoolname','assessmentname', 'studentgroup','academicyear_name','singlescore','percentile','cohortsdetails','singlescoredetails')

    def get_cohorts_details(self, obj):
        data = {}
        cohortssum= InstitutionAssessmentCohorts.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
        data['total']=cohortssum['cohortsnum__sum']
        cohortsgender= InstitutionAssessmentCohorts.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
        data['gender']=cohortsgender
        cohortsmt= InstitutionAssessmentCohorts.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        data['mt']=cohortsmt
        return data

    def get_singlescore_details(self,obj):
        singlescore={}
        genderdata= InstitutionAssessmentSinglescoreGender.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex','singlescore','percentile')
        singlescore['gender']=genderdata

        mtdata= InstitutionAssessmentSinglescoreMt.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt','singlescore','percentile')
        singlescore['mt']=mtdata

        singlescore["boundary"]={}
        admin1data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.school.schooldetails.admin1,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name')
        singlescore["boundary"]["admin1"]=admin1data

        admin2data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.school.schooldetails.admin2,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
        singlescore["boundary"]["admin2"]=admin2data

        admin3data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.school.schooldetails.admin3,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
        singlescore["boundary"]["admin3"]=admin3data
        return singlescore



class BoundaryAssessmentInfoSerializer(KLPSerializer):
    boundaryname=serializers.CharField(source='boundary.name')
    studentgroup =  serializers.CharField(source='studentgroup')
    assessmentname = serializers.CharField(source='assessment.name')
    academicyear_name = serializers.CharField(source='assessment.programme.academic_year.name')
    singlescore=serializers.IntegerField(source='singlescore')
    percentile=serializers.IntegerField(source='percentile')
    cohortsdetails= serializers.SerializerMethodField('get_cohorts_details')
    singlescoredetails= serializers.SerializerMethodField('get_singlescore_details')


    class Meta:
        model = BoundaryAssessmentSinglescore
        fields = ('boundaryname','assessmentname', 'studentgroup','academicyear_name','singlescore','percentile','cohortsdetails','singlescoredetails')

    def get_cohorts_details(self, obj):
        data = {}
        if obj.boundary.hierarchy.id==11 or obj.boundary.hierarchy.id==15:
          cohortssum= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
          cohortsgender= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
          cohortsmt= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        elif obj.boundary.hierarchy.id==10 or obj.boundary.hierarchy.id==14:
            cohortssum= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
            cohortsgender= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
            cohortsmt= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        elif obj.boundary.hierarchy.id==9 or obj.boundary.hierarchy.id==13:
            cohortssum= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
            cohortsgender= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
            cohortsmt= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        data['total']=cohortssum['cohortsnum__sum']
        data['gender']=cohortsgender
        data['mt']=cohortsmt
        return data

    def get_singlescore_details(self,obj):
        singlescore={}

        singlescore["boundary"]={}
        if obj.boundary.hierarchy.id==11 or obj.boundary.hierarchy.id==15:
          admin2data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.boundary.parent,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
          singlescore["boundary"]["admin2"]=admin2data
          admin1data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.boundary.parent.parent,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
          singlescore["boundary"]["admin1"]=admin1data
        elif obj.boundary.hierarchy.id==10 or obj.boundary.hierarchy.id==14:
          admin1data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.boundary.parent,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
          singlescore["boundary"]["admin1"]=admin1data
        return singlescore


class ProgrammeListSerializer(KLPSerializer):
    id= serializers.IntegerField(source='assessment.programme.id')
    name= serializers.CharField(source='assessment.programme.name')
    academicyear_name = serializers.CharField(source='assessment.programme.academic_year.name')

    class Meta:
        model = InstitutionAssessmentCohorts
        fields = ('id','name','academicyear_name')

class ProgrammeInfoSerializer(KLPSerializer):
    studentgroup =  serializers.CharField(source='studentgroup')
    assessmentname = serializers.CharField(source='assessment.name')
    academicyear_name = serializers.CharField(source='assessment.programme.academic_year.name')
    singlescore=serializers.IntegerField(source='singlescore')
    percentile=serializers.IntegerField(source='percentile')
    cohortsdetails= serializers.SerializerMethodField('get_cohorts_details')
    singlescoredetails= serializers.SerializerMethodField('get_singlescore_details')


    class Meta:
        model = InstitutionAssessmentSinglescore
        fields = ('assessmentname', 'studentgroup','academicyear_name','singlescore','percentile','cohortsdetails','singlescoredetails')

    def get_cohorts_details(self, obj):
        data = {}
        cohortssum= InstitutionAssessmentCohorts.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
        data['total']=cohortssum['cohortsnum__sum']
        cohortsgender= InstitutionAssessmentCohorts.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
        data['gender']=cohortsgender
        cohortsmt= InstitutionAssessmentCohorts.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        data['mt']=cohortsmt
        return data

    def get_singlescore_details(self,obj):
        singlescore={}
        genderdata= InstitutionAssessmentSinglescoreGender.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex','singlescore','percentile')
        singlescore['gender']=genderdata

        mtdata= InstitutionAssessmentSinglescoreMt.objects.filter(school=obj.school,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt','singlescore','percentile')
        singlescore['mt']=mtdata

        singlescore["boundary"]={}
        admin1data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.school.schooldetails.admin1,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
        singlescore["boundary"]["admin1"]=admin1data

        admin2data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.school.schooldetails.admin2,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
        singlescore["boundary"]["admin2"]=admin2data

        admin3data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.school.schooldetails.admin3,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
        singlescore["boundary"]["admin3"]=admin3data
        return singlescore


class BoundaryProgrammeInfoSerializer(KLPSerializer):
    studentgroup =  serializers.CharField(source='studentgroup')
    assessmentname = serializers.CharField(source='assessment.name')
    academicyear_name = serializers.CharField(source='assessment.programme.academic_year.name')
    singlescore=serializers.IntegerField(source='singlescore')
    percentile=serializers.IntegerField(source='percentile')
    cohortsdetails= serializers.SerializerMethodField('get_cohorts_details')
    singlescoredetails= serializers.SerializerMethodField('get_singlescore_details')


    class Meta:
        model = BoundaryAssessmentSinglescore
        fields = ('assessmentname', 'studentgroup','academicyear_name','singlescore','percentile','cohortsdetails','singlescoredetails')

    def get_cohorts_details(self, obj):
        data = {}
        if obj.boundary.hierarchy.id==11 or obj.boundary.hierarchy.id==15:
          cohortssum= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
          cohortsgender= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
          cohortsmt= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        elif obj.boundary.hierarchy.id==10 or obj.boundary.hierarchy.id==14:
            cohortssum= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
            cohortsgender= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
            cohortsmt= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        elif obj.boundary.hierarchy.id==9 or obj.boundary.hierarchy.id==13:
            cohortssum= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).aggregate(Sum('cohortsnum'))
            cohortsgender= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('sex').annotate(total=Sum('cohortsnum'))
            cohortsmt= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=obj.boundary,studentgroup=obj.studentgroup,assessment=obj.assessment).values('mt').annotate(total=Sum('cohortsnum'))
        data['total']=cohortssum['cohortsnum__sum']
        data['gender']=cohortsgender
        data['mt']=cohortsmt
        return data


    def get_singlescore_details(self,obj):
        singlescore={}
        singlescore["boundary"]={}
        if obj.boundary.hierarchy.id==11 or obj.boundary.hierarchy.id==15:
          admin2data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.boundary.parent,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
          singlescore["boundary"]["admin2"]=admin2data
          admin1data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.boundary.parent.parent,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
          singlescore["boundary"]["admin1"]=admin1data
        elif obj.boundary.hierarchy.id==10 or obj.boundary.hierarchy.id==14:
          admin1data=BoundaryAssessmentSinglescore.objects.filter(boundary=obj.boundary.parent,studentgroup=obj.studentgroup,assessment=obj.assessment).values('singlescore','percentile','boundary__name','boundary')
          singlescore["boundary"]["admin1"]=admin1data
        return singlescore

