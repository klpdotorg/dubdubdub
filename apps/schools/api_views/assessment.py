import sys
from schools.models import (
    Assessment, InstitutionAssessmentCohorts,
    InstitutionAssessmentSinglescore, InstitutionAssessmentSinglescoreGender,
    InstitutionAssessmentSinglescoreMt, BoundaryAssessmentSinglescore,
    InstitutionAssessmentPercentile, BoundaryAssessmentPercentile,
    Programme, Partner
)
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.mixins import CacheMixin
from schools.serializers import (
    AssessmentListSerializer, AssessmentInfoSerializer, ProgrammeListSerializer,
    ProgrammeInfoSerializer, BoundaryAssessmentInfoSerializer,
    BoundaryProgrammeInfoSerializer, ProgrammePercentileSerializer,
    BoundaryProgrammePercentileSerializer, PartnerSerializer
)
from rest_framework.exceptions import APIException, PermissionDenied,\
    ParseError, MethodNotAllowed, AuthenticationFailed


class PartnerList(KLPListAPIView, CacheMixin):
    """
    Returns list of partner
    """
    serializer_class = PartnerSerializer
    queryset = Partner.objects.filter(status=1)


class AssessmentsList(KLPListAPIView, CacheMixin):

    '''
        Returns list of assessment id,name and academic year
    '''
    serializer_class = AssessmentListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        if self.request.GET.get('school', ''):
            sid = self.request.GET.get('school')
            assessments = InstitutionAssessmentCohorts.objects.filter(
                school=sid
            ).select_related(
                'assid',
                'studentgroup',
                'assessment__name',
                'assessment__programme__academic_year__name'
            )
        elif self.request.GET.get('admin_1', ''):
            admin1 = self.request.GET.get('admin_1')
            assessments = InstitutionAssessmentCohorts.objects.filter(
                school__schooldetails__admin1=admin1
            ).select_related(
                'assid',
                'studentgroup',
                'assessment__name',
                'assessment__programme__academic_year__name'
            )
        elif self.request.GET.get('admin_2', ''):
            admin2 = self.request.GET.get('admin_2')
            assessments = InstitutionAssessmentCohorts.objects.filter(
                school__schooldetails__admin2=admin2
            ).select_related(
                'assid',
                'studentgroup',
                'assessment__name',
                'assessment__programme__academic_year__name'
            )
        elif self.request.GET.get('admin_3', ''):
            admin3 = self.request.GET.get('admin_3')
            assessments = InstitutionAssessmentCohorts.objects.filter(
                school__schooldetails__admin3=admin3
            ).select_related(
                'assid',
                'studentgroup',
                'assessment__name',
                'assessment__programme__academic_year__name'
            )
        else:
            raise ParseError("Invalid parameter passed. Provide either school, admin_1, admin_2 or admin_3")
        return assessments


class AssessmentInfo(KLPListAPIView):

    '''
        Returns the selected assessments details related to the school and student group
    '''
    bbox_filter_field = "instcoord__coord"

    def get_serializer_class(self):
        if self.request.GET.get('school', ''):
            return AssessmentInfoSerializer
        elif self.request.GET.get('admin_1', '') or self.request.GET.get('admin_2', '') or self.request.GET.get('admin_3', ''):
            return BoundaryAssessmentInfoSerializer
        else:
            return None

    def get_queryset(self):
        if self.kwargs.get('assessment_id'):
            assid = self.kwargs.get('assessment_id')
        else:
            raise ParseError("Mandatory parameter assessment_id not passed.")
        if self.request.GET.get('studentgroup', ''):
            studentgroup = self.request.GET.get('studentgroup')
        else:
            raise ParseError("Mandatory parameter studentgroup not passed.")
        if self.request.GET.get('school', ''):
          sid= self.request.GET.get('school')
          assessmentinfo = InstitutionAssessmentSinglescore.objects.filter(school=sid,assessment=assid,studentgroup=studentgroup)\
.select_related('school__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        elif self.request.GET.get('admin_1', ''):
          serializer_class = BoundaryAssessmentInfoSerializer
          bid= self.request.GET.get('admin_1')
          assessmentinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment=assid,studentgroup=studentgroup)\
.select_related('boundary__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        elif self.request.GET.get('admin_2', ''):
          serializer_class = BoundaryAssessmentInfoSerializer
          bid= self.request.GET.get('admin_2')
          assessmentinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment=assid,studentgroup=studentgroup)\
.select_related('boundary__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        elif self.request.GET.get('admin_3', ''):
          serializer_class = BoundaryAssessmentInfoSerializer
          bid= self.request.GET.get('admin_3')
          assessmentinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment=assid,studentgroup=studentgroup)\
