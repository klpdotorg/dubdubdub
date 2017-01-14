import time
import operator
from optparse import make_option
from datetime import datetime, timedelta

from django.conf import settings
from django.db import transaction
from django.db.models import Count
from django.contrib.auth.models import Group
from django.core.management.base import BaseCommand

from ivrs.models import State
from users.models import User
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

        bfc = Group.objects.get(name="BFC")
        crp = Group.objects.get(name="CRP")
        bfc_users = bfc.user_set.all()
        crp_users = crp.user_set.all()

        today = datetime.now().date()
        start_date = today - timedelta(days=int(days))
        states = State.objects.filter(
            date_of_visit__gte=start_date,
        )
        valid_states = states.filter(is_invalid=False)

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
        lines.extend(["\n"])


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
        lines.extend([columns])

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

        for district in districts:
            school_ids = district.schools().values_list('id', flat=True)
            smses = states.filter(school_id__in=school_ids)
            smses_received = smses.count()
            smses_from_bfc = smses.filter(user__in=bfc_users).count()
            smses_from_crp = smses.filter(user__in=crp_users).count()
            invalid_smses = smses.filter(is_invalid=True).count()
            invalid_smses_from_bfc = smses.filter(is_invalid=True, user__in=bfc_users).count()
            invalid_smses_from_crp = smses.filter(is_invalid=True, user__in=crp_users).count()
            schools_with_invalid_smses = smses.filter(is_invalid=True).order_by().distinct('school_id').count()

            values = [
                str(district.name),
                str(smses_received),
                str(smses_from_bfc),
                str(smses_from_crp),
                str(invalid_smses),
                str(invalid_smses_from_bfc),
                str(invalid_smses_from_crp),
                str(schools_with_invalid_smses),
            ]

            values = ",".join(values)
            lines.extend([values])


        lines.extend(["\n"])
        # Block Level performance
        columns = ("Block,"
                   "District,"
                   "Total SMS received,"
                   "No. SMS from BFC,"
                   "No. SMS from CRP,"
                   "Invalid SMS Count,"
                   "BFC invalid SMS count,"
                   "CRP invalid SMS count,"
                   "No. of unique schools with invalid SMS"
                   )
        lines.extend([columns])

        school_ids = State.objects.all().values_list('school_id', flat=True)
        block_ids = School.objects.filter(
            id__in=school_ids
        ).values_list(
            'admin3__parent', flat=True
        ).order_by(
        ).distinct(
            'admin3__parent'
        )
        blocks = Boundary.objects.filter(id__in=block_ids)

        for block in blocks:
            school_ids = block.schools().values_list('id', flat=True)
            smses = states.filter(school_id__in=school_ids)
            smses_received = smses.count()
            smses_from_bfc = smses.filter(user__in=bfc_users).count()
            smses_from_crp = smses.filter(user__in=crp_users).count()
            invalid_smses = smses.filter(is_invalid=True).count()
            invalid_smses_from_bfc = smses.filter(is_invalid=True, user__in=bfc_users).count()
            invalid_smses_from_crp = smses.filter(is_invalid=True, user__in=crp_users).count()
            schools_with_invalid_smses = smses.filter(is_invalid=True).order_by().distinct('school_id').count()

            values = [
                str(block.name),
                str(block.parent.name),
                str(smses_received),
                str(smses_from_bfc),
                str(smses_from_crp),
                str(invalid_smses),
                str(invalid_smses_from_bfc),
                str(invalid_smses_from_crp),
                str(schools_with_invalid_smses),
            ]

            values = ",".join(values)
            lines.extend([values])

        lines.extend(["\n"])


        # Top 5 valid SMS contributors:
        columns = ("Name,"
                   "Mobile number,"
                   "Districts,"
                   "Blocks,"
                   "Clusters,"
                   "Group,"
                   "SMS count,"
        )
        lines.extend([columns])

        users = User.objects.filter(
            state__in=valid_states
        ).annotate(sms_count=Count('state')).order_by('-sms_count')[:5]

        for user in users:
            name = user.get_full_name()
            mobile_number = user.mobile_no
            school_ids = user.state_set.filter(id__in=valid_states).values_list('school_id',flat=True)
            clusters = School.objects.filter(
                id__in=school_ids
            ).values_list(
                'admin3__name', flat=True
            ).order_by(
            ).distinct(
                'admin3__name'
            )
            blocks = School.objects.filter(
                id__in=school_ids
            ).values_list(
                'admin3__parent__name', flat=True
            ).order_by(
            ).distinct(
                'admin3__parent__name'
            )
            districts = School.objects.filter(
                id__in=school_ids
            ).values_list(
                'admin3__parent__parent__name', flat=True
            ).order_by(
            ).distinct(
                'admin3__parent__parent__name'
            )

            group = user.groups.get().name
            smses = states.filter(user=user, is_invalid=False).count()

            values = [
                str(name),
                str(mobile_number),
                str("-".join(districts)),
                str("-".join(blocks)),
                str("-".join(clusters)),
                str(group),
                str(smses),
            ]

            values = ",".join(values)
            lines.extend([values])

        lines.extend(["\n"])


        # Top 5 blocks with valid SMS
        columns = ("Block Name,"
                   "District Name,"
                   "Number of Valid SMS,"
        )
        lines.extend([columns])

        school_ids = valid_states.values_list('school_id', flat=True)
        block_ids = School.objects.filter(
            id__in=school_ids
        ).values_list(
            'admin3__parent', flat=True
        ).order_by(
        ).distinct(
            'admin3__parent'
        )
        blocks = Boundary.objects.filter(id__in=block_ids)
        block_sms_dict = {}
        for block in blocks:
            school_ids = block.schools().values_list('id', flat=True)
            smses = valid_states.filter(school_id__in=school_ids).count()
            block_sms_dict[block.id] = smses

        block_sms_list = sorted(block_sms_dict.items(), key=operator.itemgetter(1))
        for i in list(reversed(block_sms_list))[:5]:
            block = Boundary.objects.get(id=i[0])
            values = [
                str(block.name),
                str(block.parent.name),
                str(i[1]),
            ]

            values = ",".join(values)
            lines.extend([values])


        for line in lines:
            csv.write(line+"\n")

                            
