import os

from rest_framework import status
from rest_framework.response import Response

from django.conf import settings

from .models import State, IncomingNumber
from .utils import (
    check_data_validity,
    check_school,
    check_user,
    get_date,
    get_message,
    get_question,
    populate_state,
    save_answer,
    verify_answer,
)

from schools.models import School
from common.views import KLPAPIView


class SMSView(KLPAPIView):
    def get(self, request):
        # In the SMS functionality of exotel, it expects a 200 response for all
        # its requests if it is to send the 'body' of your response as an sms
        # reply to the sender. Hence you will find places below where
        # status.HTTP_200_OK has been hardcoded in the response.
        content_type = "text/plain"

        parameters = {}
        parameters['date'] = request.QUERY_PARAMS.get('Date', None)
        parameters['ivrs_type'] = request.QUERY_PARAMS.get('To', None)
        parameters['raw_data'] = request.QUERY_PARAMS.get('Body', None)
        parameters['telephone'] = request.QUERY_PARAMS.get('From', None)
        parameters['session_id'] = request.QUERY_PARAMS.get('SmsSid', None)

        is_registered_user = check_user(request)

        processed_data, is_data_valid = check_data_validity(request)

        school_id = processed_data.pop(0)
        parameters['school_id'] = school_id

        state = populate_state(parameters)

        if not is_registered_user:
            message = get_message(
                is_registered_user=is_registered_user,
                telephone=parameters['telephone']
            )
            return Response(
                message,
                status=status.HTTP_200_OK,
                content_type=content_type
            )

        if not is_data_valid:
            message = get_message(
                valid=is_data_valid,
                data=parameters['raw_data']
            )
            return Response(
                message,
                status=status.HTTP_200_OK,
                content_type=content_type
            )

        status_code, message = check_school(school_id)
        if status_code != status.HTTP_200_OK:
            return Response(
                message,
                status=status.HTTP_200_OK,
                content_type=content_type
            )

        # Loop over the entire data array and try to validate and save
        # each answer. FIXME: Move this into a function.
        for question_number, response in enumerate(processed_data):
            # Blank data corresponds to NA and indicates that we should
            # skip the corresponding question.
            if response == '':
                continue
            else:
                # question_number starts from 0, and hence we need to add 1
                # to it in order to get the correct sequence of questions.
                # question_number corresponds to questiongroupquestions__sequence
                # while querying for the corresponding Question.
                state, status_code, message = verify_answer(
                    parameters['session_id'],
                    question_number+1,
                    response,
                    parameters['ivrs_type'],
                    original_data=parameters['raw_data']
                )
                if status_code != status.HTTP_200_OK:
                    # If we find any of the answers are corrupt, we return
                    # an error response.
                    return Response(
                        message,
                        status=status.HTTP_200_OK,
                        content_type=content_type
                    )
        else:
            message = get_message(
                valid=True,
                date=parameters['date'],
                data=parameters['raw_data']
            )

        return Response(
            message,
            status=status.HTTP_200_OK,
            content_type=content_type
        )


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
        parameters = {}
        parameters['ivrs_type'] = request.QUERY_PARAMS.get('To', None)
        parameters['date'] = request.QUERY_PARAMS.get('StartTime', None)
        parameters['telephone'] = request.QUERY_PARAMS.get('From', None)
        parameters['school_id'] = request.QUERY_PARAMS.get('digits', None)
        parameters['session_id'] = request.QUERY_PARAMS.get('CallSid', None)

        if parameters['school_id']:
            parameters['school_id'] = parameters['school_id'].strip('"')

        populate_state(parameters)
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
        response = request.QUERY_PARAMS.get('digits', None)

        state, status_code, message = verify_answer(
            session_id, question_number, response, ivrs_type,
        )

        return Response("", status=status_code)
