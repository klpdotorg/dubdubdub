from schools.models import Boundary
from . import BaseReport
from django.db.models import Sum
from rest_framework.exceptions import ParseError


class BaseBoundaryReport(BaseReport):
    '''
        Has basic function for getting and checking data
    '''
    neighbourIds = {413: [414,  415,  420, 421, 422],
                    414: [413, 415, 418, 419, 420],
                    415: [413, 414, 416, 418, 445],
                    416: [415, 417, 445],
                    417: [416],
                    418: [414, 415, 419, 424, 445],
                    419: [414.418, 420, 424],
                    420: [414, 419, 421, 423, 424],
                    421: [413, 420, 422, 423],
                    422: [413, 421, 423, 427, 428],
                    423: [420, 421, 422, 424, 426, 427],
                    424: [418, 419, 420, 423, 426, 425],
                    425: [424, 426, 429, 430],
                    426: [423, 424, 425, 427, 429],
                    427: [422, 423, 426, 428, 429],
                    428: [422, 427, 429, 436],
                    429: [425, 426, 427, 428, 430, 435, 436],
                    430: [425, 429, 433, 434, 435, 441, 444],
                    431: [433, 441, 9540, 9541],
                    433: [430, 431, 444, 9540, 9541],
                    434: [430, 435, 439, 444, 8878],
                    435: [429, 430, 434, 436, 437, 8878],
                    436: [428, 429, 435, 437],
                    437: [435, 436, 8878],
                    439: [434, 444, 8878],
                    441: [430, 431, 433],
                    442: [414, 415, 420, 421, 422],
                    443: [425, 429, 433, 434, 435, 441, 444],
                    444: [430, 433, 434, 439, 9540, 9541],
                    445: [415, 416, 418],
                    8878: [434, 435, 437, 439],
                    9540: [431, 433, 444, 9541],
                    9541: [431, 433, 444, 9540]}

    # Get dise information for the boundary
    def get_dise_school_info(self, active_schools, academic_year):
        dise_schools = active_schools  # TODO.filter(acyear=academic_year)
        agg = {
            'num_schools': dise_schools.count(),
            'gender': {'boys': dise_schools.aggregate(
                                num_boys=Sum('boys_count'))['num_boys'],
                       'girls': dise_schools.aggregate(
                                num_girls=Sum('girls_count'))['num_girls']
                       },
            'teacher_count': dise_schools.aggregate(
                                num_teachers=Sum('teacher_count'))['num_teachers']
        }
        agg['num_students'] = agg['gender']['boys'] + agg['gender']['girls']
        return agg

    # Returns the count of schools in the parent boundary, if the passed boundary
    # is district then returns the count of schools in all the districts
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

    def getDistrictNeighbours(self, boundary):
        neighbours = self.neighbourIds[boundary.id]
        return Boundary.objects.filter(id__in=neighbours)

    # Returns 0 where data is None
    def check_values(self, boundaryData):
        if boundaryData["num_girls"] is None:
            boundaryData["num_girls"] = 0
        if boundaryData["num_boys"] is None:
            boundaryData["num_boys"] = 0
        if boundaryData["num_schools"] is None:
            boundaryData["num_schools"] = 0
        return boundaryData

    # Throws error if mandatory parameters are missing
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

    # Returns the category wise average enrolment data
    def get_enrolment(self, categoryData):
        enrolmentdata = {"Lower Primary": {"text": "Class 1 to 4",
                                           "student_count": 0},
                         "Upper Primary": {"text": "Class 5 to 8",
                                           "student_count": 0}}
        for data in categoryData:
            if data["cat"] in ['Lower Primary', 'Upper Primary']:
                enrolmentdata[data['cat']]["student_count"] =\
                    data["num_boys"] + data["num_girls"]

        return enrolmentdata

    # Returns the basic information of the pased boundary
    def get_boundary_summary_data(self, boundary, reportData):
        reportData["report_info"] = {}
        reportData["report_info"]["name"] = boundary.name
        reportData["report_info"]["type"] = boundary.hierarchy.name
        reportData["report_info"]["id"] = boundary.id
        reportData["report_info"]["parent"] = []
        reportData["report_info"]["btype"] = boundary.type.id
        reportData["report_info"]["dise"] = boundary.dise_slug
        if boundary.get_admin_level() == 2:
            reportData["report_info"]["parent"] = [{
                "type": boundary.parent.hierarchy.name,
                "name": boundary.parent.name,
                "dise": boundary.parent.dise_slug}]
        elif boundary.get_admin_level() == 3:
            reportData["report_info"]["parent"] = [{
                "type": boundary.parent.parent.hierarchy.name,
                "name": boundary.parent.parent.name,
                "dise": boundary.parent.parent.dise_slug}, {
                "type": boundary.parent.hierarchy.name,
                "name": boundary.parent.name,
                "dise": boundary.parent.dise_slug}
                ]
