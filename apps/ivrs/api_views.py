import datetime

from rest_framework import status
from rest_framework.response import Response
from rest_framework.exceptions import APIException

from django.db.models import F
from django.utils import timezone

from .utils import get_question
from .models import State, Chapter, GKATLM
from schools.models import School, SchoolDetails
from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView


class CheckSchool(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        state = State.objects.get_or_create(session_id=session_id)[0]

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

            # Get the class, which is the 2nd question and hence
            # will be there in the 1st index.
            class_number = state.answers[1]

            # Get the chapter number, which is the 4th question
            # and hence the 3rd index.
            chapter_number = state.answers[3]

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
            # and hence the 4th index.
            number = state.answers[4]

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
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            response = request.QUERY_PARAMS.get('digits', None)
            if response:
                response = response.strip('"')
                if int(response) == 1:
                    status_code = status.HTTP_200_OK
                else:
                    if state.question_number in [5, 6]:
                        # The User has rejected the Chapter or TLM title
                        # and hence we need to remove the corresponding
                        # entry from the state.answers list as well as
                        # reduce the question number. We are checking for
                        # 5 or 6 instead of 4 or 5 because once the user
                        # enters the value in the api request before this,
                        # we increment and save the question nnumber.

                        if state.question_number == 5:
                            # Index 3 has the answer to Q:4.
                            del state.answers[3]
                        else:
                            # Index 4 has the answer to Q:5.
                            del state.answers[4]
                        state.question_number = F('question_number') - 1
                        state.save()

                    status_code = status.HTTP_404_NOT_FOUND
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)


class VerifyAnswer(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            question = get_question(state.question_number)
            response = request.QUERY_PARAMS.get('digits', None)

            if response:
                response = int(response.strip('"'))

                # Special case for question 3 (Was Math class happening
                # on the day of your visit?). If 1, then fine. Else if
                # 2, then we have to skip 5 questions.
                if state.question_number == 3 and response == 2:
                    response = None
                    for i in range(0, 6):
                        state.answers.append('NA')
                        state.question_number = F('question_number') + 1
                        state.save()

                # Mapping integers to Yes/No and checking if the user
                # entered anything other than 1 or 2.
                if question.question_type == 'checkbox':
                    try:
                        accepted_answers = {1: 'Yes', 2: 'No'}
                        response = accepted_answers[response]
                    except:
                        response = None
                        status_code = status.HTTP_404_NOT_FOUND

                # The above two 'if's are special cases. The authentic
                # answer checking is below.
                if response in eval(question.options):
                    state.answers.append(response)
                    state.question_number = F('question_number') + 1
                    state.save()
                else:
                    status_code = status.HTTP_404_NOT_FOUND
            else:
                status_code = status.HTTP_404_NOT_FOUND
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)


class HangUp(KLPAPIView):
    def get(self, request):
        session_id = request.QUERY_PARAMS.get('CallSid', None)
        if State.objects.filter(session_id=session_id).exists():
            telephone = request.QUERY_PARAMS.get('From', None)
            date = request.QUERY_PARAMS.get('StartTime', None)

            state = State.objects.get(session_id=session_id)

            status_code = status.HTTP_200_OK
            school = School.objects.get(id=state.school_id)
            date = datetime.datetime.strptime(
                date, '%Y-%m-%d %H:%M:%S'
            )
            akshara_staff = UserType.objects.get_or_create(
                name=UserType.AKSHARA_STAFF
            )[0]
            question_group = Questiongroup.objects.get(
                version=2,
                source__name='ivrs'
            )

            story, created = Story.objects.get_or_create(
                school=school,
                group=question_group,
                date_of_visit=timezone.make_aware(
                    date, timezone.get_current_timezone()
                ),
                telephone=telephone,
                user_type=akshara_staff
            )

            for (question_number, answer) in enumerate(state.answers):
                if answer != 'NA':
                    question = get_question(question_number+1)
                    answer = Answer.objects.get_or_create(
                        story=story,
                        question=question,
                        text=answer
                    )
        else:
            status_code = status.HTTP_404_NOT_FOUND

        return Response("", status=status_code)
