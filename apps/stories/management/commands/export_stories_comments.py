from django.core.management.base import BaseCommand
from stories.models import Story
from optparse import make_option
import codecs

class Command(BaseCommand):
    args = "<path to output file>"
    help = """Dump out all comments text for Web SYS Stories
                python manage.py export_stories_comments --file=<path/to/file.csv>
            """

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to output file'),
    )

    def handle(self, *args, **options):

        filename = options.get('file', None)
        if not filename:
            print "Please specify a filename with the --file argument"
            return
        out = codecs.open(filename, mode="w", encoding="utf-8")
        stories_qset = Story.objects.filter(group__source__name='web', is_verified=True)
        stories_qset = stories_qset.exclude(comments=None).exclude(comments='')
        texts = [s.comments for s in stories_qset]
        joined_texts = "\n\n".join(texts)
        out.write(joined_texts)
        out.close()

