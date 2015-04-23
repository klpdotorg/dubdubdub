from django.core.management.base import BaseCommand
import csv
from stories.models import Question, Questiongroup, QuestiongroupQuestions

class Command(BaseCommand):
    args = "filename to import from"
    help = """Import Key and Display Text metadata for questions
                python manage.py import_question_metadata <path/to/file.csv>
            """

    def handle(self, *args, **options):
        filename = args[0]
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
            qg = Questiongroup.objects.filter(source__name=source, version=version)[0]
            qgq = QuestiongroupQuestions.objects.filter(sequence=sequence, questiongroup=qg,
                                                       question__school_type__name=school_type)[0]
            question = qgq.question
            print question.text
            print question_text
            if question.text.strip() != question_text:
                raise Exception("question text does not match. failing.")
            question.display_text = new_display_text
            question.key = key
            question.save()
            

