from django.core.management.base import BaseCommand

from stories.models import Answer, Question, QuestionType

class Command(BaseCommand):
    args = ""
    help = """Merge identical answers
    
    ./manage.py answermerge"""

    def handle(self, *args, **options):
        answer_mapping_dict = {
            'checkbox': {
                'Yes'     : ['YES', 'yes', 'Yes', 'on', '1', 'Available and functional', 
                             'Available but not used', 'Available and used'],
                'No'      : ['NO', 'no', 'No', '0', 'Not available', 
                             'Available but not functional'],
                'Unknown' : ['Unknown', 'Do Not Know', "",
                             'The 1st, 2nd & 3rd grade was combined into 1 class'],
                'numeric' : ['24', '04', '40', '3', '2', '5', '4', '7', '6', '9', '8', '11',
                             '10', '13', '12', '15', '14', '17', '16', '18', '30']
            },

            'radio'   : {
                'Yes'     : ['yes', 'Yes', 'YES'],
                'No'      : ['NO', 'No'],
                'Unknown' : ['Do Not Know'],
            },

            'numeric' : {
                'Unknown' : ['Other', 'Akshaya Patra',
                             'Not sure, may be some - that\'s why they combine lower classes'],
                '10'      : ['approximately 10'],
                '12'      : ['12-15']
            },
        }

        # Deleting duplicate questions without any answers. This is a special case.
        questions = Question.objects.filter(text__icontains='An All weather (pucca) building')
        for question in questions:
            if not question.answer_set.all().exists():
                question.delete()

        # Converting question_type of certain questions to numeric. Concluded the type after
        # Manually inspecting
        question_type = QuestionType.objects.get(name="numeric")
        questions = ['What was the total numbers of teachers present (including head master)?',
                     'How many classrooms had no teachers in the class?',
                     'How many functional class rooms (exclude rooms that are not used for conducting classes for whatever reason) does the school have?'
                 ]
        for question in questions:
            q = Question.objects.get(text__icontains=question)
            q.question_type = question_type
            q.save()

        # Start to merge answers
        answers = Answer.objects.all()
        answers_to_be_deleted = []
        for answer in answers:
            if answer.question.question_type.name == "numeric":
                for key in answer_mapping_dict['numeric']:
                    if answer.text in answer_mapping_dict['numeric'][key]:
                        answer.text = key
                        answer.save()
                        break
            elif answer.question.question_type.name == "checkbox":
                for key in answer_mapping_dict['checkbox']:
                    if answer.text in answer_mapping_dict['checkbox'][key]:
                        if key is 'numeric':
                            answers_to_be_deleted.append(answer)
                            break
                        else:
                            answer.text = key
                            answer.save()
                            break
            else:
                for key in answer_mapping_dict['radio']:
                    if answer.text in answer_mapping_dict['radio'][key]:
                        answer.text = key
                        answer.save()
                        break

        # This JSON represents the frequency of 'numeric' answers
        # that appeared for the type 'checbox' that are going to
        # be deleted now.
        # {
        # "24": 0, "10": 6, "13": 0, "12": 2,
        # "15": 2, "14": 1, "04": 0, "16": 0,
        # "11": 0, "18": 0, "30": 0, "40": 0,
        # "5": 8, "7": 1, "6": 4, "9": 2, "8": 1,
        # "17": 0, "3": 25, "2": 27, "4": 13,
        # }
        for answer in answers_to_be_deleted:
            answer.delete()