.select_related('boundary__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        else:
          raise ParseError("Invalid parameter passed.Pass either school,admin_1,admin_2 or admin_3")
        return assessmentinfo


class ProgrammesList(KLPListAPIView, CacheMixin):
    '''Returns list of programmes and year in which they were conducted
    ---
    parameters:
        - name: school|admin_1|admin_2|admin_3
          description: the id of the entity to return programmes about
          required: true
          type: integer
          paramType: form
    '''
    serializer_class = ProgrammeListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        programmes = Programme.objects.all().distinct(
            'id',
            'name',
            'academic_year__name',
        ).order_by('id').select_related(
            'academic_year',
            'partner'
        )

        stype = self.request.GET.get('school_type', 'both')

        if stype == 'preschool':
            programmes = programmes.filter(
                assessment__institutionassessmentcohorts__school_schooldetails__type=2
            )
        elif stype == 'school':
            programmes = programmes.filter(
                assessment__institutionassessmentcohorts__school_schooldetails__type=1
            )

        if self.request.GET.get('school', ''):
            sid = self.request.GET.get('school')
            programmes = programmes.filter(
                assessment__institutionassessmentcohorts__school_id=sid
            )
        elif self.request.GET.get('admin_1', ''):
            admin1 = self.request.GET.get('admin_1')
            programmes = programmes.filter(
                assessment__institutionassessmentcohorts__school__schooldetails__admin1=admin1
            )
        elif self.request.GET.get('admin_2', ''):
            admin2 = self.request.GET.get('admin_2')
            programmes = programmes.filter(
                assessment__institutionassessmentcohorts__school__schooldetails__admin2=admin2
            )
        elif self.request.GET.get('admin_3', ''):
            admin3 = self.request.GET.get('admin_3')
            programmes = programmes.filter(
                assessment__institutionassessmentcohorts__school__schooldetails__admin3=admin3
            )

        if self.request.GET.get('partner_id', ''):
            programmes = programmes.filter(
                partner_id=self.request.GET.get('partner_id')
            )

        if self.request.GET.get('academic_year_id', ''):
            programmes = programmes.filter(
                academic_year_id=self.request.GET.get('academic_year_id')
            )
        elif self.request.GET.get('academic_year', ''):
            programmes = programmes.filter(
                academic_year__name=self.request.GET.get('academic_year')
            )

        return programmes


class ProgrammeInfo(KLPListAPIView):

    '''
        Returns detail information of the programme
    '''
    bbox_filter_field = "instcoord__coord"

    def get_serializer_class(self):
        if self.request.GET.get('school', ''):
            return ProgrammeInfoSerializer
        elif self.request.GET.get('admin_1', '') or self.request.GET.get('admin_2', '') or self.request.GET.get('admin_3', ''):
            return BoundaryProgrammeInfoSerializer
        else:
            return None

    def get_queryset(self):
        print self.request
        if self.kwargs.get('programme_id'):
            progid = self.kwargs.get('programme_id')
        else:
            raise ParseError("Mandatory parameter programme_id not passed.")
        if self.request.GET.get('school', ''):
          sid= self.request.GET.get('school')
          programmeinfo = InstitutionAssessmentSinglescore.objects.filter(school=sid,assessment__programme__id=progid)\
.order_by('studentgroup','assessment__id')\
.select_related('studentgroup','assessment__id','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        elif self.request.GET.get('admin_1', ''):
          bid= self.request.GET.get('admin_1')
          programmeinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment__programme=progid)\
.order_by('studentgroup','assessment__id')\
.select_related('studentgroup','assessment__id','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        elif self.request.GET.get('admin_2', ''):
          bid= self.request.GET.get('admin_2')
          programmeinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment__programme=progid)\
.order_by('studentgroup','assessment__id')\
.select_related('studentgroup','assessment__id','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        elif self.request.GET.get('admin_3', ''):
          bid= self.request.GET.get('admin_3')
          programmeinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment__programme=progid)\
.order_by('studentgroup','assessment__id')\
.select_related('studentgroup','assessment__id','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile','gradesinglescore')
        else:
            raise ParseError(
                "Invalid parameter passed.Pass either school,admin_1,admin_2 or admin_3")

        return programmeinfo


class ProgrammePercentile(KLPListAPIView):
    '''
        Returns percentile value of the programme
    '''
    bbox_filter_field = "instcoord__coord"

    def get_serializer_class(self):
        if self.request.GET.get('school',''):
          return ProgrammePercentileSerializer
        elif self.request.GET.get('admin_1','') or self.request.GET.get('admin_2','') or self.request.GET.get('admin_3',''):
          return BoundaryProgrammePercentileSerializer
        else:
            return None

    def get_queryset(self):
        print self.request
        if self.kwargs.get('programme_id'):
          progid= self.kwargs.get('programme_id')
        else:
          raise ParseError("Mandatory parameter programme_id not passed.")
        if self.request.GET.get('school', ''):
          sid= self.request.GET.get('school')
          programmeinfo = InstitutionAssessmentPercentile.objects.filter(school=sid,assessment__programme__id=progid)\
.order_by('assessment__id')\
.select_related('assessment__id','assessment__name','assessment__programme__academic_year__name','percentile')
        elif self.request.GET.get('admin_1',''):
          bid= self.request.GET.get('admin_1')
          programmeinfo = BoundaryAssessmentPercentile.objects.filter(boundary=bid,assessment__programme=progid)\
.order_by('assessment__id')\
.select_related('assessment__id','assessment__name','assessment__programme__academic_year__name','percentile')
        elif self.request.GET.get('admin_2', ''):
          bid= self.request.GET.get('admin_2')
          programmeinfo = BoundaryAssessmentPercentile.objects.filter(boundary=bid,assessment__programme=progid)\
.order_by('assessment__id')\
.select_related('assessment__id','assessment__name','assessment__programme__academic_year__name','percentile')
        elif self.request.GET.get('admin_3', ''):
          bid= self.request.GET.get('admin_3')
          programmeinfo = BoundaryAssessmentPercentile.objects.filter(boundary=bid,assessment__programme=progid)\
.order_by('assessment__id')\
.select_related('assessment__id','assessment__name','assessment__programme__academic_year__name','percentile')
        else:
          raise ParseError("Invalid parameter passed.Pass either school,admin_1,admin_2 or admin_3")

        return programmeinfo
