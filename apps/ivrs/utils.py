import datetime

from rest_framework import status

from django.utils import timezone

from .models import State, QuestionGroupType, IncomingNumber

from schools.models import School, BoundaryType
from stories.models import (
    Question, Questiongroup
)

# Exotel numbers. Find them at http://my.exotel.in/viamentis/apps#installed-apps
PRI = "08039236431"
PRE = "08039510414"
GKA_DEV = "08039510185"
GKA_SMS = "08039514048"
GKA_SERVER = "08039591332"

def get_message(**kwargs):
    if kwargs.get('valid', False):
        date = str(kwargs['date'])
        data = str(kwargs['data'])
        message = "Response accepted. Your message was: " + data + \
                  " received at: " + date

    elif not kwargs.get('valid', True):
        data = str(kwargs['data'])
        expected_response_1 = "3885,1,1,1,2,1"
        expected_response_2 = "3885,1,2,,,"
        expected_response_3 = "3885,1,2"

        message = "Error. Your response: " + data + \
                  ". Expected response: " + expected_response_1 + \
                  " OR " + expected_response_2 + \
                  " OR " + expected_response_3

    elif kwargs.get('no_school_id', False):
        message = "School ID not entered."

    elif kwargs.get('invalid_school_id', False):
        school_id = str(kwargs['school_id'])
        message = "School ID " + school_id + " not found."

    elif kwargs.get('not_primary_school', False):
        message = "Please enter Primary School ID."

    elif kwargs.get('not_pre_school', False):
        message = "Please enter PreSchool ID."

    elif kwargs.get('error_question_number', False):
        data = str(kwargs['original_data'])
        question_number = str(kwargs['error_question_number'])
        message = "Error at que.no: " + question_number + "." + \
                  " Your response was " + data

    return message

def check_data_validity(original_data, data):
    valid = True
    message = None

    if len(data) == 3:
        if data[2] != '2':
            valid = False
            message = get_message(valid=valid, data=original_data)
        else:
            # If the answer to 2nd question is "2" (which means "No"), then
            # We manually populate the rest of the answers as "2". This is
            # to maintain the consistency of the length of the data list to
            # always remain 6 for every valid sms.
            for i in range(0, 3):
                data.append('2')

    elif len(data) == 6:
        if all(response == '' for response in data[3:]):
            if data[2] != '2':
                valid = False
                message = get_message(valid=valid, data=original_data)
            else:
                # If the answer to 2nd question is "2" (which means "No"), then
                # We manually populate the rest of the answers as "2". This is
                # to maintain the consistency of the responses for all valid sms
                # that we receive.
                data = ['2' if response == '' else response for response in data]
        elif any(response == '' for response in data):
            # Responses like 3885,1,2,1,,2 are not accepted.
            valid = False
            message = get_message(valid=valid, data=original_data)

    elif len(data) != 6:
        valid = False
        message = get_message(valid=valid, data=original_data)

    # Making sure that each input is a valid digit and no alphabets get in.
    if not all(response.strip().isdigit() for response in data):
        valid = False
        message = get_message(valid=valid, data=original_data)


    return (data, valid, message)


def get_date(date):
    date = datetime.datetime.strptime(
        date, '%Y-%m-%d %H:%M:%S'
    )
    date = timezone.make_aware(
        date, timezone.get_current_timezone()
    )
    return date


def check_school(state, school_id, ivrs_type):
    school_type = None
    message = None

    if not school_id:
        status_code = status.HTTP_404_NOT_FOUND
        message = get_message(no_school_id=True)
        return (state, status_code, message)

    elif School.objects.filter(id=school_id).exists():
        status_code = status.HTTP_200_OK
        state.school_id = school_id
        school_type = School.objects.filter(
            id=school_id
        ).values(
            'admin3__type__name'
        )[0]['admin3__type__name']

    else:
        status_code = status.HTTP_404_NOT_FOUND
        message = get_message(invalid_school_id=True, school_id=school_id)
        return (state, status_code, message)

    incoming_number = IncomingNumber.objects.get(
        number=ivrs_type
    )

    # Validating whether the entered school ID corresponds to the
    # correct school_type. Assigns the qg_type based on the call
    # number as well.
    if school_type == u'Primary School':
        state.qg_type = incoming_number.qg_type
        number_of_questions = incoming_number.qg_type.questiongroup.questions.all().count()
        # Initializing answer slots 1 to number_of_questions with NA.
        # answer slot 0 has value IGNORED_INDEX pre populated.
        for i in range(0, number_of_questions):
            state.answers.append('NA')
        state.save()
    # We only check Primary School because we do not currently operate
    # in PreSchools. Once we do, implement the check logic here.
    else:
        status_code = status.HTTP_404_NOT_FOUND
        message = get_message(not_primary_school=True)

    return (state, status_code, message)


