from rest_framework import status
from rest_framework.response import Response

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView

from .models import State
from schools.models import School, SchoolDetails


class CheckSchool(KLPAPIView):
    def get(self, request):
        status_code = status.HTTP_200_OK

        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if session_id:
            state = State.objects.create(session_id=session_id)

        school_id = request.QUERY_PARAMS.get('digits', None)
        if school_id:
            school_id = school_id.strip('"')
            if School.objects.filter(id=school_id).exists():
                state.school_id = school_id
                state.save()
            else:
                status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)
