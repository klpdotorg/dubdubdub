from django.core.management.base import BaseCommand
from os.path import join, walk
from optparse import make_option
from schools.models import School, MeetingReport
from django.core.files import File
from datetime import datetime
from common.utils import Date


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
            #file_path = join(self.directory, dirname, fname)
            file_path = join(dirname, fname)
            if file_path.endswith('.pdf'):
                self.importPDF(file_path, fname)


    def importPDF(self, file_path, filename):
        filepath_split = file_path.split('/')
        print filepath_split
        
        filename_split = filename.rstrip('.pdf').split("_")
        school_id = filename_split[1]
        language = filepath_split[4] #6
        school = School.objects.get(pk=school_id)
        mr = MeetingReport()
        mr.school = school
        mr.language = language
        generated = Date()
        mr.generated_at = generated.get_datetime(filepath_split[2]+'-'+filepath_split[3]+'-1')
        #fil = open(file_path)
        #django_file = File(fil)
        #mr.pdf.save(file_path, django_file, save=True)
        mr.pdf = file_path. lstrip('media/')
        mr.save()


