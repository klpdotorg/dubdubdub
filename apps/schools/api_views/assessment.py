import sys
from schools.models import Assessment, InstitutionAssessmentCohorts,InstitutionAssessmentSinglescore,InstitutionAssessmentSinglescoreGender,InstitutionAssessmentSinglescoreMt
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.mixins import CacheMixin
from schools.serializers import ( AssessmentListSerializer,AssessmentInfoSerializer,ProgrammeListSerializer,ProgrammeInfoSerializer)


class AssessmentsList(KLPListAPIView, CacheMixin):
    '''
        Returns list of assessment id,name and academic year
    '''
    serializer_class = AssessmentListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        if self.request.GET.get('school_id', ''):
          sid= self.request.GET.get('school_id')
          assessments = InstitutionAssessmentCohorts.objects.filter(school=sid)\
              .select_related('assid', 'studentgroup','assessment__name','assessment__programme__academic_year__name')
        elif self.request.GET.get('admin_1', ''):
          admin1= self.request.GET.get('admin_1')
          assessments = InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=admin1)\
              .select_related('assid', 'studentgroup','assessment__name','assessment__programme__academic_year__name')
        elif self.request.GET.get('admin_2', ''):
          admin2= self.request.GET.get('admin_2')
          assessments = InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=admin2)\
              .select_related('assid', 'studentgroup','assessment__name','assessment__programme__academic_year__name')
        elif self.request.GET.get('admin_3', ''):
          admin3= self.request.GET.get('admin_3')
          assessments = InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=admin3)\
              .select_related('assid', 'studentgroup','assessment__name','assessment__programme__academic_year__name')


        else:
          return None
        return assessments


class AssessmentInfo(KLPListAPIView):
    '''
        Returns the selected assessments details related to the school and student group
    '''
    serializer_class = AssessmentInfoSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        if self.request.GET.get('assessment_id', ''):
          assid= self.request.GET.get('assessment_id')
        else:
          return None
        if self.request.GET.get('studentgroup', ''):
          studentgroup= self.request.GET.get('studentgroup')
        else:
          return None
        if self.request.GET.get('school_id', ''):
          sid= self.request.GET.get('school_id')
          assessmentinfo = InstitutionAssessmentSinglescore.objects.filter(school=sid,assessment=assid,studentgroup=studentgroup)\
.select_related('school__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile')
        elif self.request.GET.get('bid', ''):
          bid= self.request.GET.get('bid')
          assessmentinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment=assid,studentgroup=studentgroup)\
.select_related('boundary__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile')
        else:
          return None



        print >>sys.stderr,assessmentinfo
        return assessmentinfo



class ProgrammesList(KLPListAPIView, CacheMixin):
    '''
        Returns list of programmes and year in which they were conducted
    '''
    serializer_class = ProgrammeListSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        if self.request.GET.get('school_id', ''):
          sid= self.request.GET.get('school_id')
          programmes= InstitutionAssessmentCohorts.objects.filter(school=sid)\
              .order_by('assessment__programme__id')\
              .distinct('assessment__programme__name','assessment__programme__academic_year__name','assessment__programme__id')
        elif self.request.GET.get('admin_1', ''):
          admin1= self.request.GET.get('admin_1')
          programmes= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin1=admin1)\
              .order_by('assessment__programme__id')\
              .distinct('assessment__programme__name','assessment__programme__academic_year__name','assessment__programme__id')
        elif self.request.GET.get('admin_2', ''):
          admin2= self.request.GET.get('admin_2')
          programmes= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin2=admin2)\
              .order_by('assessment__programme__id')\
              .distinct('assessment__programme__name','assessment__programme__academic_year__name','assessment__programme__id')
        elif self.request.GET.get('admin_3', ''):
          admin3= self.request.GET.get('admin_3')
          programmes= InstitutionAssessmentCohorts.objects.filter(school__schooldetails__admin3=admin3)\
              .order_by('assessment__programme__id')\
              .distinct('assessment__programme__name','assessment__programme__academic_year__name','assessment__programme__id')


        else:
          return None
        return programmes


class ProgrammeInfo(KLPListAPIView):
    '''
        Returns detail information of the programme
    '''
    serializer_class = ProgrammeInfoSerializer
    bbox_filter_field = "instcoord__coord"

    def get_queryset(self):
        if self.request.GET.get('programme_id', ''):
          progid= self.request.GET.get('programme_id')
        else:
          return None
        if self.request.GET.get('school_id', ''):
          sid= self.request.GET.get('school_id')
          programmeinfo = InstitutionAssessmentSinglescore.objects.filter(school=sid,assessment__programme__id=progid)\
.order_by('studentgroup','assessment__name')\
.select_related('studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile')
        elif self.request.GET.get('bid', ''):
          bid= self.request.GET.get('bid')
          programmeinfo = BoundaryAssessmentSinglescore.objects.filter(boundary=bid,assessment__programme=progid)\
.select_related('boundary__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile')
        else:
          return None



        return programmeinfo


