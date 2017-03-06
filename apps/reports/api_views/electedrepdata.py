from rest_framework.response import Response
from schools.models import ElectedrepMaster, AcademicYear
from . import BaseBoundaryReport
from common.views import KLPAPIView
from common.exceptions import APIError
from django.conf import settings


class ElectedRepInfo(KLPAPIView, BaseBoundaryReport):

    reportInfo = {}

    def get_parent_info(self, electedrep):
        self.reportInfo["parent_info"] = []
        if electedrep.parent is not None:
            self.reportInfo["parent_info"].append({
                "const_ward_type": electedrep.parent.const_ward_type,
                "const_ward_name": electedrep.parent.const_ward_name,
                "id": electedrep.parent.id})
        if electedrep.parent.parent is not None:
            self.reportInfo["parent_info"].append({
                "const_ward_type": electedrep.parent.parent.const_ward_type,
                "const_ward_name": electedrep.parent.parent.const_ward_name,
                "id": electedrep.parent.parent.id})
        if electedrep.parent.parent.parent is not None:
            self.reportInfo["parent_info"].append({
                "const_ward_type": electedrep.parent.parent.parent.const_ward_type,
                "const_ward_name": electedrep.parent.parent.parent.const_ward_name,
                "id": electedrep.parent.parent.parent.id})

    def getNeighbours(self, neighbours, elect_type):
        for neighbour in neighbours:
            try:
                electedrep = ElectedrepMaster.objects.filter(
                    elec_comm_code=neighbour, const_ward_type=elect_type)
            except Exception:
                raise APIError('ElectedRep neighbour id not found', 404)
            neighbour = {}
            for rep in electedrep:
                neighbour["commision_code"] = rep.elec_comm_code
                neighbour["name"] = rep.const_ward_name.lower()
                neighbour["type"] = rep.const_ward_type.lower()
                neighbour["elected_party"] = rep.current_elected_party.lower()
                neighbour["elected_rep"] = rep.current_elected_rep.lower()
                neighbour["dise"] = rep.dise_slug
            self.reportInfo["neighbour_info"].append(neighbour)

    def get_electedrep_info(self, electedrepid):
        year = self.request.GET.get('year', settings.DEFAULT_ACADEMIC_YEAR)
        try:
            academic_year = AcademicYear.objects.get(name=year)
        except AcademicYear.DoesNotExist:
            raise APIError('Academic year is not valid.\
                    It should be in the form of 2011-2012.', 404)
        self.reportInfo["academic_year"] = year
        try:
            electedrep = ElectedrepMaster.objects.get(pk=electedrepid)
        except Exception:
            raise APIError('ElectedRep id not found', 404)
        self.reportInfo["electedrep_info"] = {}
        self.reportInfo["electedrep_info"]["commision_code"] = \
            electedrep.elec_comm_code
        self.reportInfo["electedrep_info"]["name"] = \
            electedrep.const_ward_name.lower()
        self.reportInfo["electedrep_info"]["type"] = \
            electedrep.const_ward_type.lower()
        self.reportInfo["electedrep_info"]["dise"] = electedrep.dise_slug
        self.reportInfo["electedrep_info"]["elected_party"] = \
            electedrep.current_elected_party.lower()
        self.reportInfo["electedrep_info"]["elected_rep"] = \
            electedrep.current_elected_rep.lower()
        self.reportInfo["neighbour_info"] = []
        if electedrep.neighbours:
            self.getNeighbours(electedrep.neighbours.split('|'),
                               electedrep.const_ward_type)
        self.get_parent_info(electedrep)

    def get(self, request):
        mandatoryparams = {'id': [], 'language': ["english", "kannada"]}
        self.check_mandatory_params(mandatoryparams)

        id = self.request.GET.get("id")
        reportlang = self.request.GET.get("language")

        self.reportInfo["report_info"] = {"report_lang": reportlang}
        self.get_electedrep_info(id)
        return Response(self.reportInfo)
