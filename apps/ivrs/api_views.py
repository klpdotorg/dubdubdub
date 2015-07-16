import datetime

from rest_framework import status
from rest_framework.response import Response
from rest_framework.exceptions import APIException

from django.db.models import F
from django.utils import timezone

from .models import State, Chapter, GKATLM
from .utils import get_question, skip_questions
from schools.models import School, SchoolDetails
from stories.models import Story, UserType, Questiongroup, Answer
from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView


class CheckSchool(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        state, created = State.objects.get_or_create(session_id=session_id)

        telephone = request.QUERY_PARAMS.get('From', None)
        date = request.QUERY_PARAMS.get('StartTime', None)
        date = datetime.datetime.strptime(
            date, '%Y-%m-%d %H:%M:%S'
        )
        date = timezone.make_aware(
            date, timezone.get_current_timezone()
        )

        # Ignoring index 0 since question_numbers start from 1
        state.answers.append('IGNORED_INDEX')
        # Initializing answer slots 1 to 12 with NA
        for i in range(0,11):
            state.answers.append('NA')

        state.telephone = telephone
        state.date = date
        state.save()

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


class ReadChapter(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK

            # Get the class number, which is the 2nd question
            class_number = state.answers[2]

            # Get the chapter number, which is the 4th question
            chapter_number = state.answers[4]

            chapter = Chapter.objects.get(
                class_number=class_number,
                chapter_number=chapter_number
            )

            data = "Chapter number is " + \
                   chapter_number + \
                   " and the title is " + \
                   chapter.title
        else:
            data = ''
            status_code = status.HTTP_404_NOT_FOUND

        return Response(data, status=status_code, content_type="text/plain")


class ReadTLM(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK

            # Get the GKATLM number, which is the 5th question
            number = state.answers[5]

            gkatlm = GKATLM.objects.get(
                number=number,
            )

            data = "T L M number is " + \
                   number + \
                   " and the title is " + \
                   gkatlm.title
        else:
            data = ''
            status_code = status.HTTP_404_NOT_FOUND

        return Response(data, status=status_code, content_type="text/plain")


class Verify(KLPAPIView):
    def get(self, request):
        status_code = status.HTTP_200_OK
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


class VerifyAnswer(KLPAPIView):
    def get(self, request, question_number):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            question = get_question(int(question_number))
            response = request.QUERY_PARAMS.get('digits', None)

            if response:
                response = int(response.strip('"'))

                # Mapping integers to Yes/No.
                if question.question_type.name == 'checkbox':
                    accepted_answers = {1: 'Yes', 2: 'No'}
                    response = accepted_answers[response]

                if response in eval(question.options):
                    state.answers[int(question_number)] = response
                    state.save()
                else:
                    status_code = status.HTTP_404_NOT_FOUND
            else:
                status_code = status.HTTP_404_NOT_FOUND
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)
