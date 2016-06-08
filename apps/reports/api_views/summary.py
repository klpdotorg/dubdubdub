from rest_framework.response import Response
from schools.models import Boundary, AcademicYear
from schools.api_views.aggregations import BaseSchoolAggView
from . import BaseBoundaryReport
from common.views import KLPAPIView
from common.exceptions import APIError
from rest_framework.exceptions import ParseError
from django.conf import settings


class ReportBoundarySummary(KLPAPIView, BaseSchoolAggView, BaseBoundaryReport):
    '''
        Returns report summary
    '''
    reportInfo = {"boundary_info": {}}
    parentInfo = {}

    def check_values(self, boundaryData):
        if boundaryData["num_girls"] is None:
            boundaryData["num_girls"] = 0
        if boundaryData["num_boys"] is None:
            boundaryData["num_boys"] = 0
        if boundaryData["num_schools"] is None:
            boundaryData["num_schools"] = 0
        return boundaryData

    def get_counts(self, boundaryData, active_schools, academic_year):
        self.reportInfo["gender"] = {"boys": boundaryData["num_boys"],
                                     "girls": boundaryData["num_girls"]}
        self.reportInfo["school_count"] = boundaryData["num_schools"]
        self.reportInfo["student_count"] = boundaryData["num_boys"] +\
            boundaryData["num_girls"]
        self.reportInfo["teacher_count"] =\
            self.get_teachercount(active_schools, academic_year)

        if self.reportInfo["teacher_count"] == 0:
            self.reportInfo["ptr"] = "NA"
        else:
            self.reportInfo["ptr"] = round(
                self.reportInfo["student_count"] /
                float(self.reportInfo["teacher_count"]), 2)

        if self.parentInfo["schoolcount"] == 0:
            self.reportInfo["school_perc"] = 100
        else:
            self.reportInfo["school_perc"] = round(
                self.reportInfo["school_count"] *
                100 / float(self.parentInfo["schoolcount"]), 2)

    def get_boundary_data(self, boundaryid):
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        self.reportInfo["boundary_info"]["academic_year"] = year

        try:
            boundary = Boundary.objects.get(pk=boundaryid)
        except Exception:
            raise APIError('Boundary not found', 404)

        active_schools = boundary.schools()
        boundaryData = self.get_aggregations(active_schools, academic_year)
        boundaryData = self.check_values(boundaryData)
        self.parentInfo = self.get_parent_info(boundary)
        self.get_boundary_summary_data(boundary, self.reportInfo)
        self.get_counts(boundaryData, active_schools, academic_year)

    def get(self, request):
        if not self.request.GET.get('id'):
            raise ParseError("Mandatory parameter id not passed")

        id = self.request.GET.get("id")
        self.get_boundary_data(id)
        return Response(self.reportInfo)
