from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import (
    Programme, School, BoundaryType, SchoolProgrammes
)


district_names = [
    "gulbarga",
    "yadgiri",
    "raichur",
    "koppala",
    "bellary",
    "bidar"
]

class Command(BaseCommand):
    args = ""
    help = """Creates 'Ganitha Kalika Andolana' Programme object.
    Maps Schools and GKA Programme.
    ./manage.py user_and_preschool """


    @transaction.atomic
    def handle(self, *args, **options):
        if not Programme.objects.filter(name="Ganika Kanika Andolana").exists():
            id = Programme.objects.latest('id').id + 1
            btype = BoundaryType.objects.get(name='Primary School')
            programme, created = Programme.objects.get_or_create(
                id=id, name="Ganika Kanika Andolana", boundary_type=btype
            )
        else:
            programme = Programme.objects.get(name="Ganika Kanika Andolana")

        schools = School.objects.filter(admin3__parent__parent__name__in=district_names)     

        for school in schools:
            SchoolProgrammes.objects.get_or_create(programme=programme, school=school)
