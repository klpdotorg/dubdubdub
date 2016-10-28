from schools.models import Boundary
from django.db.models import Count, Sum
from rest_framework.exceptions import ParseError


class BaseBoundaryReport(object):
    '''
        Has basic function for getting and checking data
    '''

    #Get dise information for the boundary
    def get_dise_school_info(self, active_schools, academic_year):
        dise_schools = active_schools  #TODO.filter(acyear=academic_year)
        agg = {
            'num_schools': dise_schools.count(),
            'gender': {'boys': dise_schools.aggregate(num_boys=Sum('boys_count'))['num_boys'],
                       'girls': dise_schools.aggregate(num_girls=Sum('girls_count'))['num_girls']
                       },
            'teacher_count': dise_schools.aggregate(num_teachers=Sum('teacher_count'))['num_teachers']
        }
        agg['num_students'] = agg['gender']['boys'] + agg['gender']['girls']
        return agg

    #Returns the number of teachers in the schools for the year
    def get_teachercount(self, active_schools, academic_year):
        teachers = active_schools.filter(
            studentgroup__teachers__teacherstudentgroup__academic_year=
            academic_year).aggregate(
            count=Count('studentgroup__teachers__id', distinct=True))
        numteachers = teachers["count"]
        return numteachers

    #Returns the count of schools in the parent boundary, if the passed boundary is district then returns the count of schools in all the districts
    def get_parent_info(self, boundary):
        parent = {"schoolcount": 0}
        if boundary.get_admin_level() != 1:
            parentObject = Boundary.objects.get(id=boundary.parent.id)
            schools = parentObject.schools()
            parent["schoolcount"] = schools.count()
        else:
            neighbours = Boundary.objects.filter(parent=1, type=1)
            for neighbour in neighbours:
                count = neighbour.schools().count()
                parent["schoolcount"] += count
        return parent

    #Returns 0 where data is None
    def check_values(self, boundaryData):
        if boundaryData["num_girls"] is None:
            boundaryData["num_girls"] = 0
        if boundaryData["num_boys"] is None:
            boundaryData["num_boys"] = 0
        if boundaryData["num_schools"] is None:
            boundaryData["num_schools"] = 0
        return boundaryData

    #Throws error if mandatory parameters are missing
    def check_mandatory_params(self, mandatoryparams):
        for params in mandatoryparams:
            if not self.request.GET.get(params):
                raise ParseError("Mandatory parameter "+params+" not passed")
            else:
                if mandatoryparams[params] != [] and \
                        self.request.GET.get(params) not in\
                        mandatoryparams[params]:
                    raise ParseError("Invalid "+params+" passed,pass from the "
                                     + str(mandatoryparams[params]))

    #Returns the category wise average enrolment data
    def get_enrolment(self, categoryData):
        enrolmentdata = {"Lower Primary": {"text": "Class 1 to 4",
                                           "student_count": 0},
                         "Upper Primary": {"text": "Class 5 to 8",
                                           "student_count": 0}}
        for data in categoryData:
            if data["cat"] in ['Lower Primary', 'Upper Primary']:
                enrolmentdata[data['cat']]["student_count"] = (data["num_boys"] + data["num_girls"])/data["num_schools"]

        return enrolmentdata

    #Returns the basic information of the pased boundary
    def get_boundary_summary_data(self, boundary, reportData):
        reportData["boundary_info"] = {}
        reportData["boundary_info"]["name"] = boundary.name
        reportData["boundary_info"]["type"] = boundary.hierarchy.name
        reportData["boundary_info"]["id"] = boundary.id
        reportData["boundary_info"]["parent"] = {}
        reportData["boundary_info"]["btype"] = boundary.type.id
        reportData["boundary_info"]["dise"] = boundary.dise_slug
        if boundary.get_admin_level() != 1:
            reportData["boundary_info"]["parent"] = {
                "type": boundary.parent.hierarchy.name, "name": boundary.parent.name,
                "dise": boundary.parent.dise_slug}
