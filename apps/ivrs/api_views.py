from rest_framework import status
from rest_framework.response import Response
from rest_framework.exceptions import APIException

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView

from .models import State
from schools.models import School, SchoolDetails


class CheckSchool(KLPAPIView):
    def get(self, request):
        status_code = status.HTTP_200_OK

        session_id = request.QUERY_PARAMS.get('CallSid', None)
        state = State.objects.create(session_id=session_id)

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
            school = School.objects.get(id=state.school_id)
            data = "The ID you have entered is " + \
                   " ".join(str(school.id)) + \
                   " and school name is " + \
                   school.name
            status_code = status.HTTP_200_OK
        else:
            data = ''
            status_code = status.HTTP_404_NOT_FOUND

        return Response(data, status=status_code, content_type="text/plain")


class Verify(KLPAPIView):
    def get(self, request):
        response = request.QUERY_PARAMS.get('digits', None)
        response = response.strip('"')
        if int(response) == 1:
            status_code = status.HTTP_200_OK
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)
