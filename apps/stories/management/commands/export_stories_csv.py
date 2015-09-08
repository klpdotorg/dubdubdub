from django.core.management.base import BaseCommand
from stories.models import Story
from optparse import make_option
import codecs
import csv

class Command(BaseCommand):
    args = ""
    help = """Dump out all comments text for Web SYS Stories
                python manage.py export_stories_comments --file=<path/to/file.csv> --admin2=587 --from=2015-01-01 --to=2015-08-15
                
                Use only one of 'admin1', 'admin2', 'admin3' or 'school'
                
                Specify from and to dates as YYYY-MM-DD
            """

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to output file'),
        make_option('--admin1',
                    help='Admin 1 id to filter by'),
        make_option('--admin2',
                    help='Admin 2 id to filter by'),
        make_option('--admin3',
                    help='Admin 3 id to filter by'),
        make_option('--school',
                    help='School id to filter by'),
        make_option('--from',
                    help='From date to filter by'),
        make_option('--to',
                    help='To date to filter by'),
        make_option('--source',
                    help='Source to filter by, eg. web, ivrs, etc.'),
    )

    def handle(self, *args, **options):
        '''
        TODO: make querying more efficient using select_related or so
        '''
        filename = options.get('file', None)
        if not filename:
            print "Please specify a filename with the --file argument"
            return

        out = codecs.open(filename, mode="w", encoding="utf-8")

        key, val = self.get_query(options)
        stories_qset = Story.objects.all()

        print key, val

        if key:
            stories_qset = stories_qset.filter(**{key: val})

        if options.get('from', None):
            from_date = self.get_date(options.get('from'))
            stories_qset = stories_qset.filter(date__gte=from_date)
        if options.get('to', None):
            to_date = self.get_date(options.get('to'))
            stories_qset = stories_qset.filter(date__lte=to_date)

        if options.get('source', None):
            source_name = options.get('source')
            stories_qset = stories_qset.filter(group__source__name=source_name)

        if not stories_qset.exists():
            print "No stories found matching query"
            return

        fields = [
            "story_id",
            "date",
            "name",
            "email",
            "phone",
            "school",
            "admin1",
            "admin2",
            "admin3"
        ]
        writer = csv.writer(out)
        writer.writerow(fields)
        print "writing file"
        for story in stories_qset:
            row = self.get_row(story)
            writer.writerow(row)
        out.close()
        print "done"

    def get_row(self, story):
        return [
            story.id,
            story.date_of_visit.strftime("%Y-%m-%d"),
            story.name,
            story.email,
            story.telephone,
            story.school.name,
            story.school.schooldetails.admin1.name,
            story.school.schooldetails.admin2.name,
            story.school.schooldetails.admin3.name,
        ]


    def get_query(self, options):
        query_string_fragment = "school__schooldetails__"
        key = None
        if options.get('admin1', None):
            key = 'admin1'
            val = options.get('admin1')
        if options.get('admin2', None):
            key = 'admin2'
            val = options.get('admin2')
        if options.get('admmin3', None):
            key = 'admin3'
            val = options.get('admin3')
        if key:
            return (query_string_fragment + key, val,)
        if options.get('school', None):
            key = 'school'
            val = options.get('school')
            return (key, val,)
        return (None, None,)

    def get_date(self, date_string):
        return datetime.datetime.strptime(date_string, "%Y-%m-%d")

