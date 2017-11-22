import sys
import operator
from optparse import make_option
from datetime import datetime, timedelta

from django.db import transaction
from django.conf import settings
from django.db.models import Count
from django.contrib.auth.models import Group
from django.core.management.base import BaseCommand

from common.utils import post_to_slack, Date
from stories.models import Story, Questiongroup, Source
from users.models import User

class Command(BaseCommand):
    args = ""
    help = """Posts the status of ILP Konnect to Slack.
    ./manage.py ilpkonnectstatus --reportdate=YYYY-MM-DD"""
    option_list = BaseCommand.option_list + (
        make_option('--reportdate',
                    help='report date'), )

    def get_reportdate(self, report_date):
        date = Date()
        sane = date.check_date_sanity(report_date)
        if not sane:
            print """
            Error:
            Wrong --from format. Expected YYYY-MM-DD
            """
            print self.help
            return
        else:
            report_date = date.get_datetime(report_date)
        return (report_date)

    @transaction.atomic
    def handle(self, *args, **options):
        report_date = options.get('reportdate', None)
        if not report_date:
            print "Please specify report date"
            sys.exit()
        report_date = self.get_reportdate(report_date)
        print report_date
        stories = Story.objects.filter(created_at__gte =report_date)
        survey_stories = stories.filter(group__source__name='mobile')
        survey_count = survey_stories.count()
        survey_devices = survey_stories.aggregate(Count('telephone', distinct = True))['telephone__count']
        survey_schools = survey_stories.aggregate(Count('school_id', distinct = True))['school_id__count']
        print 'survey_count: ',survey_count
        print 'devices_count: ',survey_devices
        print 'school_count: ',survey_schools
        
        user_types = ['CRP', 'BFC']
        konnect_stories = stories.filter(group__source__name='konnectsms')
        konnect_count = konnect_stories.count()
        konnect_devices = konnect_stories.aggregate(Count('telephone', distinct = True))['telephone__count']
        CRP_count = konnect_stories.filter(user__groups__name = 'CRP').count()  
        BFC_count = konnect_stories.filter(user__groups__name = 'BFC').count()
        other_count = konnect_stories.exclude(user__groups__name__in = user_types).count()
        print 'Konnect_count:',konnect_count 
        print 'konnect_devices_count:',konnect_devices  
        print 'CRPcount:',CRP_count  
        print 'BFCcount:',BFC_count 
        print 'othercount:',other_count 

        author = 'ILP Konnect'
        emoji = ':memo:'
        try:
            post_to_slack(
                channel='#klp',
                author=author,
                message='Community Survey: %s Schools, %s Devices and %s Surveys' %(survey_schools, survey_devices, survey_count),
                emoji=emoji,
            )
        except:
            pass

        try:
            post_to_slack(
                channel='#klp',
                author=author,
                message='GKA Monitoring: %s Devices and %s Surveys - %s by CRP, %s by BFC and %s by others' %(konnect_devices, konnect_count, CRP_count, BFC_count, other_count ),
                emoji=emoji,
            )
        except:
            pass
