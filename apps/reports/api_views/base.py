from schools.models import Boundary
from django.db.models import Count, Sum
from rest_framework.exceptions import ParseError
import sys


class ReportBoundaryCounts(object):
    '''
        Returns Report Counts
    '''
    reportInfo = {"school_count": {}, "teacher_count": 0, "gender": {}}

    def get_teachercount(self, active_schools, academic_year):
        teachers = active_schools.filter(
            studentgroup__teachers__teacherstudentgroup__academic_year=
            academic_year).aggregate(
            count=Count('studentgroup__teachers__id', distinct=True))
        numteachers = teachers["count"]
        return numteachers

    def get_parent_info(self, boundary):
        parent = {"schoolcount": 0}
        if boundary.get_admin_level() != 1:
            parentObject = Boundary.objects.get(id=boundary.parent.id)
            schools = parentObject.schools()
            parent["schoolcount"] = schools.count()
        return parent

    def check_values(self, boundaryData):
        if boundaryData["num_girls"] is None:
            boundaryData["num_girls"] = 0
        if boundaryData["num_boys"] is None:
            boundaryData["num_boys"] = 0
        if boundaryData["num_schools"] is None:
            boundaryData["num_schools"] = 0
        return boundaryData

    def check_mandatory_params(self, mandatoryparams):
        for params in mandatoryparams:
            if not self.request.GET.get(params):
                raise ParseError("Mandatory parameter "+params+" not passed")
            else:
                print >>sys.stderr, mandatoryparams
                if mandatoryparams[params] != [] and \
                        self.request.GET.get(params) not in\
                        mandatoryparams[params]:
                    raise ParseError("Invalid "+params+" passed,pass from the "
                                     + str(mandatoryparams[params]))

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
