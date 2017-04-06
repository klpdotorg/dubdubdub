from rest_framework.response import Response
from schools.models import Boundary, AcademicYear
from schools.api_views.aggregations import BaseSchoolAggView
from . import BaseBoundaryReport
from common.views import KLPAPIView
from common.exceptions import APIError
from rest_framework.exceptions import ParseError
from django.conf import settings


class BoundarySummaryReport(KLPAPIView, BaseSchoolAggView, BaseBoundaryReport):
    '''
        Returns report summary
    '''
    reportInfo = {"report_info": {}}
    parentInfo = {}

    # filling the counts in the data structure to be returned
    def get_counts(self, boundaryData, active_schools, academic_year):
        self.reportInfo["gender"] = {"boys": 0,
                                     "girls": 0}
        self.reportInfo["student_count"] = 0
        self.reportInfo["school_count"] = boundaryData["num_schools"]
        for data in boundaryData["cat"]:
            if data["cat"] in ['Lower Primary', 'Upper Primary']:
                self.reportInfo["gender"]["boys"] += data["num_boys"]
                self.reportInfo["gender"]["girls"] += data["num_girls"]
                self.reportInfo["student_count"] += data["num_boys"] + data["num_girls"]
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

        # Get the academic year
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        self.reportInfo["academic_year"] = year

        # Check if boundary id is valid
        try:
            boundary = Boundary.objects.get(pk=boundaryid)
        except Exception:
            raise APIError('Boundary not found', 404)

        # Get list of schools associated with that boundary
        active_schools = boundary.schools()

        # Get aggregate data for schools in that boundary for the current
        # academic year
        boundaryData = self.get_aggregations(active_schools, academic_year)
        boundaryData = self.check_values(boundaryData)

        # get information about the parent
        self.parentInfo = self.get_parent_info(boundary)

        # get the summary data
        self.get_boundary_summary_data(boundary, self.reportInfo)

        # get the counts of students/gender/teacher/school
        self.get_counts(boundaryData, active_schools, academic_year)

    def get(self, request):
        if not self.request.GET.get('id'):
            raise ParseError("Mandatory parameter id not passed")

        id = self.request.GET.get("id")
        self.get_boundary_data(id)
        return Response(self.reportInfo)
