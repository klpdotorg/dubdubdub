import sys
from rest_framework.response import Response
from schools.models import ElectedrepMaster, Boundary, AcademicYear
from .aggregations import BaseSchoolAggView
from common.views import KLPAPIView
from common.exceptions import APIError
from rest_framework.exceptions import ParseError
from django.conf import settings
from django.db.models import Count, Sum


class ReportsDetail(KLPAPIView, BaseSchoolAggView):

    '''
        Returns report details
    '''
    boundaryInfo = {"boundary_info": {}, "school_count": {}, "teacher_count": 0,
                    "gender": {}, "categories": {}, "enrolment": {},
                    "languages": {"moi": {}, "mt": {}},
                    "comparison": {"year-wise": {}, "neighbours": {}}}

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


    def get_yeardata(self, active_schools, year, year_id):
        yeardata = {"year": year, "enrol_upper": 0, "enrol_lower": 0,
                    "school_count": 0}
        enrolment = self.get_enrolment(active_schools, year_id)
        yeardata["enrol_upper"] = enrolment["Class 5-8"]["student_count"]
        yeardata["enrol_lower"] = enrolment["Class 1-4"]["student_count"]
        boundaryData = self.get_aggregations(active_schools, year_id)
        teacher_count = self.get_teachercount(active_schools, year_id)
        student_count = boundaryData["num_boys"] + boundaryData["num_girls"]
        yeardata["student_count"] = student_count
        yeardata["teacher_count"] = teacher_count
        yeardata["school_count"] = boundaryData["num_schools"]

        if self.parentInfo["schoolcount"] == 0:
            yeardata["school_perc"] = 100
        else:
            yeardata["school_perc"] = round(boundaryData["num_schools"]*100
                                      / float(self.parentInfo["schoolcount"]),2)
        if teacher_count == 0:
            yeardata["ptr"] = "NA"
        else:
            yeardata["ptr"] = round(student_count/float(teacher_count), 2)
        return yeardata


    def get_parentInfo(self, boundary):
        parent = {}
        parent["object"] = Boundary.objects.get(id=boundary.parent.id)
        parent["schools"] = parent["object"].schools()
        parent["schoolcount"] = parent["object"].schools().count()
        return parent


    def get_year_comparison(self, active_schools, academic_year, year,
                                reporttype, boundary):
        comparisonData = {}
        start_year = year.split('-')[0]
        end_year = year.split('-')[1]
        prev_year = str(int(start_year)-1) + "-" + str(int(end_year)-1)
        prev_prev_year = str(int(start_year)-2) + "-" + str(int(end_year)-2)

        prev_year_id = AcademicYear.objects.get(name=prev_year)
        prev_prev_year_id = AcademicYear.objects.get(name=prev_prev_year)

        comparisonData[year] = {"year": year,
                                "enrol_upper":
                                    self.boundaryInfo["enrolment"]
                                    ["Class 5-8"]["student_count"],
                                "enrol_lower":
                                    self.boundaryInfo["enrolment"]
                                    ["Class 1-4"]["student_count"],
                                "student_count":
                                    self.boundaryInfo["student_count"],
                                "teacher_count":
                                    self.boundaryInfo["teacher_count"]}
        if self.boundaryInfo["teacher_count"] == 0:
            comparisonData[year]["ptr"] = "NA"
        else:
            comparisonData[year]["ptr"] = round(
                    self.boundaryInfo["student_count"] /
                    float(self.boundaryInfo["teacher_count"]), 2)

        if self.parentInfo["schoolcount"] == 0:
            comparisonData[year]["school_perc"] = 100
        else:
            comparisonData[year]["school_perc"] = round(
                    self.boundaryInfo["school_count"] *
                    100 / float(self.parentInfo["schoolcount"]), 2)

        comparisonData[prev_year] = self.get_yeardata(active_schools, prev_year,
                                        prev_year_id)
        comparisonData[prev_prev_year] = self.get_yeardata(active_schools,
                                            prev_prev_year, prev_prev_year_id)

        return comparisonData

    def get_neighbour_comparison(self, academic_year, reporttype, boundary):
        comparisonData = {}
        neighbours = Boundary.objects.filter(parent=boundary.parent)
        for neighbour in neighbours:
            comparisonData[neighbour.name] = {"name": neighbour.name,
                                                "enrol_upper": 0,
                                                "enrol_lower": 0,
                                                "ptr": 0,
                                                "school_count": 0,
                                                "school_perc": 0}
            active_schools = neighbour.schools()
            if active_schools.exists():
                boundaryData = self.get_aggregations(active_schools,
                                                     academic_year)
                enrolment = self.get_enrolment(active_schools, academic_year)
                comparisonData[neighbour.name]["enrol_upper"] =\
                                   enrolment["Class 5-8"]["student_count"]
                comparisonData[neighbour.name]["enrol_lower"] =\
                                   enrolment["Class 1-4"]["student_count"]
                comparisonData[neighbour.name]["school_count"] =\
                                    boundaryData["num_schools"]
                teacher_count = self.get_teachercount(active_schools,
                        academic_year)
                student_count = boundaryData["num_boys"] +\
                                    boundaryData["num_girls"]
                comparisonData[neighbour.name]["student_count"] = student_count
                comparisonData[neighbour.name]["teacher_count"] = teacher_count
                if self.parentInfo["schoolcount"] == 0:
                    comparisonData[neighbour.name]["school_perc"] = 100
                else:
                    comparisonData[neighbour.name]["school_perc"] = round(
                            boundaryData["num_schools"] * 100 /
                            float(self.parentInfo["schoolcount"]), 2)
                if teacher_count == 0:
                    comparisonData[neighbour.name]["ptr"] = "NA"
                else:
                    comparisonData[neighbour.name]["ptr"] = round(
                            student_count / float(teacher_count), 2)

        return comparisonData


    def getSummaryData(self, boundary, boundaryData):
        self.boundaryInfo["boundary_info"]["name"] = boundary.name
        self.boundaryInfo["boundary_info"]["type"] = boundary.hierarchy.name
        self.boundaryInfo["boundary_info"]["id"] = boundary.id
        self.boundaryInfo["boundary_info"]["parent"]={}
        if boundary.get_admin_level() == 2:
            self.boundaryInfo["boundary_info"]["parent"] = {boundary.parent.hierarchy.name: boundary.parent.name}
        elif boundary.get_admin_level() == 3:
            self.boundaryInfo["boundary_info"]["parent"][boundary.parent.hierarchy.name] = boundary.parent.name
            self.boundaryInfo["boundary_info"]["parent"][boundary.parent.parent.hierarchy.name] = boundary.parent.parent.name

        self.boundaryInfo["gender"] = {"boys": boundaryData["num_boys"],
                                      "girls": boundaryData["num_girls"]}
        self.boundaryInfo["school_count"] = boundaryData["num_schools"]
        self.boundaryInfo["student_count"] = boundaryData["num_boys"] +\
                                                boundaryData["num_girls"]

    def getDetailsData(self, boundaryData, active_schools, academic_year):
        for data in boundaryData["cat"]:
            self.boundaryInfo["categories"][data["cat"]] = {
                        "school_count": data["num_schools"],
                        "student_count": data["num_boys"] + data["num_girls"]}
        for data in boundaryData["moi"]:
                self.boundaryInfo["languages"]["moi"][data["moi"].upper()] =\
                        {"school_count": data["num"]}
        for data in boundaryData["mt"]:
                self.boundaryInfo["languages"]["mt"][data["name"].upper()] =\
                        {"student_count": data["num_students"]}

        self.boundaryInfo["enrolment"] =\
                            self.get_enrolment(active_schools, academic_year)
        self.boundaryInfo["teacher_count"] =\
                            self.get_teachercount(active_schools, academic_year)

    def getComparisonData(self, boundary, active_schools, academic_year, year, reporttype):
        self.parentInfo = self.get_parentInfo(boundary)
        self.boundaryInfo["comparison"]["year-wise"] =\
                    self.get_year_comparison(active_schools,
                            academic_year, year, reporttype, boundary)
        self.boundaryInfo["comparison"]["neighbours"] =\
                    self.get_neighbour_comparison(academic_year,
                            reporttype, boundary)

    def get_boundaryData(self, reporttype , boundaryid, reportname):
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid. It should be in the form of 2011-2012.', 404)


        if reporttype == 'boundary':
            try:
                boundary = Boundary.objects.get(pk=boundaryid)
            except Exception:
                raise APIError('Boundary not found', 404)

            active_schools = boundary.schools()
            boundaryData = self.get_aggregations(active_schools, academic_year)
            print >> sys.stderr, "----------------------------"
            print >>sys.stderr, boundary
            print >>sys.stderr, boundaryData
            self.getSummaryData(boundary, boundaryData)
            if reportname == "demographics":
                self.getDetailsData(boundaryData, active_schools, academic_year)
                self.getComparisonData(boundary, active_schools, academic_year,
                        year, reporttype)

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
        mandatoryparams = {'report_type':
                           {"assembly", "parliament", "boundary"},
                           'id': {},
                           'report_name': {"demographics", "finance"},
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
        self.get_boundaryData(reporttype, id, reportname)
        return Response(self.boundaryInfo)
