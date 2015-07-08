from rest_framework import status
from rest_framework.response import Response
from rest_framework.exceptions import APIException

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView

from .models import State
from .utils import get_options, get_question
from schools.models import School, SchoolDetails


class CheckSchool(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        state = State.objects.create(session_id=session_id)

        status_code = status.HTTP_200_OK
        school_id = request.QUERY_PARAMS.get('digits', None)
        if not school_id:
            status_code = status.HTTP_404_NOT_FOUND
        else:
            school_id = school_id.strip('"')
            if School.objects.filter(id=school_id).exists():
                state.school_id = school_id
                state.save()
            else:
                status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)


class ReadSchool(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            school = School.objects.get(id=state.school_id)
            data = "The ID you have entered is " + \
                   " ".join(str(school.id)) + \
                   " and school name is " + \
                   school.name
        else:
            status_code = status.HTTP_404_NOT_FOUND
            data = ''

        return Response(data, status=status_code, content_type="text/plain")


class Verify(KLPAPIView):
    def get(self, request):
        response = request.QUERY_PARAMS.get('digits', None)
        if response:
            response = response.strip('"')
            if int(response) == 1:
                status_code = status.HTTP_200_OK
            else:
                status_code = status.HTTP_404_NOT_FOUND
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)


class AskQuestion(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            question = get_question(state.question_number)
            options = get_options(state.question_number)
            data = question.text + options
        else:
            status_code = status.HTTP_404_NOT_FOUND
            data = ''

        return Response(data, status=status_code, content_type="text/plain")


class VerifyAnswer(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            question = get_question(state.question_number)
            response = request.QUERY_PARAMS.get('digits', None)

            if response:
                response = response.strip('"')
                if int(response) in eval(question.options):
                    state.answers.append(response)
                    state.update(question_number=F('question_number') + 1)
                else:
                    status_code = status.HTTP_404_NOT_FOUND
            else:
                status_code = status.HTTP_404_NOT_FOUND
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)
