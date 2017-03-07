from rest_framework.response import Response
from schools.models import ElectedrepMaster, AcademicYear
from schools.api_views.aggregations import BaseSchoolAggView
from . import BaseElectedRepReport
from common.views import KLPAPIView
from common.exceptions import APIError
from rest_framework.exceptions import ParseError
from django.conf import settings


class ElectedRepSummaryReport(KLPAPIView, BaseSchoolAggView, BaseElectedRepReport):
    '''
        Returns report summary
    '''
    reportInfo = {}
    parentInfo = {}

    # filling the counts in the data structure to be returned
    def get_counts(self, electedrepData, active_schools, academic_year):
        self.reportInfo["gender"] = {"boys": electedrepData["num_boys"],
                                     "girls": electedrepData["num_girls"]}
        self.reportInfo["school_count"] = electedrepData["num_schools"]
        self.reportInfo["student_count"] = electedrepData["num_boys"] +\
            electedrepData["num_girls"]
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

    def get_parent_info(self, electedrepid):
        parent = {"schoolcount": 0}
        parentObject = ElectedrepMaster.objects.get(id=electedrepid.parent.id)
        schools = parentObject.schools()
        parent["schoolcount"] = schools.count()
        return parent

    def get_report_data(self, electedrepid):

        # Get the academic year
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        self.reportInfo["academic_year"] = year

        # Check if electedrep id is valid
        try:
            electedrep = ElectedrepMaster.objects.get(pk=electedrepid)
        except Exception:
            raise APIError('Electedrep id '+electedrepid+'  not found', 404)

        self.getSummaryData(electedrep, self.reportInfo)
        # Get list of schools associated with that electedrep
        active_schools = electedrep.schools()

        # Get aggregate data for schools with that electedrep for the current
        # academic year
        electedrepData = self.get_aggregations(active_schools, academic_year)
        electedrepData = self.check_values(electedrepData)

        # get information about the parent
        self.parentInfo = self.get_parent_info(electedrep)

        # get the counts of students/gender/teacher/school
        self.get_counts(electedrepData, active_schools, academic_year)

    def get(self, request):
        if not self.request.GET.get('id'):
            raise ParseError("Mandatory parameter id not passed")

        id = self.request.GET.get("id")
        self.get_report_data(id)
        return Response(self.reportInfo)
