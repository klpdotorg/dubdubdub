from django.test import TestCase

from rest_framework.test import APIRequestFactory

from .api_views import SMSView

class SMSViewTests(TestCase):

    def test_reply_for_valid_input(self):
        """
        SMSView should return a certain reply to be sent when it receives
        a valid input
        """
        view = SMSView.as_view()
        factory = APIRequestFactory()
        request = factory.get(
            '/api/v1/sms/',
            {
                'SmsSid':'023w32',
                'From':'9495111772',
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
