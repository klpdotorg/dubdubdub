from django.test import TestCase
from django.test import Client
from django.conf import settings
from .models import User
import unittest
import json
import csv

class UsersApiTestCase(TestCase):

# Create your tests here.
def setUp(self):
	print "setup.."
    self.client = Client()

   ''' self.schools_lib_id = settings.TESTS_SCHOOLS_INPUT['SCHOOLS_LIB_ID']
             self.schools_lib_id2 = settings.TESTS_SCHOOLS_INPUT['SCHOOLS_LIB_ID2']
             self.school_info_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_INFO_ID']
             self.school_demographics_id=settings.TESTS_SCHOOLS_INPUT['SCHOOL_DEMOGRAPHICS_ID']
             self.school_programmes_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_PROGRAMMES_ID']
             self.school_finance_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_FINANCE_ID']
             self.school_infra_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_INFRA_ID']'''

def test_create_user(self):
	print 'Creating user...'
	extras = {
            'mobile_no': '9837543232',
            'first_name': 'deleteme1',
            'last_name': 'deleteme1'
        }
	#user = User.objects.create_user('deleteme1@test.com', 'deleteme1', **extras)
	print 'Done creating user'

