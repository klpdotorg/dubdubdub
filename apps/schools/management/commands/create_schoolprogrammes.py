from django.db import transaction
from django.core.management.base import BaseCommand

from schools.models import (
    Programme, School, BoundaryType, SchoolProgrammes, Boundary
)


district_names = [
    "gulbarga",
    "yadgiri",
    "raichur",
    "koppal",
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
        if not Programme.objects.filter(name="Ganitha Kanika Andolana").exists():
            id = Programme.objects.latest('id').id + 1
            btype = BoundaryType.objects.get(name='Primary School')
            programme, created = Programme.objects.get_or_create(
                id=id, name="Ganitha Kanika Andolana", boundary_type=btype
            )
        else:
            programme = Programme.objects.get(name="Ganitha Kanika Andolana")

        boundary = Boundary.objects.filter(
            name__in=district_names, hierarchy__name="district",
            type__name="Primary School"
        )
        schools = School.objects.filter(admin3__parent__parent=boundary)     

        for school in schools:
            print school
            SchoolProgrammes.objects.get_or_create(programme=programme, school=school)
