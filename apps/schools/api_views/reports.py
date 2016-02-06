import sys
from schools.models import ElectedrepMaster, Boundary, AcademicYear
from .aggregations import BaseSchoolAggView
from common.views import KLPDetailAPIView
from schools.serializers import (
    DemographicsReportSerializer, FinanceReportSerializer
)
from common.exceptions import APIError
from rest_framework.exceptions import ParseError
from django.conf import settings


class ReportsDetail(KLPDetailAPIView, BaseSchoolAggView):

    '''
        Returns report details
    '''

    bbox_filter_field = "instcoord__coord"

    def get_serializer_class(self):
        report_type = self.request.GET.get('report_type', '')
        if report_type == 'demographics':
            return DemographicsReportSerializer
        elif report_type == 'finance':
            return FinanceReportSerializer
        else:
            return None

    def get_boundaryData(self, boundarytype, boundaryid):
        boundaryInfo = {"boundary_info": {}, "school_count": {}, "teacher_count": 0,
                        "gender": {}, "categories": [], "enrollment": {},
                        "languages": {}}
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)

        if boundarytype in ('admin1', 'admin2', 'admin3'):
            try:
                boundary = Boundary.objects.get(pk=boundaryid)
            except Exception:
                raise APIError('Boundary not found', 404)

            active_schools = boundary.schools()
            boundaryData = self.get_aggregations(active_schools, academic_year)
            boundaryInfo["boundary_info"]["name"] = boundary.name
            boundaryInfo["boundary_info"]["type"] = boundary.type
            boundaryInfo["boundary_info"]["type"] = boundaryid
            boundaryInfo["gender"] = {"boys": boundaryData["num_boys"],
                                      "girls": boundaryData["num_girls"]}
            boundaryInfo["school_count"] = boundaryData["num_schools"]
            print >>sys.stderr, "Printing-------"
            print >>sys.stderr, boundaryData["cat"]
            for data in boundaryData["cat"]:
                print >>sys.stderr, "-------in loop"
                print >>sys.stderr, data
                print >>sys.stderr, data["cat"]
                boundaryInfo["categories"].append({"cat": data["cat"], "school_count": data["num_schools"], "student_count": data["num_boys"] + data["num_girls"]})

        else:
            obj = ElectedrepMaster.objects.filter(id=boundaryid)
            boundaryInfo["name"] = obj.const_ward_name
            boundaryInfo["type"] = obj.const_ward_type
            boundaryInfo["id"] = obj.id
            boundaryInfo["code"] = obj.elec_comm_code
            boundaryInfo["elected_rep"] = obj.current_elected_rep
            boundaryInfo["elected_party"] = obj.current_elected_party
        return boundaryInfo

    def get_object(self):
        mandatoryparams = {'boundary':
                           {"assembly", "parliament", "admin1", "admin2", "admin3"},
                           'id': {},
                           'report_type': {"demographics", "finance"},
                           'language': {"english", "kannada"}}
        for params in mandatoryparams:
            if not self.request.GET.get(params):
                raise ParseError("Mandatory parameter "+params+" not passed")
            else:
                if mandatoryparams[params] != {} and self.request.GET.get(params) not in mandatoryparams[params]:
                    raise ParseError("Invalid "+params+" passed,pass from the "+str(mandatoryparams[params]))

        boundarytype = self.request.GET.get("boundary")
        boundaryid = self.request.GET.get("id")
        boundarydata = {}
        boundarydata = self.get_boundaryData(boundarytype, boundaryid)
        print >>sys.stderr, "Printing boundarydata"
        print >>sys.stderr, boundarydata
        return boundarydata
