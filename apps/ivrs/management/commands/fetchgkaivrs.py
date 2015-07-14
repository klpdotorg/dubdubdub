from django.core.management.base import BaseCommand

from .models import State
from stories.models import Story, UserType, Questiongroup, Answer

class Command(BaseCommand):
    args = ""
    help = """Analyzes the GKA IVRS states and saves stories.

    ./manage.py fetchgkaivrs"""

    @transaction.atomic
    def handle(self, *args, **options):
        states = State.objects.all()
        for state in states:
            school = School.objects.get(id=state.school_id)
            telephone = state.telephone
            date = state.date_of_visit
            akshara_staff = UserType.objects.get_or_create(
                name=UserType.AKSHARA_STAFF
            )[0]
            question_group = Questiongroup.objects.get(
                version=2,
                source__name='ivrs'
            )

            story = Story.objects.create(
                school=school,
                group=question_group,
                date_of_visit=date,
                telephone=telephone,
                user_type=akshara_staff
            )

            for (question_number, answer) in enumerate(state.answers):
                if answer != 'NA':
                    question = get_question(question_number+1)
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer
                    )

        return 1
