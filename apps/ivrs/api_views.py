import os
import datetime

from rest_framework import status
from rest_framework.response import Response

from django.conf import settings
from django.utils import timezone

from .models import State
from .utils import get_question, save_answer

from schools.models import School
from common.views import KLPAPIView


PRI = "08039236431"
PRE = "08039510414"
GKA_DEV = "08039510185"
GKA_SMS = "08039514048"
GKA_SERVER = "08039591332"


class SMSView(KLPAPIView):
    def get(self, request):
        status_code = status.HTTP_200_OK

        date = request.QUERY_PARAMS.get('Date', None)
        data = request.QUERY_PARAMS.get('Body', None)
        ivrs_type = request.QUERY_PARAMS.get('To', None)
        telephone = request.QUERY_PARAMS.get('From', None)
        session_id = request.QUERY_PARAMS.get('SmsSid', None)

        state, created = State.objects.get_or_create(
            session_id=session_id
        )
        state.telephone = telephone
        state.date_of_visit = get_date(date)
        state.answers = []
        # Ignoring index 0 since question_numbers start from 1
        state.answers.append('IGNORED_INDEX')

        data = data.split(',')
        school_id = data.pop(0)

        # Checking if school_id has been entered and whether the
        # entered ID is valid.
        school_type = None
        if not school_id:
            status_code = status.HTTP_404_NOT_FOUND
        elif School.objects.filter(id=school_id.strip('"')).exists():
            state.school_id = school_id.strip('"')
            school_type = School.objects.filter(
                id=school_id.strip('"')
            ).values(
                'admin3__type__name'
            )[0]['admin3__type__name']
        else:
            status_code = status.HTTP_404_NOT_FOUND

        # Validating whether the entered school ID corresponds to the
        # correct school_type. Assigns the ivrs_type based on the call
        # number as well.
        if ivrs_type == GKA_SERVER or ivrs_type == GKA_DEV:
            if school_type != u'Primary School':
                status_code = status.HTTP_404_NOT_FOUND

            state.ivrs_type = 'gka-v3'
            for i in range(0,10): # Initializing answer slots 1 to 10 with NA
                state.answers.append('NA')
        elif ivrs_type == PRI:
            if school_type != u'Primary School':
                status_code = status.HTTP_404_NOT_FOUND

            state.ivrs_type = 'ivrs-pri'
            for i in range(0,6): # Initializing answer slots 1 to 6 with NA
                state.answers.append('NA')
        else: # ivrs_type == PRE
            if school_type != u'PreSchool':
                status_code = status.HTTP_404_NOT_FOUND

            state.ivrs_type = 'ivrs-pre'
            for i in range(0,6): # Initializing answer slots 1 to 6 with NA
                state.answers.append('NA')

        state.save()


# This view is on hold for now.
class DynamicResponse(KLPAPIView):
    def get(self, request):
        sound_file_paths = ""

        if settings.IVRS_VOICE_FILES_DIR:
            status_code = status.HTTP_200_OK

            digits = request.QUERY_PARAMS.get('digits', None)

            digits = digits.strip('"')
            path = settings.IVRS_VOICE_FILES_DIR
            path = os.path.join(path, '') # Adds a trailing slash if not present.

            for digit in digits:
                file_name = digit + ".wav\n"
                sound_file_paths += path + file_name
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response(
            sound_file_paths,
            status=status_code,
            content_type="text/plain"
        )


class CheckSchool(KLPAPIView):
    def get(self, request):
        status_code = status.HTTP_200_OK

        ivrs_type = request.QUERY_PARAMS.get('To', None)
        telephone = request.QUERY_PARAMS.get('From', None)
        date = request.QUERY_PARAMS.get('StartTime', None)
        school_id = request.QUERY_PARAMS.get('digits', None)
        session_id = request.QUERY_PARAMS.get('CallSid', None)

        state, created = State.objects.get_or_create(
            session_id=session_id
        )
        state.telephone = telephone
        state.date_of_visit = get_date(date)
        state.answers = []
        state.answers.append('IGNORED_INDEX') # Ignoring index 0 since question_numbers start from 1

        # Checking if school_id has been entered and whether the
        # entered ID is valid.
        school_type = None
        if not school_id:
            status_code = status.HTTP_404_NOT_FOUND
        elif School.objects.filter(id=school_id.strip('"')).exists():
            state.school_id = school_id.strip('"')
            school_type = School.objects.filter(
                id=school_id.strip('"')
            ).values(
                'admin3__type__name'
            )[0]['admin3__type__name']
        else:
            status_code = status.HTTP_404_NOT_FOUND

        # Validating whether the entered school ID corresponds to the
        # correct school_type. Assigns the ivrs_type based on the call
        # number as well.
        if ivrs_type == GKA_SERVER or ivrs_type == GKA_DEV:
            if school_type != u'Primary School':
                status_code = status.HTTP_404_NOT_FOUND

            state.ivrs_type = 'gka-v3'
            for i in range(0,10): # Initializing answer slots 1 to 10 with NA
                state.answers.append('NA')
        elif ivrs_type == PRI:
            if school_type != u'Primary School':
                status_code = status.HTTP_404_NOT_FOUND

            state.ivrs_type = 'ivrs-pri'
            for i in range(0,6): # Initializing answer slots 1 to 6 with NA
                state.answers.append('NA')
        else: # ivrs_type == PRE
            if school_type != u'PreSchool':
                status_code = status.HTTP_404_NOT_FOUND

            state.ivrs_type = 'ivrs-pre'
            for i in range(0,6): # Initializing answer slots 1 to 6 with NA
                state.answers.append('NA')

        state.save()

        return Response("", status=status_code)


class ReadSchool(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            school = School.objects.get(id=state.school_id)
            # Removes special characters from the school name. Apparently,
            # that was causing Exotel to break.
            school_name = ''.join(
                char for char in school.name if char.isalnum() or char.isspace()
            )
            data = "The ID you have entered is " + \
                   " ".join(str(school.id)) + \
                   " and school name is " + \
                   school_name
        else:
            status_code = status.HTTP_404_NOT_FOUND
            data = ''

        return Response(data, status=status_code, content_type="text/plain")


class VerifyAnswer(KLPAPIView):
    def get(self, request, question_number):
        ivrs_type = request.QUERY_PARAMS.get('To', None)
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            question_number = int(question_number)
            question = get_question(question_number, ivrs_type)
            response = request.QUERY_PARAMS.get('digits', None)

            if response:
                response = int(response.strip('"'))

                # Mapping integers to Yes/No.
                accepted_answers = {1: 'Yes', 2: 'No'}
                if question.question_type.name == 'checkbox' and response in accepted_answers:
                    if question_number == 1 and (ivrs_type == GKA_DEV or ivrs_type == GKA_SERVER):
                        # This special case is there for question 1 which clubs "Was the school
                        # open?" and "Class visited". Since "Class visited accepts answers from
                        # 1 tp 8, we can't cast "1" and "2" to "yes" and "no". The answer to
                        # whether the school was open or not is handled in the save_answer
                        # function within utils.py
                        response = response
                    else:
                        response = accepted_answers[response]

                # Save the answer.
                status_code = save_answer(
                    state, question_number, question, ivrs_type, response
                )

            else:
                status_code = status.HTTP_404_NOT_FOUND
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)

def get_date(date):
    date = datetime.datetime.strptime(
        date, '%Y-%m-%d %H:%M:%S'
    )
    date = timezone.make_aware(
        date, timezone.get_current_timezone()
    )
    return date
