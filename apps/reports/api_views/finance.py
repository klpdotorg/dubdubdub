from rest_framework.response import Response
from schools.models import Boundary, AcademicYear
from schools.api_views.aggregations import BaseSchoolAggView
from . import BaseBoundaryReport
from common.views import KLPAPIView
from common.exceptions import APIError
from django.conf import settings
from django.db.models import Sum
import sys


class FinanceBoundaryComparisonDetails(KLPAPIView, BaseSchoolAggView, BaseBoundaryReport):

    def get_neighbour_comparison(self, academic_year, boundary):
        comparisonData = []
        if boundary.get_admin_level() == 1:
            neighbours = Boundary.objects.filter(hierarchy=boundary.hierarchy).order_by("name")
        else:
            neighbours = Boundary.objects.filter(parent=boundary.parent).order_by("name")
        for neighbour in neighbours:
            data = {"name": neighbour.name,
                    "num_schools": 0,
                    "expected_grant": 0,
                    "received_grant": 0,
                    "expenditure": 0
                    }
            dise_schools = neighbour.dise_schools()
            if dise_schools.exists():
                print >>sys.stderr, data
                data["num_schools"] = dise_schools.count()
                grant_received = dise_schools.aggregate(
                    grant_received=Sum('sg_recd')).get('grant_received', 0)
                data["received_grant"] = grant_received
                grant_spent = dise_schools.aggregate(
                    grant_spent=Sum('sg_expnd')).get('grant_spent', 0)
            data["expenditure"] = grant_spent
            #data["expected_grant"] = calculate_expected(dise_schools)
            comparisonData.append(data)

        return comparisonData

    def get_comparison_data(self, boundary, active_schools, academic_year, year):
        self.parentInfo = self.get_parent_info(boundary)
        self.reportInfo["comparison"] = {}
        self.reportInfo["comparison"]["neighbours"] =\
            self.get_neighbour_comparison(academic_year, boundary)


    def get_report_comparison(self, boundaryid):
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        try:
            boundary = Boundary.objects.get(pk=boundaryid)
        except Exception:
            raise APIError('Boundary not found', 404)

        dise_schools = boundary.dise_schools()
        self.reportInfo["schoolcount"] = dise_schools.count()
        print >> sys.stderr, dise_schools
        #dise_schools = self.get_dise_school_info(active_schools, academic_year)
        self.get_comparison_data(boundary, dise_schools, academic_year,
                                 year)

    def get_boundary_info(self, boundaryid):
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        self.reportInfo["academic_year"] = year
        try:
            boundary = Boundary.objects.get(pk=boundaryid)
        except Exception:
            raise APIError('Boundary not found', 404)
        self.get_boundary_summary_data(boundary, self.reportInfo)

    def get(self, request):
        mandatoryparams = {'id': [], 'language': ["english", "kannada"]}
        self.check_mandatory_params(mandatoryparams)

        id = self.request.GET.get("id")
        reportlang = self.request.GET.get("language")

        self.reportInfo["report_info"] = {"report_lang": reportlang}
        self.get_boundary_info(id)
        return Response(self.reportInfo)
