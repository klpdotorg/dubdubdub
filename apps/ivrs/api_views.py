import os

from rest_framework import status
from rest_framework.response import Response

from django.conf import settings

from .models import State, IncomingNumber
from .utils import (
    cast_answer,
    get_message,
    get_question,
    is_answer_accepted,
    is_data_valid,
    is_logically_correct,
    is_school_exists,
    is_school_primary,
    is_user_registered,
    populate_state,
    populate_answers_list,
    process_data,
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
        if parameters['telephone'] != None:
                parameters['telephone'] = parameters['telephone'][1:] # Strip 0

        processed_data = process_data(parameters['raw_data'])
        incoming_number = IncomingNumber.objects.get(number=parameters['ivrs_type'])
        school_id = processed_data.pop(0)
        answers = populate_answers_list(incoming_number)
        parameters['school_id'] = school_id

        is_invalid = True

	if parameters['telephone'] == None:
            message = get_message(parameters, is_user_registered=False)

        elif not is_user_registered(parameters['telephone']):
            message = get_message(parameters, is_user_registered=False)

        elif not is_data_valid(processed_data):
            message = get_message(parameters, is_data_valid=False)

        elif not is_logically_correct(processed_data):
            message = get_message(parameters, is_logically_correct=False)
        
        elif not school_id.isdigit():
           message = get_message(parameters, is_school_id_valid=False)

        elif not is_school_exists(school_id):
            message = get_message(parameters, is_school_id_valid=False)

        # Since we are working only with primary schools. Deprecate if
        # preschools come into picture.
        elif not is_school_primary(school_id):
            message = get_message(parameters, is_school_primary=False)

        else:
            for question_number, answer in enumerate(processed_data):
                # Add 1 to question_number since it starts from 0.
                q_no = question_number + 1
                question = get_question(q_no, incoming_number.qg_type.questiongroup)
                if not is_answer_accepted(question, answer):
                    # If we find any of the answers are corrupt, we return an error response.
                    message = get_message(parameters, error_question_number=q_no)
                    break
                else:
                    answer = cast_answer(question, answer)
                answers[q_no] = answer
            else:
                is_invalid = False
                message = get_message(parameters, is_data_valid=True)

        state = populate_state(parameters, message, answers, is_invalid=is_invalid)

        return Response(
            message,
            status=status.HTTP_200_OK,
            content_type=content_type
        )


# This view is on hold for now.
# class DynamicResponse(KLPAPIView):
#     def get(self, request):
#         sound_file_paths = ""

#         if settings.IVRS_VOICE_FILES_DIR:
#             status_code = status.HTTP_200_OK

#             digits = request.QUERY_PARAMS.get('digits', None)

#             digits = digits.strip('"')
#             path = settings.IVRS_VOICE_FILES_DIR
#             path = os.path.join(path, '') # Adds a trailing slash if not present.

#             for digit in digits:
#                 file_name = digit + ".wav\n"
#                 sound_file_paths += path + file_name
#         else:
#             status_code = status.HTTP_404_NOT_FOUND

#         return Response(
#             sound_file_paths,
#             status=status_code,
#             content_type="text/plain"
#         )


# class CheckSchool(KLPAPIView):
#     def get(self, request):
#         status_code = status.HTTP_200_OK
#         parameters = {}
#         parameters['ivrs_type'] = request.QUERY_PARAMS.get('To', None)
#         parameters['date'] = request.QUERY_PARAMS.get('StartTime', None)
#         parameters['telephone'] = request.QUERY_PARAMS.get('From', None)
#         parameters['school_id'] = request.QUERY_PARAMS.get('digits', None)
#         parameters['session_id'] = request.QUERY_PARAMS.get('CallSid', None)

#         if parameters['school_id']:
#             parameters['school_id'] = parameters['school_id'].strip('"')

#         populate_state(parameters)
#         return Response("", status=status_code)


# class ReadSchool(KLPAPIView):
#     def get(self, request):
#         session_id = request.QUERY_PARAMS.get('CallSid', None)
#         if State.objects.filter(session_id=session_id).exists():
#             state = State.objects.get(session_id=session_id)

#             status_code = status.HTTP_200_OK
#             school = School.objects.get(id=state.school_id)
#             # Removes special characters from the school name. Apparently,
#             # that was causing Exotel to break.
#             school_name = ''.join(
#                 char for char in school.name if char.isalnum() or char.isspace()
#             )
#             data = "The ID you have entered is " + \
#                    " ".join(str(school.id)) + \
#                    " and school name is " + \
#                    school_name
#         else:
#             status_code = status.HTTP_404_NOT_FOUND
#             data = ''

#         return Response(data, status=status_code, content_type="text/plain")


# class VerifyAnswer(KLPAPIView):
#     def get(self, request, question_number):
#         ivrs_type = request.QUERY_PARAMS.get('To', None)
#         session_id = request.QUERY_PARAMS.get('CallSid', None)
#         response = request.QUERY_PARAMS.get('digits', None)

#         state, status_code, message = verify_answer(
#             session_id, question_number, response, ivrs_type,
#         )

#         return Response("", status=status_code)
