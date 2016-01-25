import sys
from schools.models import ElectedrepMaster, SchoolElectedrep, SchoolDetails,\
 SchoolExtra
from common.views import KLPListAPIView
from common.mixins import CacheMixin
from schools.serializers import DemographicsReportSerializer,FinanceReportSerializer
from rest_framework.exceptions import ParseError


class ReportsDetail(KLPListAPIView):

    '''
        Returns report details
    '''

    bbox_filter_field = "instcoord__coord"

    def get_serializer_class(self):
        report_type=self.request.GET.get('report_type','')
        if report_type=='demographics':
            return DemographicsReportSerializer
        elif report_type=='finance':
            return FinanceReportSerializer
        else:
            return None



    def get_queryset(self):
        mandatoryparams={'boundary':{"assembly","parliament","admin1","admin2","admin3"},'id':{},'report_type':{"demographics","finance"},'language':{"english","kannada"}}
        for params in mandatoryparams:
            if not self.request.GET.get(params):
                raise ParseError("Mandatory parameter "+params+" not passed")
            else:
                if mandatoryparams[params]!={} and self.request.GET.get(params) not in mandatoryparams[params]:
                    raise ParseError("Invalid "+params+" passed,pass from the "+str(mandatoryparams[params]))

        boundarytype=self.request.GET.get("boundary")
        boundaryid=self.request.GET.get("id")
        if boundarytype in ("assembly","parliament"):
            return ElectedrepMaster.objects.filter(id=boundaryid).select_related('id','const_ward_type')
