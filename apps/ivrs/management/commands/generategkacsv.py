import time
import operator
from optparse import make_option
from datetime import datetime, timedelta

from django.conf import settings
from django.db import transaction
from django.db.models import Count
from django.contrib.auth.models import Group
from django.core.mail import EmailMultiAlternatives
from django.core.management.base import BaseCommand

from ivrs.models import State
from users.models import User
from schools.models import School, Boundary
from common.utils import send_attachment, Date
from stories.models import Story, UserType, Questiongroup, Answer

OVERALL_COLUMNS = (
    "Total SMS received, "
    "No. of invalid SMS, "
    "% of invalid SMS, "
    "No. of schools with unique valid SMS, "
    "No. valid SMS received from BFC, "
    "No. valid SMS received from BRC, "
    "No. valid SMS received from BRP, "
    "No. valid SMS received from CRP, "
    "No. valid SMS received from DDPI, "
    "No. valid SMS received from DIET, "
    "No. valid SMS received from EO, "
    "No. valid SMS received from EV, "
    "No. valid SMS received from HM "
)

INVALID_COLUMNS = (
    "Error type, "
    "Count, "
    "Numbers "
)

DISTRICT_COLUMNS = (
    "District,"
    "Total SMS received, "
    "Invalid SMS Count, "
    "No. of unique schools with invalid SMS, "
    
    "No. SMS from BFC, "
    "No. SMS from BRC, "
    "No. SMS from BRP, "
    "No. SMS from CRP, "
    "No. SMS from DDPI, "
    "No. SMS from DIET, "
    "No. SMS from EO, "
    "No. SMS from EV, "
    "No. SMS from HM, "
    
    "No. invalid SMS from BFC, "
    "No. invalid SMS from BRC, "
    "No. invalid SMS from BRP, "
    "No. invalid SMS from CRP, "
    "No. invalid SMS from DDPI, "
    "No. invalid SMS from DIET, "
    "No. invalid SMS from EO, "
    "No. invalid SMS from EV, "
    "No. invalid SMS from HM "
)

BLOCK_COLUMNS = (
    "Block,"
    "District,"
    "Total SMS received,"
    "Invalid SMS Count,"
    "No. of unique schools with invalid SMS"

    "No. SMS from BFC, "
    "No. SMS from BRC, "
    "No. SMS from BRP, "
    "No. SMS from CRP, "
    "No. SMS from DDPI, "
    "No. SMS from DIET, "
    "No. SMS from EO, "
    "No. SMS from EV, "
    "No. SMS from HM, "

    "No. invalid SMS from BFC, "
    "No. invalid SMS from BRC, "
    "No. invalid SMS from BRP, "
    "No. invalid SMS from CRP, "
    "No. invalid SMS from DDPI, "
    "No. invalid SMS from DIET, "
    "No. invalid SMS from EO, "
    "No. invalid SMS from EV, "
    "No. invalid SMS from HM "
)

TOP_5_VALID_SMS_CONTRIB_COLUMNS = (
    "Name,"
    "Mobile number,"
    "Districts,"
    "Blocks,"
    "Clusters,"
    "Group,"
    "Valid SMS count,"
    "SMS count"
)

TOP_5_VALID_SMS_BLOCKS_COLUMNS = (
    "Block Name,"
    "District Name,"
    "Number of Valid SMS,"
)

GROUP_ERROR_REPORT_COLUMNS = (
    "Group,"
    "Name,"
    "Telephone,"
    "District,"
    "Block,"
    "Cluster,"
    "SMSes sent,"
    "Number of Invalid SMS,"
    "Top 3 error classification with counts,"
    "Number of schools with SMS,"
    "No. of unique schools with SMS"
)

EXCLUDED_DISTRICTS = [
     'bangalore',
     'bangalore u south',
     'bengaluru u south',
     'mysore',
     'mysuru',
     'kolar',
     'belgaum',
     'bangalore u north',
     'bengaluru u north',
     'ramnagara',
     'ramanagara',
]

# EXCLUDED_DISTRICT_IDS = [431, 8877, 8878, 444, 413, 421, 419, 439, 9540, 9541]
# The code is modified to get IDs from the database based on the district names (rather than hardcoding ids here).

# EXCLUDED_BLOCKS = [
#     'hunagund',
#     'magadi',
#     'ramanagara',
#     'kanakapura',
#     'kudligi',
#     'kollegal',
#     'south-1',
#     'south-3',
#     'north-1',
#     'north-2',
#     'north-4',
#     'north-3',
#     'mysore south',
#     'koppal',
#     'bangarapete',
#     'bangalore south(banashankari)',
#     'sumangali seva ashrama',
#     'bangalore north (yelahanka)',
#     'belgaum city',
#     'badami',
#     'bagalkot',
#     'bilagi',
#     'jamakhandi',
#     'mudhol',
#     'yelandur',
#     'dharwad',
#     'kundagol'
# ]

