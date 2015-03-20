from django.core.management.base import BaseCommand

from stories.models import Answer, QuestionType

class Command(BaseCommand):
    args = ""
    help = """Merge identical answers
    
    ./manage.py answermerge"""

    def handle(self, *args, **options):
        map_dict = {
            'checkbox': {
                'Yes'     : ['YES', 'yes', 'Yes', 'on', '1', 'Available and functional', 
                             'Available but not used', 'Available and used'],
                'No'      : ['NO', 'no', 'No', '0', 'Not available', 
                             'Available but not functional'],
                'Unknown' : ['Unknown', 'Do Not Know', 'Other', 
                             'Not sure, may be some - that\'s why they combine lower classes',
                             'Akshaya Patra', 'approximately 10',
                             'The 1st, 2nd & 3rd grade was combined into 1 class', '12-15'],
                'numeric' : ['24', '04', '40', '3', '2', '5', '4', '7', '6', '9', '8', '11',
                             '10', '13', '12', '15', '14', '17', '16', '18', '30']
                },
            'radio'   : {
                'Yes'     : ['yes', 'Yes', 'YES'],
                'No'      : ['NO', 'No'],
                'Unknown' : ['Do Not Know'],
                },
        }
        
        answers = Answer.objects.all()
        for answer in answers:
            for key in map_dict['checkbox']:
                if answer.text in map_dict['checkbox'][key]:
                    if key is 'numeric':
                        answer.question.question_type = QuestionType.objects.get(name="numeric")
                    else:
                        answer.text = key
                    answer.save()
                    break
            for key in map_dict['radio']:
                if answer.text in map_dict['radio'][key]:
                    answer.text = key
                    answer.save()
                    break
