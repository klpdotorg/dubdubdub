import time
from optparse import make_option
from datetime import datetime, timedelta

from django.conf import settings
from django.db import transaction
from django.core.management.base import BaseCommand

from ivrs.models import State
from schools.models import School, Boundary
from stories.models import Story, UserType, Questiongroup, Answer


class Command(BaseCommand):
    args = ""
    help = """Creates csv files for calls happened each day

    ./manage.py generategkacsv --duration=[monthly/weekly]"""

    option_list = BaseCommand.option_list + (
        make_option('--duration',
                    help='To specify whether it is a monthly or weekly csv'),
    )

    @transaction.atomic
    def handle(self, *args, **options):
        duration = options.get('duration', None)
        if not duration:
            raise Exception(
                "Please specify --duration as 'monthly' or 'weekly'"
            )

        if duration == 'weekly':
            days = 7
        elif duration == 'monthly':
            days = 30

        report_dir = settings.PROJECT_ROOT + "/gka-reports/"
        today = datetime.now().date()
        start_date = today - timedelta(days=int(days))
        states = State.objects.filter(
            date_of_visit__gte=start_date,
        )

        date = datetime.now().date().strftime("%d_%b_%Y")
        csv = open(report_dir+date+".csv", "w")

        lines = []

        # Overall count
        columns = "Total SMS received, No. of invalid SMS, % of invalid SMS, No. of schools with unique valid SMS"
        lines.extend([columns])

        total_sms_received = states.count()
        number_of_invalid_sms = states.filter(is_invalid=True).count()
        percentage_of_invalid_sms = (float(number_of_invalid_sms) / float(total_sms_received)) * 100.0
        number_of_schools_with_unique_valid_sms = states.filter(
            is_invalid=False).order_by().distinct('school_id').count()

        values = [
            str(total_sms_received),
            str(number_of_invalid_sms),
            str(percentage_of_invalid_sms),
            str(number_of_schools_with_unique_valid_sms)
        ]

        values = ",".join(values)
        lines.extend([values, "\n"])

        # Invalid SMS error classification
        columns = "Error type, Count"
        lines.extend([columns])

        errors = states.values_list('comments', flat=True).order_by().distinct('comments')
        for error in errors:
            number_of_errors = states.filter(comments=error).count()
            values = [
                str(error),
                str(number_of_errors)
            ]
            values = ",".join(values)
            lines.extend([values])


        # District Level performance
        columns = ("District,"
                   "Total SMS received,"
                   "No. SMS from BFC,"
                   "No. SMS from CRP,"
                   "Invalid SMS Count,"
                   "BFC invalid SMS count,"
                   "CRP invalid SMS count,"
                   "No. of unique schools with invalid SMS"
                   )
        school_ids = State.objects.all().values_list('school_id', flat=True)
        district_ids = School.objects.filter(
            id__in=school_ids
        ).values_list(
            'admin3__parent__parent', flat=True
        ).order_by(
        ).distinct(
            'admin3__parent__parent'
        )
        districts = Boundary.objects.filter(id__in=district_ids)
        import pdb; pdb.set_trace()
        print districts
        # school = School.objects.get(id=state.school_id)
        # district = school.admin3.parent.parent
        
        for line in lines:
            csv.write(line+"\n")



#         lines = ["Sl. No, School ID, District, Block, Cluster, Telephone, Date Of Visit, Invalid, \
# Was the school open?, \
# Class visited, \
# Was Math class happening on the day of your visit?, \
# Which chapter of the textbook was taught?, \
# Which Ganitha Kalika Andolana TLM was being used by teacher?, \
# Did you see children using the Ganitha Kalika Andolana TLM?, \
# Was group work happening in the class on the day of your visit?, \
# Were children using square line book during math class?, \
# Are all the toilets in the school functional?, \
# Does the school have a separate functional toilet for girls?, \
# Does the school have drinking water?, \
# Is a Mid Day Meal served in the school?"
# ]

        # for (number, state) in enumerate(states):
        #     try:
        #         school = School.objects.get(id=state.school_id)
        #         district = school.admin3.parent.parent.name.replace(',', '-')
        #         block = school.admin3.parent.name.replace(',', '-')
        #         cluster = school.admin3.name.replace(',', '-')
        #     except:
        #         district = block = cluster = None

        #     values = [str(number + 1),
        #               str(state.school_id),
        #               str(district),
        #               str(block),
        #               str(cluster),
        #               str(state.telephone),
        #               str(state.date_of_visit.date()),
        #               str(state.is_invalid)
        #     ]
        #     values = values + [answer for answer in state.answers[1:]]
        #     values = ",".join(values)
        #     lines.append(str(values))
                            
