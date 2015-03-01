import sys
from schools.models import Assessment, InstitutionAssessmentCohorts,InstitutionAssessmentSinglescore,InstitutionAssessmentSinglescoreGender,InstitutionAssessmentSinglescoreMt 
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView
from common.mixins import CacheMixin
from schools.serializers import ( AssessmentListSerializer,AssessmentInfoSerializer)


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
        if self.request.GET.get('school_id', ''):
          sid= self.request.GET.get('school_id')
        else:
          return None
        if self.request.GET.get('assessment_id', ''):
          assid= self.request.GET.get('assessment_id')
        else:
          return None
        if self.request.GET.get('studentgroup', ''):
          studentgroup= self.request.GET.get('studentgroup')
        else:
          return None


        print >>sys.stderr,"Why1"
        assessmentinfo = InstitutionAssessmentSinglescore.objects.filter(school=sid,assessment=assid,studentgroup=studentgroup)\
.select_related('school__name','studentgroup','assessment__name','assessment__programme__academic_year__name','singlescore', 'percentile')
      
        print >>sys.stderr,assessmentinfo
        return assessmentinfo