def verify_answer(session_id, question_number, response, ivrs_type, original_data=None):
    if State.objects.filter(session_id=session_id).exists():
        state = State.objects.get(session_id=session_id)

        message = None
        status_code = status.HTTP_200_OK
        question_number = int(question_number)
        incoming_number = IncomingNumber.objects.get(number=ivrs_type)
        question = get_question(
            question_number,
            incoming_number.qg_type.questiongroup
        )

        if response:
            response = int(response.strip('"'))

            # Mapping integers to Yes/No.
            accepted_answers = {1: 'Yes', 2: 'No', 3: 'Unknown'}
            if question.question_type.name == 'checkbox' and response in accepted_answers:
                if question_number == 1 and (ivrs_type in [GKA_SERVER, GKA_DEV]):
                    # This special case is there for question 1 which clubs "Was the school
                    # open?" and "Class visited". Since "Class visited" accepts answers from
                    # 1 to 8, we can't cast "1" and "2" to "yes" and "no". The answer to
                    # whether the school was open or not is handled in the save_answer
                    # function within utils.py
                    response = response
                else:
                    response = accepted_answers[response]

            # Save the answer.
            state, status_code = save_answer(
                state, question_number, question, ivrs_type, response
            )

        else:
            status_code = status.HTTP_404_NOT_FOUND
    else:
        status_code = status.HTTP_404_NOT_FOUND

    if status_code == status.HTTP_404_NOT_FOUND:
        message = get_message(
            error_question_number=question_number,
            original_data=original_data
        )

    return (state, status_code, message)


# GKA v3 questions are at https://github.com/klpdotorg/dubdubdub/issues/549#issuecomment-170913566
# We special case question Q1 and question Q5. Q1 should be split into Q1 and Q2. Q5 should
# be split into Q5, Q6 and Q7.
# DISCLAIMER: There is no neat way of doing this. Beware of the mess below!
def save_answer(state, question_number, question, ivrs_type, response):
    # Perform sanity check for GKA & PRI. PRE (old ivrs) only
    # has checkbox and numeric as answers types. Answers other
    # than 1 or 2 are already moderated on the exotel end. The
    # numeric answers cannot be moderated for the old ivrs.
    status_code = status.HTTP_200_OK
    if ivrs_type in [GKA_SERVER, GKA_DEV]:
        if question_number == 1: # Question 1 & 2 based on responses.
            if response == 0:
                # Q1. School is closed.
                state.answers[question_number] = 'No'
            elif response in range(1, 9):
                # Q1. School is open.
                state.answers[question_number] = 'Yes'
                # Q2. Class visited.
                state.answers[question_number + 1] = response
            else:
                status_code = status.HTTP_404_NOT_FOUND

        elif question_number == 5: # Question 5, 6 & 7 based on responses.
            if response == 99:
                # Q5. TLM is not being used.
                state.answers[question_number] = 'No'
                # Q7. Multiple TLMs are not being used.
                state.answers[question_number + 2] = 'No'
            elif response in range(1, 22):
                # Q5. TLM is being used.
                state.answers[question_number] = 'Yes'
                # Q6. TLM code
                state.answers[question_number + 1] = response
                # Q7. Multiple TLMs are not being used.
                state.answers[question_number + 2] = 'No'
            elif response == 55:
                # Q5. TLM is being used.
                state.answers[question_number] = 'Yes'
                # Q7. Multiple TLMs are being used.
                state.answers[question_number + 2] = 'Yes'
            else:
                status_code = status.HTTP_404_NOT_FOUND

        else:
            if response in eval(question.options):
                state.answers[question_number] = response
            else:
                status_code = status.HTTP_404_NOT_FOUND

    elif ivrs_type in [PRI, GKA_SMS]:
        if response in eval(question.options):
            state.answers[question_number] = response
        else:
            status_code = status.HTTP_404_NOT_FOUND
    else:
        state.answers[question_number] = response

    state.save()

    return (state, status_code)


def get_question(question_number, question_group):
    # We are directly querying for Primary School because we don't work
    # with PreSchools anymore. If we do so in the future, please make
    # sure you implement the logic here while fetching questions.
    school_type = BoundaryType.objects.get(name="Primary School")
    question = Question.objects.get(
        school_type=school_type,
        questiongroup=question_group,
        questiongroupquestions__sequence=question_number,
    )
    return question
