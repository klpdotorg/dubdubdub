from django.db.models import Sum
from django.db import transaction
from django.core.management.base import BaseCommand
from django.core.cache import cache
from schools.models import (LibLangAgg, LibLevelAgg, BoundaryLibLevelAgg,
    BoundaryLibLangAgg, Boundary, AcademicYear)


class Command(BaseCommand):
    help = 'Aggregate Library data'

    @transaction.atomic
    def level_data(self, academic_year):
        boundaries = Boundary.objects.filter(
            school__liblevelagg__child_count__isnull=False
        ).values(
            'id',
            'name',
            'school__liblevelagg__class_name',
            'school__liblevelagg__month',
            'school__liblevelagg__year',
            'school__liblevelagg__book_level'
        ).annotate(child_count=Sum('school__liblevelagg__child_count'))

        boundary_aggregations = []

        for boundary in boundaries:
            boundary_aggregations.append(
                BoundaryLibLevelAgg(
                    boundary_id=boundary.get('id'),
                    academic_year=academic_year,
                    class_name=boundary.get('school__liblevelagg__class_name'),
                    month=boundary.get('school__liblevelagg__month'),
                    year=boundary.get('school__liblevelagg__year'),
                    book_level=boundary.get('school__liblevelagg__book_level'),
                    child_count=boundary.get('child_count')
                )
            )

        # BoundaryLibLevelAgg.objects.bulk_create(boundary_aggregations)

    @transaction.atomic
    def lang_data(self, academic_year):
        boundaries = Boundary.objects.filter(
            school__liblangagg__child_count__isnull=False
        ).values(
            'id',
            'name',
            'school__liblangagg__class_name',
            'school__liblangagg__month',
            'school__liblangagg__year',
            'school__liblangagg__book_lang'
        ).annotate(child_count=Sum('school__liblangagg__child_count'))

        boundary_aggregations = []

        for boundary in boundaries:
            boundary_aggregations.append(
                BoundaryLibLangAgg(
                    boundary_id=boundary.get('id'),
                    academic_year=academic_year,
                    class_name=boundary.get('school__liblangagg__class_name'),
                    month=boundary.get('school__liblangagg__month'),
                    year=boundary.get('school__liblangagg__year'),
                    book_lang=boundary.get('school__liblangagg__book_lang'),
                    child_count=boundary.get('child_count')
                )
            )

        # BoundaryLibLangAgg.objects.bulk_create(boundary_aggregations)

    @transaction.atomic
    def handle(self, *args, **options):
        academic_year = AcademicYear.objects.get(name='2011-2012')

        self.level_data(academic_year)
