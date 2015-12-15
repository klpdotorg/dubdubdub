from django.core.management.base import BaseCommand
import csv
from stories.models import Question, Questiongroup, QuestiongroupQuestions
from optparse import make_option

class Command(BaseCommand):
    args = "<path to file>"
    help = """Import Key and Display Text metadata for questions
                python manage.py import_question_metadata --file=<path/to/file.csv>
            """

    option_list = BaseCommand.option_list + (
        make_option('--file',
                    help='Path to the csv file'),
    )

    def handle(self, *args, **options):

        filename = options.get('file', None)
        if not filename:
            print "Please specify a filename with the --file argument"
            return
        reader = csv.reader(open(filename))
        i = 0
        for row in reader:
            if i == 0:
                i += 1
                continue
            source = row[0].strip()
            school_type = row[1].strip()
            version = int(row[2])
            sequence = int(row[3])
            question_text = row[4].strip()
            key = row[5].strip()
            new_display_text = row[7].strip()
            is_featured = row[9].strip()
            qg = Questiongroup.objects.filter(source__name=source, version=version)[0]
            qgq = QuestiongroupQuestions.objects.filter(sequence=sequence, questiongroup=qg,
                                                       question__school_type__name=school_type)[0]
            question = qgq.question
            print question.text
            if question.text.strip() != question_text:
                raise Exception("question text does not match. failing.")
            question.display_text = new_display_text
            question.key = key
            if not question.is_featured:
                if is_featured == 'Y':
                    print question.text
                    question.is_featured = True
                else:
                    question.is_featured = False
            question.save()

