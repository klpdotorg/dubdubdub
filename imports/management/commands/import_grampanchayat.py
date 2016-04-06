from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from collections import defaultdict
import os
from csv import DictReader
from datetime import datetime
from schools.models import School, Locality, Assembly, Parliament, GramPanchayat


def log(msg):
    print(msg)
    with open('imports/import.log', 'a') as f:
        f.writelines([
            '\n',
            '[' + datetime.now().isoformat() + '] ' + msg
        ])


class Command(BaseCommand):
    help = 'Imports gram panchayat data'
    MLA_NAME_REMAP = {
        'GULBARGA NORTH': "Gulbarga Uttar",
        'JEWARGI': "Jevargi",
        'YADAGIRI': "Yadgir",
        'GANGAVATI': "Gangawati",
        'BELLARY RURAL': "Bellary",
        'VIJAYNAGARA': "Vijayanagara",
        'LINGASUGUR': "Lingsugur",
        'SINDHNUR': "Sindhanur",
        'HUMNABAD': "Homnabad",
        'BELLARY URBAN': "Bellary city",
        'GULBARGA SOUTH': "Gulbarga Dakshin",
        'HADAGALI': "Hadagalli",
        'YELABURGA': "Yelburga",
    }

    NOPE_LIST = ['NF', 'NA']

    def handle(self, *args, **options):
        with open('data/gka-with-klpid.csv', 'r') as gkafile:
            reader = DictReader(gkafile)
            for gpdata in reader:
                if gpdata['MLA Constituency'] in self.NOPE_LIST or gpdata['MP Constituency'] in self.NOPE_LIST:
                    continue

                assembly = Assembly.objects.get(
                    name__iexact=self.MLA_NAME_REMAP.get(gpdata['MLA Constituency'], gpdata['MLA Constituency'])
                )
                parliament = Parliament.objects.get(name__iexact=gpdata['MP Constituency'])
                gp, created = GramPanchayat.objects.get_or_create(
                    name=gpdata['Gram Panchayat'],
                    assembly_id=assembly.id,
                    parliament_id=parliament.id
                )

                if created:
                    print 'created GP', gp.name
                else:
                    locality = Locality.objects.get(school_id=gpdata['KLP ID'])
                    locality.gram_panchayat_id = gp.id
                    locality.save()
