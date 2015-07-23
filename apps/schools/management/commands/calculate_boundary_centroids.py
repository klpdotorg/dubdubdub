from schools.models import School, Boundary, BoundaryHierarchy, BoundaryCoord
from django.core.management.base import BaseCommand
import json

class Command(BaseCommand):
    help = """Add points to schools from GIS master
            Generates a boundaries_sql.sql file that needs to be run
            on the klp-coord db.
            After this, remember to refresh materialized views.
            """

    def handle(self, *args, **kwargs):
        #error_file = open("gis_errors.txt", "w")
        #success_file = open("gis_success.txt", "w")
        output_sql = open("boundaries_sql.sql", "w")
        BOUNDARY_TYPES = {
            'district': 'admin1',
            'block': 'admin2',
            'project': 'admin2',
            'cluster': 'admin3',
            'circle': 'admin3'
        }
        empty_boundaries = []
        for hierarchy in BoundaryHierarchy.objects.all():
            hierarchy_name = hierarchy.name
            if hierarchy_name not in BOUNDARY_TYPES:
                continue
            admin_level = BOUNDARY_TYPES[hierarchy_name]
            boundaries = Boundary.objects.filter(hierarchy=hierarchy)
            for boundary in boundaries:
                qstring = "schooldetails__%s" % admin_level
                filter_q = {qstring: boundary}
                schools = School.objects.filter(**filter_q).exclude(instcoord__isnull=True)
                if not schools.exists():
                    empty_boundaries.append(boundary.id)
                    continue
                #import pdb;pdb.set_trace()
                points = [s.instcoord.coord for s in schools]
                multipoint_string = ", ".join(["%f %f" % (p.x, p.y,) for p in points])
                multipoint_wkt = "MULTIPOINT(%s)" % multipoint_string
                hierarchy_cap = hierarchy_name.capitalize()
                if BoundaryCoord.objects.filter(boundary=boundary).exists():
                    sql = "UPDATE boundary_coord SET coord=ST_SetSRID(ST_Centroid('%s'), 4326) WHERE id_bndry=%d;" % (multipoint_wkt, boundary.id,)
                else:
                    sql = "INSERT INTO boundary_coord (id_bndry, type, coord) VALUES (%d, '%s', ST_SetSRID(ST_Centroid('%s'), 4326));" % (boundary.id, hierarchy_cap, multipoint_wkt,)
                print sql
                output_sql.write(sql + "\n")
        output_sql.close()
        errors = open("empty_boundaries.txt", "w")
        errors.write(json.dumps(empty_boundaries, indent=2))
        errors.close()