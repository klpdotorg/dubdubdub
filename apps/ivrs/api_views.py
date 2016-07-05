import os

from rest_framework import status
from rest_framework.response import Response

from django.conf import settings

from .models import State
from .utils import (
    get_message,
    get_question,
    save_answer,
    check_school,
    verify_answer,
    get_date,
    check_data_validity
)

from schools.models import School
from common.views import KLPAPIView

# Exotel numbers. Find them at http://my.exotel.in/viamentis/apps#installed-apps
PRI = "08039236431"
PRE = "08039510414"
GKA_DEV = "08039510185"
GKA_SMS = "08039514048"
GKA_SERVER = "08039591332"


class SMSView(KLPAPIView):
    def get(self, request):
        # In the SMS functionality of exotel, it expects a 200 response for all
        # its requests if it is to send the 'body' of your response as an sms
        # reply to the sender. Hence you will find places below where
        # status.HTTP_200_OK has been hardcoded in the response.
        content_type = "text/plain"

        date = request.QUERY_PARAMS.get('Date', None)
        data = request.QUERY_PARAMS.get('Body', None)
        ivrs_type = request.QUERY_PARAMS.get('To', None)
        telephone = request.QUERY_PARAMS.get('From', None)
        session_id = request.QUERY_PARAMS.get('SmsSid', None)

        state, created = State.objects.get_or_create(
            session_id=session_id
        )
        state.telephone = telephone
        state.date_of_visit = get_date(date.strip("'"))
        state.answers = []
        # Ignoring index 0 since question_numbers start from 1
        state.answers.append('IGNORED_INDEX')
        state.save()

        original_data = data # Used in the reply sms.
        data = data.split(',')
        data, valid, message = check_data_validity(original_data, data)
        if not valid:
            return Response(
                message,
                status=status.HTTP_200_OK,
                content_type=content_type
            )

        school_id = data.pop(0)

        state, status_code, message = check_school(state, school_id, ivrs_type)
        if status_code != status.HTTP_200_OK:
            return Response(
                message,
                status=status.HTTP_200_OK,
                content_type=content_type
            )

        # Loop over the entire data array and try to validate and save
        # each answer.
        for question_number, response in enumerate(data):
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
                    session_id,
                    question_number+1,
                    response,
                    ivrs_type,
                    original_data=original_data
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
                date=date,
                data=original_data
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
        # Ignoring index 0 since question_numbers start from 1
        state.answers.append('IGNORED_INDEX')

        if school_id:
            school_id = school_id.strip('"')

        state, status_code, message = check_school(state, school_id, ivrs_type)

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

def get_date(date):
    date = datetime.datetime.strptime(
        date, '%Y-%m-%d %H:%M:%S'
    )
    date = timezone.make_aware(
        date, timezone.get_current_timezone()
    )
    return date

