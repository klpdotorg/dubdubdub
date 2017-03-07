from schools.models import ElectedrepMaster
from . import BaseReport
from common.exceptions import APIError


class BaseElectedRepReport(BaseReport):

    def getSummaryData(self, electedrep, reportInfo):
        reportInfo["report_info"] = {}
        reportInfo["report_info"]["commision_code"] = \
            electedrep.elec_comm_code
        reportInfo["report_info"]["name"] = \
            electedrep.const_ward_name.lower()
        reportInfo["report_info"]["type"] = \
            electedrep.const_ward_type.lower()
        reportInfo["report_info"]["dise"] = electedrep.dise_slug
        reportInfo["report_info"]["elected_party"] = \
            electedrep.current_elected_party.lower()
        reportInfo["report_info"]["elected_rep"] = \
            electedrep.current_elected_rep.lower()

    def getNeighbours(self, neighbours, elect_type, reportInfo):
        for neighbour in neighbours:
            try:
                electedrep = ElectedrepMaster.objects.filter(
                    elec_comm_code=neighbour, const_ward_type=elect_type)
            except Exception:
                raise APIError('ElectedRep neighbour id ('+neighbour+') not found', 404)
            neighbour = {}
            for rep in electedrep:
                neighbour["commision_code"] = rep.elec_comm_code
                neighbour["name"] = rep.const_ward_name.lower()
                neighbour["type"] = rep.const_ward_type.lower()
                neighbour["elected_party"] = rep.current_elected_party.lower()
                neighbour["elected_rep"] = rep.current_elected_rep.lower()
                neighbour["dise"] = rep.dise_slug
            reportInfo["neighbour_info"].append(neighbour)

    def getParentData(self, electedrep, reportInfo):
        reportInfo["parent_info"] = []
        if electedrep.parent is not None:
            reportInfo["parent_info"].append({
                "const_ward_type": electedrep.parent.const_ward_type,
                "const_ward_name": electedrep.parent.const_ward_name,
                "id": electedrep.parent.id})
        if electedrep.parent.parent is not None:
            reportInfo["parent_info"].append({
                "const_ward_type": electedrep.parent.parent.const_ward_type,
                "const_ward_name": electedrep.parent.parent.const_ward_name,
                "id": electedrep.parent.parent.id})
        if electedrep.parent.parent.parent is not None:
            reportInfo["parent_info"].append({
                "const_ward_type": electedrep.parent.parent.parent.const_ward_type,
                "const_ward_name": electedrep.parent.parent.parent.const_ward_name,
                "id": electedrep.parent.parent.parent.id})
