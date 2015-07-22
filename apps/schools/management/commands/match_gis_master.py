from schools.models import School, SchoolGIS, InstCoord
from django.core.management.base import BaseCommand
import json
import csv

class Command(BaseCommand):
    help = """Add points to schools from GIS master
            Generates a gis_sql.sql file that needs to be run
            on the klp-coord db.
            After this, remember to refresh materialized views.
            """

    def handle(self, *args, **kwargs):
        error_file = open("gis_errors.txt", "w")
        success_file = open("gis_success.txt", "w")
        output_sql = open("gis_sql.sql", "w")
        output_writer = csv.writer(output_csv)
        dise_not_found = []
        successes = []
        for school in School.objects.exclude(instcoord__isnull=False)\
                                    .exclude(dise_info__isnull=True):
            dise_code = school.dise_info_id
            try:
                dise_code_int = int(dise_code)
            except:
                continue
            gis_results = SchoolGIS.objects.filter(code=dise_code_int)
            if gis_results.count() == 0:
                print "Dise code not found: " + dise_code
                dise_not_found.append(dise_code_int)
                #error_file.write("Dise code not found: " + dise_code + "\n")
            elif gis_results.count() > 1:
                print "More than one Dise code found: " + dise_code
                #error_file.write("More than one Dise code found: " + dise_code + "\n")
            else:
                gis = gis_results[0]
                sql = "INSERT INTO inst_coord (instid, coord) VALUES (%s, ST_GeomFromText('%s', 4326));\n" % (school.id, gis.centroid.wkt,)
                output_sql.write(sql)    
                success = {
                    'gis_master_name': gis.name,
                    'klp_name': school.name,
                    'klp_id': school.id
                }
                successes.append(success)
        error_file.write(json.dumps(dise_not_found, indent=2))
        error_file.close()
        success_file.write(json.dumps(successes, indent=2))
        success_file.close()
        output_sql.close()
