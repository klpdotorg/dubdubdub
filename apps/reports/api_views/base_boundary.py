from schools.models import Boundary
from . import BaseReport
from django.db.models import Sum
from rest_framework.exceptions import ParseError


class BaseBoundaryReport(BaseReport):
    '''
        Has basic function for getting and checking data
    '''

    OLP_neighbor_names = {
    "keonjhar": [
        "sundergarh",
        "angul",
        "dhenkanal",
        "jajpur",
        "bhadrak",
        "balasore",
        "mayurbhanj"
    ],
    "bolangir": [
        "kalahandi",
        "nuapada",
        "kandhamal",
        "boudh",
        "sonepur",
        "bargarh"
    ],
    "nayagarh": [
        "angul",
        "boudh",
        "kandhamal",
        "ganjam",
        "khordha",
        "cuttack"
    ],
    "bargarh": [
        "bolangir",
        "nuapada",
        "sonepur",
        "sambalpur",
        "jharsuguda"
    ],
    "jharsuguda": [
        "sundergarh",
        "bargarh",
        "sambalpur"
    ],
    "kalahandi": [
        "nuapada",
        "balasore",
        "boudh",
        "kandhamal",
        "rayagada",
        "koraput",
        "nabarangpur"
    ],
    "jagatsinghpur": [
        "puri",
        "cuttack",
        "kendrapara"
    ],
    "sambalpur": [
        "sonepur",
        "boudh",
        "angul",
        "deogarh",
        "sundergarh",
        "jharsuguda",
        "bargarh"
    ],
    "koraput": [
        "malkangiri",
        "nabarangpur",
        "kalahandi",
        "rayagada"
    ],
    "kandhamal": [
        "rayagada",
        "gajapati",
        "ganjam",
        "nayagarh",
        "boudh",
        "kalahandi"
    ],
    "khordha": [
        "gajapati",
        "nayagarh",
        "cuttack",
        "puri"
    ],
    "deogarh": [
        "sundergarh",
        "sambalpur",
        "angul"
    ],
    "bhadrak": [
        "keonjhar",
        "balasore",
        "jajpur",
        "kendrapara"
    ],
    "nuapada": [
        "kalahandi",
        "bargarh",
        "bolangir"
    ],
    "sonepur": [
        "boudh",
        "angul",
        "sambalpur",
        "bargarh",
        "bolangir"
    ],
    "ganjam": [
        "gajapati",
        "kandhamal",
        "nayagarh",
        "khordha"
    ],
    "puri": [
        "khordha",
        "cuttack",
        "jagatsinghpur"
    ],
    "dhenkanal": [
        "angul",
        "cuttack",
        "jajpur",
        "kendrapara"
    ],
    "gajapati": [
        "rayagada",
        "kandhamal",
        "ganjam"
    ],
    "kendrapara": [
        "bhadrak",
        "jajpur",
        "cuttack",
        "jagatsinghpur"
    ],
    "sundergarh": [
        "jharsuguda",
        "sambalpur",
        "deogarh",
        "kendrapara",
        "angul"
    ],
    "rayagada": [
        "gajapati",
        "kandhamal",
        "koraput",
        "kalahandi"
    ],
    "mayurbhanj": [
        "balasore",
        "kendrapara"
    ],
    "malkangiri": [
        "koraput"
    ],
    "boudh": [
        "bolangir",
        "kalahandi",
        "kandhamal",
        "nayagarh",
        "angul",
        "sonepur",
        "sambalpur"
    ],
    "jajpur": [
        "keonjhar",
        "cuttack",
        "dhenkanal",
        "kendrapara",
        "bhadrak"
    ],
    "cuttack": [
        "nayagarh",
        "khordha",
        "puri",
        "jagatsinghpur",
        "kendrapara",
        "jajpur",
        "dhenkanal",
        "angul"
    ],
    "balasore": [
        "keonjhar",
        "bhadrak",
        "mayurbhanj"
    ],
    "angul": [
        "sonepur",
        "boudh",
        "nayagarh",
        "cuttack",
        "dhenkanal",
        "keonjhar",
        "sundergarh",
        "deogarh",
        "sambalpur"
    ],
    "nabarangpur": [
        "koraput",
        "rayagada",
        "kalahandi"
    ]
    }

    neighbordIds = {
    15108: [
        14358,
        15700,
        13369
    ],
    15495: [
        14152,
        12013,
        12993
    ],
    12303: [
        9140,
        12013,
        13135,
        13779
    ],
    11193: [
        13943,
        11591,
        14677
    ],
    14358: [
        14557,
        15108,
        13369,
        15700
    ],
    11417: [
        11725,
        15400,
        16068,
        15903,
        13300
    ],
    13597: [
        15700,
        12452,
        12610,
        15287,
        11948,
        13369
    ],
    15903: [
        16068,
        11948,
        9140,
        12247,
        16171,
        13300,
        11417
    ],
    12452: [
        15700,
        13597,
        12610
    ],
    15400: [
        13369,
        11417,
        11725
    ],
    16171: [
        13300,
        15903,
        12247,
        13779,
        9140
    ],
    11948: [
        11725,
        13369,
        13597,
        15287,
        9140,
        16068,
        15903
    ],
    9140: [
        16068,
        11948,
        15287,
        12013,
        12303,
        13943,
        16171,
        12247,
        15903
    ],
    15287: [
        9140,
        11948,
        13597,
        12610,
        14152,
        12013
    ],
    13369: [
        15400,
        11193,
        11948,
        13597,
        15700,
        14358,
        15108
    ],
    12993: [
        15495,
        12013,
        13779
    ],
    12610: [
        12452,
        13597,
        15287,
        14152
    ],
    16068: [
        11948,
        9140,
        15903,
        11417,
        11725
    ],
    11591: [
        13943,
        11193,
        13135,
        13779
    ],
    14152: [
        12452,
        15287,
        12013,
        15495
    ],
    11725: [
        13369,
        15400,
        13597,
        11948,
        16068,
        11417
    ],
    13135: [
        13943,
        12013,
        12303,
        13779,
        11591
    ],
    13779: [
        11591,
        13135,
        12013,
        12993
    ],
    15700: [
        12452,
        13597,
        14358,
        13369
    ],
    14677: [
        11193,
        13779
    ],
    12247: [
        16171,
        15903,
        9140
    ],
    14557: [
        14358
    ],
    12013: [
        15287,
        14152,
        15495,
        12993,
        13779,
        13135,
        12303,
        9140
    ],
    13300: [
        16171,
        11417,
        15903
    ],
    13943: [
        16171,
        9140,
        12303,
        13135,
        11591,
        11193,
        14677
    ]
    }

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
                         "Upper Primary": {"text": "Class 1 to 8",
                                           "student_count": 0}}
        for data in categoryData:
            if data["cat"] in ['Lower Primary', 'Upper Primary']:
                enrolmentdata[data['cat']]["student_count"] =\
                    data["num_boys"] + data["num_girls"]
            if data["cat"] == 'Model Primary':
                enrolmentdata['Upper Primary']["student_count"] +=\
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
