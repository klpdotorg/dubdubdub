from django.db.models import Count
from rest_framework.exceptions import ParseError


class BaseReport():

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

    # Returns 0 where data is None
    def check_values(self, data):
        if data["num_girls"] is None:
            data["num_girls"] = 0
        if data["num_boys"] is None:
            data["num_boys"] = 0
        if data["num_schools"] is None:
            data["num_schools"] = 0
        return data

    # Returns the number of teachers in the schools for the year
    def get_teachercount(self, active_schools, academic_year):
        teachers = active_schools.filter(
            studentgroup__teachers__teacherstudentgroup__academic_year=academic_year
            ).aggregate(
            count=Count('studentgroup__teachers__id', distinct=True))
        numteachers = teachers["count"]
        return numteachers
