import sys
from rest_framework.response import Response
from schools.models import ElectedrepMaster, Boundary, AcademicYear
from .aggregations import BaseSchoolAggView
from stories.models import Story
from stories.api_views import get_que_and_ans
from common.views import KLPAPIView
from common.exceptions import APIError
from rest_framework.exceptions import ParseError
from django.conf import settings
from django.db.models import Count, Sum


class ReportDetails(KLPAPIView, BaseSchoolAggView):

    '''
        Returns report details
    '''
    boundaryInfo = {"boundary_info": {}, "school_count": {}, "teacher_count": 0,
                    "gender": {}, "comparison": {"year-wise": {},
                                                 "neighbours": {}}}

    parentInfo = {}

    def get_teachercount(self, active_schools, academic_year):
        teachers = active_schools.filter(
            studentgroup__teachers__teacherstudentgroup__academic_year=
            academic_year).aggregate(
            count=Count('studentgroup__teachers__id', distinct=True))
        numteachers = teachers["count"]
        return numteachers

    def get_enrolment(self, active_schools, academic_year):
        active_schools = active_schools.filter(
            schoolclasstotalyear__academic_year=academic_year)
        enrolment = active_schools.values('schoolclasstotalyear__clas').\
            annotate(num=Sum('schoolclasstotalyear__total'))
        enrolmentdata = {"Class 1-4": {"text": "Class 1 to 4",
                                       "student_count": 0},
                         "Class 5-8": {"text": "Class 5 to 8",
                                       "student_count": 0}}
        for data in enrolment:
            if 0 < data["schoolclasstotalyear__clas"] <= 4:
                enrolmentdata["Class 1-4"]["student_count"] += data["num"]
            elif data["schoolclasstotalyear__clas"] <= 8:
                enrolmentdata["Class 5-8"]["student_count"] += data["num"]

        return enrolmentdata

    def check_values(self, boundaryData):
        if boundaryData["num_girls"] is None:
            boundaryData["num_girls"] = 0
        if boundaryData["num_boys"] is None:
            boundaryData["num_boys"] = 0
        if boundaryData["num_schools"] is None:
            boundaryData["num_schools"] = 0
        return boundaryData

    def get_yeardata(self, active_schools, year, year_id):
        yeardata = {"year": year, "enrol_upper": 0, "enrol_lower": 0,
                    "school_count": 0}
        enrolment = self.get_enrolment(active_schools, year_id)
        yeardata["enrol_upper"] = enrolment["Class 5-8"]["student_count"]
        yeardata["enrol_lower"] = enrolment["Class 1-4"]["student_count"]
        boundaryData = self.get_aggregations(active_schools, year_id)
        boundaryData = self.check_values(boundaryData)
        teacher_count = self.get_teachercount(active_schools, year_id)
        student_count = boundaryData["num_boys"] + boundaryData["num_girls"]
        yeardata["student_count"] = student_count
        yeardata["teacher_count"] = teacher_count
        yeardata["school_count"] = boundaryData["num_schools"]

        if self.parentInfo["schoolcount"] == 0:
            yeardata["school_perc"] = 100
        else:
            yeardata["school_perc"] = round(boundaryData["num_schools"]*100
                                            / float(self.parentInfo["schoolcount"]), 2)
        if teacher_count == 0:
            yeardata["ptr"] = "NA"
        else:
            yeardata["ptr"] = round(student_count/float(teacher_count), 2)
        return yeardata

    def get_parent_info(self, boundary):
        parent = {"schoolcount": 0}
        if boundary.get_admin_level() != 1:
            parentObject = Boundary.objects.get(id=boundary.parent.id)
            schools = parentObject.schools()
            parent["schoolcount"] = schools.count()
        return parent

    def get_demographics_year_comparison(self, active_schools, academic_year,
                                         year, reporttype, boundary):
        comparisonData = []
        start_year = year.split('-')[0]
        end_year = year.split('-')[1]
        prev_year = str(int(start_year)-1) + "-" + str(int(end_year)-1)
        prev_prev_year = str(int(start_year)-2) + "-" + str(int(end_year)-2)

        prev_year_id = AcademicYear.objects.get(name=prev_year)
        prev_prev_year_id = AcademicYear.objects.get(name=prev_prev_year)

        yearData = {"year": year,
                    "enrol_upper":
                    self.boundaryInfo["enrolment"]
                    ["Class 5-8"]["student_count"],
                    "enrol_lower":
                    self.boundaryInfo["enrolment"]
                    ["Class 1-4"]["student_count"],
                    "student_count":
                    self.boundaryInfo["student_count"],
                    "school_count":
                    self.boundaryInfo["school_count"],
                    "teacher_count":
                    self.boundaryInfo["teacher_count"]}
        if self.boundaryInfo["teacher_count"] == 0:
            yearData["ptr"] = "NA"
        else:
            yearData["ptr"] = round(
                self.boundaryInfo["student_count"] /
                float(self.boundaryInfo["teacher_count"]), 2)

        if self.parentInfo["schoolcount"] == 0:
            yearData["school_perc"] = 100
        else:
            yearData["school_perc"] = round(
                self.boundaryInfo["school_count"] *
                100 / float(self.parentInfo["schoolcount"]), 2)

        prevYearData = self.get_yeardata(active_schools, prev_year,
                                         prev_year_id)
        prevPrevYearData = self.get_yeardata(active_schools,
                                             prev_prev_year, prev_prev_year_id)

        comparisonData.append(yearData)
        comparisonData.append(prevYearData)
        comparisonData.append(prevPrevYearData)

        return comparisonData

    def get_summary_data(self, boundary, boundaryData, active_schools,
                         academic_year):
        self.boundaryInfo["boundary_info"]["name"] = boundary.name
        self.boundaryInfo["boundary_info"]["type"] = boundary.hierarchy.name
        self.boundaryInfo["boundary_info"]["id"] = boundary.id
        self.boundaryInfo["boundary_info"]["parent"] = {}
        self.boundaryInfo["boundary_info"]["btype"] = boundary.type.id
        if boundary.get_admin_level() != 1:
            self.boundaryInfo["boundary_info"]["parent"] = {
                "type": boundary.parent.hierarchy.name, "name": boundary.parent.name}
        self.boundaryInfo["gender"] = {"boys": boundaryData["num_boys"],
                                       "girls": boundaryData["num_girls"]}
        self.boundaryInfo["school_count"] = boundaryData["num_schools"]
        self.boundaryInfo["student_count"] = boundaryData["num_boys"] +\
            boundaryData["num_girls"]
        self.boundaryInfo["teacher_count"] =\
            self.get_teachercount(active_schools, academic_year)

    def get_details_data(self, boundaryData, active_schools, academic_year):
        self.boundaryInfo["categories"] = {}
        for data in boundaryData["cat"]:
            self.boundaryInfo["categories"][data["cat"]] = {
                "school_count": data["num_schools"],
                "student_count": data["num_boys"] + data["num_girls"]}

            self.boundaryInfo["languages"] = {"moi": {}, "mt": {}}
        for data in boundaryData["moi"]:
                self.boundaryInfo["languages"]["moi"][data["moi"].upper()] =\
                    {"school_count": data["num"]}
        for data in boundaryData["mt"]:
                self.boundaryInfo["languages"]["mt"][data["name"].upper()] =\
                    {"student_count": data["num_students"]}

        self.boundaryInfo["enrolment"] =\
            self.get_enrolment(active_schools, academic_year)

    def get_comparison_data(self, boundary, active_schools, academic_year, year, reporttype):
        self.parentInfo = self.get_parent_info(boundary)
        self.boundaryInfo["comparison"] = {}
        self.boundaryInfo["comparison"]["year-wise"] =\
            self.get_demographics_year_comparison(active_schools,
                                                  academic_year, year, reporttype, boundary)
        self.boundaryInfo["comparison"]["neighbours"] =\
            self.get_demographics_neighbour_comparison(academic_year,
                                                       reporttype, boundary)

    def get_grant_data(self):
        self.boundaryData["grantdata"] = {"received": {}, "expenditure": {}}

    def get_alloc_data(self):
        self.boundaryData["allocdata"] = {"sg": {}, "smg": {}, "per": {}}

    def get_finance_comparison(self):
        self.boundaryData["comparisonData"] = {"year-wise": {}, "neighbours": {}}

    def get_demographics_neighbour_comparison(self, academic_year, reporttype, boundary):
        comparisonData = []
        if boundary.get_admin_level() == 1:
            neighbours = Boundary.objects.filter(hierarchy=boundary.hierarchy).order_by("name")
        else:
            neighbours = Boundary.objects.filter(parent=boundary.parent).order_by("name")
        for neighbour in neighbours:
            data = {"name": neighbour.name,
                    "enrol_upper": 0,
                    "enrol_lower": 0,
                    "ptr": 0,
                    "school_count": 0,
                    "school_perc": 0}
            active_schools = neighbour.schools()
            if active_schools.exists():
                boundaryData = self.get_aggregations(active_schools,
                                                     academic_year)
                boundaryData = self.check_values(boundaryData)
                enrolment = self.get_enrolment(active_schools, academic_year)
                data["enrol_upper"] =\
                    enrolment["Class 5-8"]["student_count"]
                data["enrol_lower"] =\
                    enrolment["Class 1-4"]["student_count"]
                data["school_count"] =\
                    boundaryData["num_schools"]
                teacher_count = self.get_teachercount(active_schools,
                                                      academic_year)
                student_count = boundaryData["num_boys"] +\
                    boundaryData["num_girls"]
                data["student_count"] = student_count
                data["teacher_count"] = teacher_count
                if self.parentInfo["schoolcount"] == 0:
                    data["school_perc"] = 100
                else:
                    data["school_perc"] = round(
                        boundaryData["num_schools"] * 100 /
                        float(self.parentInfo["schoolcount"]), 2)
                if teacher_count == 0:
                    data["ptr"] = "NA"
                else:
                    data["ptr"] = round(
                        student_count / float(teacher_count), 2)
            comparisonData.append(data)

        return comparisonData

    def get_infra_data(self, boundary, active_schools, academic_year, year):
        start_year = year.split('-')[0]
        end_year = year.split('-')[1]
        start_date = start_year+"-06-01"
        end_date = end_year+"-05-30"
        stories = Story.objects.filter(
            school__schooldetails__admin1=boundary.id,
            date_of_visit__range=[start_date, end_date])
        data = get_que_and_ans(stories, None, 'PreSchool', None)
        return data

    def get_infra_year_comparison(self, boundary, active_schools, academic_year, year):
        comparisonData = {}
        start_year = year.split('-')[0]
        end_year = year.split('-')[1]
        prev_year = str(int(start_year)-1) + "-" + str(int(end_year)-1)
        prev_prev_year = str(int(start_year)-2) + "-" + str(int(end_year)-2)

        prev_year_id = AcademicYear.objects.get(name=prev_year)
        prev_prev_year_id = AcademicYear.objects.get(name=prev_prev_year)

        comparisonData[year.replace('20', '')] = {"year": year,
                                                  "infra": self.boundaryInfo["infra"]}
        comparisonData[prev_year.replace('20', '')] = {"year": prev_year,
                                                       "infra": self.get_infra_data(boundary,
                                                                                    active_schools,
                                                                                    prev_year_id,
                                                                                    prev_year)}
        comparisonData[prev_prev_year.replace('20', '')] = {
            "year": prev_prev_year,
            "infra": self.get_infra_data(boundary, active_schools, prev_prev_year_id,
                                         prev_prev_year)}

        return comparisonData

    def get_infra_neighbour_comparison(self, boundary, active_schools,
                                       academic_year, year):
        comparisonData = {}
        if boundary.get_admin_level() == 1:
            neighbours = Boundary.objects.filter(hierarchy=boundary.hierarchy)
        else:
            neighbours = Boundary.objects.filter(parent=boundary.parent)
        for neighbour in neighbours:
            comparisonData[neighbour.name] = {"name": neighbour.name}
            active_schools = neighbour.schools()
            if active_schools.exists():
                comparisonData[neighbour.name]["infra"] = self.get_infra_data(
                    boundary, active_schools,
                    academic_year, year)

        return comparisonData

    def get_infra_comparison(self, boundary, active_schools, academic_year,
                             year):
        self.parentInfo = self.get_parent_info(boundary)
        self.boundaryInfo["comparison"] = {}
        self.boundaryInfo["comparison"]["year-wise"] =\
            self.get_infra_year_comparison(boundary, active_schools,
                                           academic_year, year)
        self.boundaryInfo["comparison"]["neighbours"] =\
            self.get_infra_neighbour_comparison(
                boundary, active_schools, academic_year, year)

    def get_comparison(self, boundary, active_schools, academic_year, year):
        self.parentInfo = self.get_parent_info(boundary)
        self.boundaryInfo["comparison"]["neighbours"] = {}
        start_year = year.split('-')[0]
        end_year = year.split('-')[1]
        prev_year = str(int(start_year)-1) + "-" + str(int(end_year)-1)
        prev_prev_year = str(int(start_year)-2) + "-" + str(int(end_year)-2)
        self.boundaryInfo["comparison"]["year-wise"][prev_prev_year.replace('20', '')] =\
            {"year": prev_prev_year}
        self.boundaryInfo["comparison"]["year-wise"][prev_year.replace('20', '')] =\
            {"year": prev_year}
        self.boundaryInfo["comparison"]["year-wise"][year.replace('20', '')] =\
            {"year": year}

    def get_boundary_data(self, reporttype, boundaryid, reportname):
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        self.boundaryInfo["boundary_info"]["academic_year"] = year

        if reporttype == 'boundary':
            try:
                boundary = Boundary.objects.get(pk=boundaryid)
            except Exception:
                raise APIError('Boundary not found', 404)

            active_schools = boundary.schools()
            boundaryData = self.get_aggregations(active_schools, academic_year)
            boundaryData = self.check_values(boundaryData)
            self.get_summary_data(boundary, boundaryData, active_schools, academic_year)
            if reportname == "demographics":
                self.get_details_data(boundaryData, active_schools, academic_year)
                self.get_comparison_data(boundary, active_schools, academic_year,
                                         year, reporttype)
            elif reportname == "finance":
                self.get_grant_data()
            else:
                if boundary.type.id == 2:
                    self.boundaryInfo["infra"] = self.get_infra_data(boundary,
                                                                     active_schools,
                                                                     academic_year,
                                                                     year)
                    self.get_infra_comparison(boundary, active_schools, academic_year,
                                              year)
                else:
                    self.get_comparison(boundary, active_schools, academic_year, year)
                    print >>sys.stderr, self.boundaryInfo

        else:
            obj = ElectedrepMaster.objects.filter(id=boundaryid)
            self.boundaryInfo["name"] = obj.const_ward_name
            self.boundaryInfo["type"] = obj.const_ward_type
            self.boundaryInfo["id"] = obj.id
            self.boundaryInfo["code"] = obj.elec_comm_code
            self.boundaryInfo["elected_rep"] = obj.current_elected_rep
            self.boundaryInfo["elected_party"] = obj.current_elected_party

        return self.boundaryInfo

    def get(self, request):
        mandatoryparams = {'report_type': {"assembly",
                                           "parliament",
                                           "boundary"},
                           'id': {},
                           'report_name': {"demographics", "finance",
                                           "infrastructure"},
                           'language': {"english", "kannada"}}
        for params in mandatoryparams:
            if not self.request.GET.get(params):
                raise ParseError("Mandatory parameter "+params+" not passed")
            else:
                if mandatoryparams[params] != {} and \
                        self.request.GET.get(params) not in\
                        mandatoryparams[params]:
                    raise ParseError("Invalid "+params+" passed,pass from the "
                                     + str(mandatoryparams[params]))

        reporttype = self.request.GET.get("report_type")
        id = self.request.GET.get("id")
        reportname = self.request.GET.get("report_name")
        reportlang = self.request.GET.get("language")

        self.boundaryInfo["report_info"] = {"report_name": reportname,
                                            "report_type": reporttype,
                                            "report_lang": reportlang}
        self.get_boundary_data(reporttype, id, reportname)
        return Response(self.boundaryInfo)
