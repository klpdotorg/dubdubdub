from django.test import TestCase
from django.contrib.auth.models import Group

from rest_framework.test import APIRequestFactory

from users.models import User
from ivrs.api_views import SMSView

class SMSViewTests(TestCase):

    def setUp(self):
        user, created = User.objects.get_or_create(
            email="testing@klp.org.in",
            mobile_no="1234567890",
        )
        group = Group.objects.get(name="BFC")
        group.user_set.add(user)

    def test_reply_for_valid_input(self):
        """
        SMSView should return a certain reply to be sent when it receives
        a valid input
        """
        print "Testing for valid input"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        request = factory.get(
            '/api/v1/sms/',
            {
                'SmsSid':'1',
                'From':'01234567890',
                'To':'08039514048',
                'Date':'2016-07-12 15:16:48',
                'Body':'24657,1,1,1,2,2',
            },
            content_type='text/plain',
        )
        response = view(request)
        self.assertEqual(
            response.data,
            'Response accepted. Your message was: 24657,1,1,1,2,2 received at: 2016-07-12 15:16:48'
        )

    def test_reply_for_invalid_input(self):
        """
        SMSView should return a certain reply to be sent when it receives
        an invalid input
        """
        print "Testing for invalid input"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        bodies = [
            '24657,1,1,1,2,2,2',
            'wat',
            '24657,1,2,,',
            '24657,1,1,',
        ]
        for body in bodies:
            print "Testing input: " + body
            request = factory.get(
                '/api/v1/sms/',
                {
                    'SmsSid':'2',
                    'From':'01234567890',
                    'To':'08039514048',
                    'Date':'2016-07-12 15:16:48',
                    'Body':body,
                },
                content_type='text/plain',
            )
            response = view(request)
            self.assertEqual(
                response.data,
                'Error. Your response: ' + body + '. Expected response: 3885,1,1,1,2,2'
            )

    def test_reply_for_invalid_school_id(self):
        """
        SMSView should return a certain reply to be sent when it receives
        an invalid school_id
        """
        print "Testing for invalid school_id"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        #body = 'ID 20,1,1,1,2,2'
        bodies = [
            '0,1,1,1,2,2',
            u'ID 20,1,1,1,2,2',
           
        ]
        for body in bodies:
            print "Testing input: " + body
            request = factory.get(
                '/api/v1/sms/',
                {
                    u'SmsSid':u'2',
                    u'From':u'01234567890',
                    u'To':u'08039514048',
                    u'Date':u"'2016-07-12 15:16:48'",
                    u'Body':body,
                },
                content_type='text/plain',
            )
            response = view(request)
            self.assertEqual(
                response.data,
                'School ID ' + body.split(',').pop(0) + ' not found.'
            )

    def test_reply_for_blank_telephone(self):
        """
        SMSView should return a certain reply to be sent when it receives
        a blank telephone
        """
        print "Testing for blank telephone"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        body = '0,1,1,1,2,2'
        request = factory.get(
            '/api/v1/sms/',
            {
                'SmsSid':'2',
                'From':'',
                'To':'08039514048',
                'Date':'2016-07-12 15:16:48',
                'Body':body,
            },
            content_type='text/plain',
        )
        response = view(request)
        self.assertEqual(
            response.data,
            'The telephone is blank.'
        )

    def test_reply_for_invalid_answer_to_specific_question_number(self):
        """
        SMSView should return a certain reply to be sent when it receives
        an invalid input
        """
        print "Testing for invalid input to specific question number"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        bodies = [
            '24657,1,4,1,2,2',
            '24657,1,1,4,2,2',
            '24657,1,1,2,4,2',
            '24657,1,1,1,2,4',
        ]
        for count, body in enumerate(bodies):
            print "Testing input: " + body
            request = factory.get(
                '/api/v1/sms/',
                {
                    'SmsSid':'2',
                    'From':'01234567890',
                    'To':'08039514048',
                    'Date':'2016-07-12 15:16:48',
                    'Body':body,
                },
                content_type='text/plain',
            )
            response = view(request)
            self.assertEqual(
                response.data,
                'Error at que.no: ' + str(count+2) + '. Your response was ' + body
            )

    def test_reply_for_logical_error(self):
        """
        SMSView should return a certain reply to be sent when it receives
        data that has a logical error.
        """
        print "Testing for logical error in input"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        body = '24657,1,3,1,2,1'
        print "Testing input: " + body
        request = factory.get(
            '/api/v1/sms/',
            {
                'SmsSid':'2',
                'From':'01234567890',
                'To':'08039514048',
                'Date':'2016-07-12 15:16:48',
                'Body':body,
            },
            content_type='text/plain',
        )
        response = view(request)
        self.assertEqual(
            response.data,
            'Logical error.'
        )

    def test_reply_for_unregistered_number(self):
        """
        SMSView should return a certain reply to be sent when it receives
        data from a number that is not registered.
        """
        print "Testing for unregistered number"
        view = SMSView.as_view()
        factory = APIRequestFactory()
        body = '24657,1,3,1,2,1'
        print "Testing input: " + body
        request = factory.get(
            '/api/v1/sms/',
            {
                'SmsSid':'2',
                'From':'01234567',
                'To':'08039514048',
                'Date':'2016-07-12 15:16:48',
                'Body':body,
            },
            content_type='text/plain',
        )
        response = view(request)
        self.assertEqual(
            response.data,
            "Your number 1234567 is not registered. Please visit https://klp.org.in/ and register yourself."
        )

