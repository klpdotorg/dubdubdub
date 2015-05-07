from django.core.management.base import BaseCommand
from os.path import join, walk
from optparse import make_option
from schools.models import School, MeetingReport
from django.core.files import File


class Command(BaseCommand):
    help = 'Import Meeting report PDFs'
    args = "<FULL path to directory>"

    option_list = BaseCommand.option_list + (
        make_option('--dir',
                    help='FULL PATH to Directory holding PDFs'),
    )

    def handle(self, *args, **options):
        self.directory = options.get('dir', None)
        if not self.directory:
            print "Please specify full path to directory with the --dir argument"
            return
        walk(self.directory, self.processDir, None)

    def processDir(self, arg, dirname, fnames):
        for fname in fnames:
            #print fname
            file_path = join(self.directory, dirname, fname)
            if file_path.endswith('.pdf'):
                self.importPDF(file_path, fname)


    def importPDF(self, file_path, filename):
        filename_split = filename.split("_")
        school_id = filename_split[0]
        language = filename_split[2].split(".")[0]
        school = School.objects.get(pk=school_id)
        mr = MeetingReport()
        mr.school = school
        mr.language = language
        fil = open(file_path)
        django_file = File(fil)
        mr.pdf.save(filename, django_file, save=True)
        mr.save()