# EXCLUDED_BLOCK_IDS = [8882, 8886, 573, 464, 502, 465, 466, 493, 530, 505, 650, 467, 8889, 651, 626, 5999, 653, 462, 457, 463, 625, 8883, 8884, 8879, 8881, 8776, 8774, 8779]

class Command(BaseCommand):
    args = ""
    help = """Creates csv files for calls happened each day

    ./manage.py generategkacsv [--duration=monthly/weekly/daily] [--from=YYYY-MM-DD] [--to=YYYY-MM-DD] [--fc_report=True/False] --emails=a@b.com,c@d.com"""

    option_list = BaseCommand.option_list + (
        make_option('--from',
                    help='Start date'),
        make_option('--to',
                    help='End date'),
        make_option('--duration',
                    help='To specify whether it is a monthly or weekly csv'),
        make_option('--emails',
                    help='Comma separated list of email ids'),
        make_option('--fc_report',
                    help='Whether to generate BFC and CRP reports'),
    )

    def get_emails(self, emails):
        if not emails:
            raise Exception(
                "Please specify --emails as a list of comma separated emails"
            )
        emails = emails.split(",")
        return emails

    def get_dates(self, duration, start_date, end_date):
        today = datetime.now()
        if duration:
            if duration == 'weekly':
                days = 7
            elif duration == 'monthly':
                days = 30
            else: #daily
                days = 1
            start_date = today - timedelta(days=int(days))
            end_date = today

        elif (start_date and end_date):
            date = Date()
            sane = date.check_date_sanity(start_date)
            if not sane:
                print """
                Error:
                Wrong --from format. Expected YYYY-MM-DD
                """
                print self.help
                return
            else:
                start_date = date.get_datetime(start_date)

            sane = date.check_date_sanity(end_date)
            if not sane:
                print """
                Error:
                Wrong --to format. Expected YYYY-MM-DD
                """
                print self.help
                return
            else:
                end_date = date.get_datetime(end_date)
        else:
            raise Exception(
                "Please specify --duration as 'monthly' or 'weekly' OR --from and --to"
            )

        return (start_date, end_date)

    def get_overall_count(self, states, valid_states, groups):
        total_sms_received = states.count()
        number_of_invalid_sms = states.filter(is_invalid=True).count()
        if total_sms_received:
            percentage_of_invalid_sms = (float(number_of_invalid_sms) / float(total_sms_received)) * 100.0
        else:
            percentage_of_invalid_sms = 0
        number_of_schools_with_unique_valid_sms = states.filter(
            is_invalid=False).order_by().distinct('school_id').count()
        valid_sms_counts = [
            str(valid_states.filter(user__in=group.user_set.all()).count()) for group in groups
        ]

        values = [
            str(total_sms_received),
            str(number_of_invalid_sms),
            str(percentage_of_invalid_sms),
            str(number_of_schools_with_unique_valid_sms)
        ]
        values.extend(valid_sms_counts)
        return values

    def get_error_count(self, states):
        error_states = states.filter(is_invalid=True)
        errors_dict = {}
        for error_state in error_states:
            error = error_state.comments
            # Let's make certain errors more concise. Refer to 'get_message'
            # in utils.py for all possible messages.
            if error:
                if 'Expected' in error:
                    error = 'Formatting error'
                if 'registered' in error:
                    error = 'Not registered'
                if 'que.no' in error:
                    error = 'Entry error for a specific question'
                if 'School' in error:
                    error = 'School ID error'
                if 'Logical' in error:
                    error = 'Logical error'
                if 'accepted' in error:
                    # We have to do this because all State are by default
                    # invalid when created. Since we only process SMSes at
                    # 8.30PM in the night, the SMSes that came in that day
                    # morning will show as invalid.
                    continue
            if error in errors_dict:
                errors_dict[error]['count'] += 1
                errors_dict[error]['numbers'].append(error_state.telephone)
            else:
                errors_dict[error] = {}
                errors_dict[error]['count'] = 1
                errors_dict[error]['numbers'] = [error_state.telephone]

        return errors_dict

    def get_list_of_boundary_values(self, boundaries, states, groups, boundary_type=None):
        list_of_values = []

        boundary_dict = {}
        for boundary in boundaries:
            school_ids = boundary.schools().values_list('id', flat=True)
            smses = states.filter(school_id__in=school_ids)
            smses_received = smses.count()
            boundary_dict[boundary.id] = smses_received
        boundary_dict_list = sorted(boundary_dict.items(), key=operator.itemgetter(1), reverse=True)

        for boundary_id, smses_count in boundary_dict_list:
            boundary = Boundary.objects.get(id=boundary_id)
            school_ids = boundary.schools().values_list('id', flat=True)
            smses = states.filter(school_id__in=school_ids)
            smses_received = smses.count()
            invalid_smses = smses.filter(is_invalid=True).count()
            schools_with_invalid_smses = smses.filter(is_invalid=True).order_by().distinct('school_id').count()
            sms_counts = [
                str(smses.filter(user__in=group.user_set.all()).count()) for group in groups
            ]
            invalid_sms_counts = [
                str(smses.filter(is_invalid=True, user__in=group.user_set.all()).count()) for group in groups
            ]

            if boundary_type == "district":
                values = [
                    str(boundary.name),
                    str(smses_received),
                    str(invalid_smses),
                    str(schools_with_invalid_smses),
                ]
            else:
                values = [
                    str(boundary.name),
                    str(boundary.parent.name),
                    str(smses_received),
                    str(invalid_smses),
                    str(schools_with_invalid_smses),
                ]

            values.extend(sms_counts)
            values.extend(invalid_sms_counts)

            values = ",".join(values)
            list_of_values.append([values])
        return list_of_values

    def get_district_count(self, states, groups):
        school_ids = State.objects.all().values_list('school_id', flat=True)
        district_ids = School.objects.filter(
            id__in=school_ids
        ).values_list(
            'admin3__parent__parent', flat=True
        ).order_by(
        ).distinct(
            'admin3__parent__parent'
        )
        #Get ids of excluded districts and exclude from the queryset
        excluded_district_ids = Boundary.objects.filter(name__in=EXCLUDED_DISTRICTS).values_list('id', flat=True)
        boundaries = Boundary.objects.filter(id__in=district_ids).exclude(id__in=excluded_district_ids)

        return self.get_list_of_boundary_values(
            boundaries, states, groups, boundary_type="district"
        )

    def get_block_count(self, states, groups):
        school_ids = State.objects.all().values_list('school_id', flat=True)
        block_ids = School.objects.filter(
            id__in=school_ids
        ).values_list(
            'admin3__parent', flat=True
        ).order_by(
        ).distinct(
            'admin3__parent'
        )
        boundaries = Boundary.objects.filter(id__in=block_ids)#.exclude(id__in=EXCLUDED_BLOCK_IDS)
    
        return self.get_list_of_boundary_values(
            boundaries, states, groups, boundary_type="block"
        )

    def get_top_5_users(self, states, valid_states):
        list_of_values = []
        
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

            try:
                group = user.groups.get().name
            except:
                group = ''

            valid_smses = states.filter(user=user, is_invalid=False).count()
            total_smses = states.filter(user=user).count()

            values = [
                str(name),
                str(mobile_number),
                str("-".join(districts)),
                str("-".join(blocks)),
                str("-".join(clusters)),
                str(group),
                str(valid_smses),
                str(total_smses)
            ]

            values = ",".join(values)
            list_of_values.append([values])

        return list_of_values

    def get_top_5_blocks(self, valid_states):
        list_of_values = []

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
            list_of_values.append([values])

        return list_of_values

    def get_group_error_report(self, group, states, valid_states):
        list_of_values = []

        user_dict = {}
        for user in group.user_set.filter(state__in=states):
            user_smses_count = user.state_set.filter(id__in=states).count()
            user_dict[user.id] = user_smses_count
        user_dict_list = sorted(user_dict.items(), key=operator.itemgetter(1), reverse=True)

        for user_id, user_smses_count in user_dict_list:
            group_name = group.name
            user = User.objects.get(id=user_id)
            user_smses = user.state_set.filter(id__in=states)
            name = user.get_full_name()
            telephone = user.mobile_no
            school_ids = user_smses.values_list('school_id',flat=True)
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
            smses_sent = user_smses.count()
            invalid_smses_count = user_smses.filter(is_invalid=True).count()
            errors = user_smses.filter(is_invalid=True).values_list('comments', flat=True)
            errors_dict = {}
            for error in errors:
                if error:
                    if 'Expected' in error:
                        error = 'Formatting error'
                    if 'registered' in error:
                        error = 'Not registered'
                    if 'que.no' in error:
                        error = 'Entry error for a specific question'
                    if 'School' in error:
                        error = 'School ID error'
                    if 'Logical' in error:
                        error = 'Logical error'
                    if 'accepted' in error:
                        # We have to do this because all State are by default
                        # invalid when created. Since we only process SMSes at
                        # 8.30PM in the night, the SMSes that came in that day
                        # morning will show as invalid.
                        continue
                    if error in errors_dict:
                        errors_dict[error] += 1
                    else:
                        errors_dict[error] = 1
            errors_dict = sorted(errors_dict.items(), key=operator.itemgetter(1))
            top_3_errors = list((reversed(errors_dict)))[:3]
            schools_with_sms = user_smses.values_list('school_id',flat=True).count()
            unique_schools_with_sms = user_smses.values_list('school_id',flat=True).order_by().distinct('school_id').count()
            values = [
                str(group_name),
                str(name),
                str(telephone),
                str("-".join(districts)),
                str("-".join(blocks)),
                str("-".join(clusters)),
                str(smses_sent),
                str(invalid_smses_count),
                str(top_3_errors).replace(',', '-'),
                str(schools_with_sms),
                str(unique_schools_with_sms)
            ]
            
            values = ",".join(values)
            list_of_values.append([values])

        return list_of_values

    @transaction.atomic
    def handle(self, *args, **options):
        duration = options.get('duration', None)
        start_date = options.get('from', None)
        end_date = options.get('to', None)
        emails = options.get('emails', None)
        fc_report = options.get('fc_report', None)

        start_date, end_date = self.get_dates(duration, start_date, end_date)
        emails = self.get_emails(emails)
        
        report_dir = settings.PROJECT_ROOT + "/gka-reports/"

        groups = Group.objects.all().order_by('name')        
        states = State.objects.filter(
            date_of_visit__gte=start_date,
            date_of_visit__lte=end_date
        )
        valid_states = states.filter(is_invalid=False)

        lines = []

        # Overall count
        heading = "OVERALL COUNT"
        lines.extend([heading, "\n"])
        lines.extend([OVERALL_COLUMNS])
        values = self.get_overall_count(states, valid_states, groups)
        values = ",".join(values)
        lines.extend([values, "\n"])
        #--------------

        # Invalid SMS error classification
        heading = "INVALID SMS ERROR CLASSIFICATION"
        lines.extend([heading, "\n"])
        lines.extend([INVALID_COLUMNS])
        errors_dict = self.get_error_count(states)
        for error in errors_dict:
            values = [
                str(error),
                str(errors_dict[error]['count']),
                str("-".join(set(errors_dict[error]['numbers'])))
            ]
            values = ",".join(values)
            lines.extend([values])
        lines.extend(["\n"])
        #--------------

        # District Level performance
        heading = "DISTRICT LEVEL PERFORMANCE"
        lines.extend([heading, "\n"])
        lines.extend([DISTRICT_COLUMNS])
        list_of_values = self.get_district_count(states, groups)
        for values in list_of_values:
            lines.extend(values)
        lines.extend(["\n"])
        #--------------
        
        # Block Level performance
        heading = "BLOCK LEVEL PERFORMANCE"
        lines.extend([heading, "\n"])
        lines.extend([BLOCK_COLUMNS])
        list_of_values = self.get_block_count(states, groups)
        for values in list_of_values:
            lines.extend(values)
        lines.extend(["\n"])
        #--------------

        # Top 5 valid SMS contributors:
        heading = "TOP 5 VALID SMS CONTRIBUTORS"
        lines.extend([heading, "\n"])
        lines.extend([TOP_5_VALID_SMS_CONTRIB_COLUMNS])
        list_of_values = self.get_top_5_users(states, valid_states)
        for values in list_of_values:
            lines.extend(values)
        lines.extend(["\n"])
        #--------------

        # Top 5 blocks with valid SMS
        heading = "TOP 5 BLOCKS WITH VALID SMS"
        lines.extend([heading, "\n"])
        lines.extend([TOP_5_VALID_SMS_BLOCKS_COLUMNS])
        list_of_values = self.get_top_5_blocks(valid_states)
        for values in list_of_values:
            lines.extend(values)
        lines.extend(["\n"])
        #--------------

        # ERROR REPORTS FOR EACH GROUP
        if fc_report == 'True':
            for group in groups:
                heading = group.name + " ERROR REPORT"
                lines.extend([heading, "\n"])
                lines.extend([GROUP_ERROR_REPORT_COLUMNS])
                list_of_values = self.get_group_error_report(group, states, valid_states)
                for values in list_of_values:
                    lines.extend(values)
                lines.extend(["\n"])
        #-------------

        today = datetime.now().date()
        csv_file = report_dir + today.strftime("%d_%b_%Y") + '.csv'
        csv = open(csv_file, "w")

        for line in lines:
            csv.write(line+"\n")

        csv.flush()
        csv.close()

        date_range = start_date.strftime("%d/%m/%Y") + " to " + today.strftime("%d/%m/%Y")
        subject = 'GKA SMS Report for '+ date_range
        from_email = settings.EMAIL_DEFAULT_FROM
        to_emails = emails
        msg = EmailMultiAlternatives(subject, "Please view attachment", from_email, to_emails)
        msg.attach_alternative("<b>Please View attachement</b>", "text/html")
        msg.attach_file(csv_file)
        msg.send()

                            
