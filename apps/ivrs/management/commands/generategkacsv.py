import time
from datetime import datetime, timedelta

from django.db import transaction
from django.core.management.base import BaseCommand

from ivrs.models import State
from stories.models import Story, UserType, Questiongroup, Answer


class Command(BaseCommand):
    args = ""
    help = """Creates csv files for calls happened each day

    ./manage.py generategkacsv"""

    @transaction.atomic
    def handle(self, *args, **options):
        states = State.objects.filter(
            date_of_visit__lte=datetime.now()
        )

        date = datetime.now().date().strftime("%d_%b_%Y")
        csv = open(date+".csv", "w")

        lines = ["Sl. No, School ID, Telephone, Date Of Visit, Invalid, \
Was the school open?, \
Class visited, \
Was Math class happening on the day of your visit?, \
Which chapter of the textbook was taught?, \
Which Ganitha Kalika Andolana TLM was being used by teacher?, \
Did you see children using the Ganitha Kalika Andolana TLM?, \
Was group work happening in the class on the day of your visit?, \
Were children using square line book during math class?, \
Are all the toilets in the school functional?, \
Does the school have a separate functional toilet for girls?, \
Does the school have drinking water?, \
Is a Mid Day Meal served in the school?"
]

        for (number, state) in enumerate(states):
            values = [str(number + 1),
                      str(state.school_id),
                      str(state.telephone),
                      str(state.date_of_visit.date()),
                      str(state.is_invalid)
            ]
            values = values + [answer for answer in state.answers[1:]]
            values = ",".join(values)
            lines.append(str(values))
                            
        for line in lines:
            csv.write(line+"\n")
