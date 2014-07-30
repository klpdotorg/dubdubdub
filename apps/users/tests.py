from django.test import TestCase
from django.test import Client
from django.conf import settings
from .models import User
import unittest
import json
import csv

class UsersApiTestCase(TestCase):

    usersBaseUrl="/api/v1/users"
    user1_info = {
                'email': 'deleteme2@test.com',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
                'password' : 'deleteme2'
            }

    # Create your tests here.
    def setUp(self):
    	print "setup.."
        self.client = Client()
        
        #Create one super user
        #print "Create super user.."
        userInformation = {
                'mobile_no': '9837543232',
                'first_name': 'superuser',
                'last_name': 'superuser'
            }
        self.adminUser = User.objects.create_user('test_superuser@test.com', 'test_superuser', **userInformation)
        print self.adminUser.email
        self.adminToken = User.get_token(self.adminUser)
        print self.adminToken      
        self.adminUser.is_superuser = True
        self.adminUser.save()
        #print "Done creating super user"

    def test_create_user_success(self):
        print 'RUNNING test_create_user_success...'
        userInformation = {
                'email': 'deleteme2@test.com',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
                'password' : 'deleteme2'
            }
        response=self.client.post(self.usersBaseUrl,userInformation)
        print response.status_code
        self.assertEqual(response.status_code,201,"User created")
        userinfo = json.loads(response.content)
        print userinfo

        self.delete_user('deleteme2@test.com')
        print 'DONE'
        print '---------------------------------------'
    
    def test_create_user_duplicate_email(self):
        print 'RUNNING test_create_user_dupe'

    def test_get_user_failure_unauthorized(self):
        print 'testing user with token'
        response=self.client.post(self.usersBaseUrl,self.user1_info)
        print response.status_code
        self.assertEqual(response.status_code,201,"User created")
        userinfo = json.loads(response.content)
        print userinfo

        print 'Getting user with GET..'
        #Any random user should NOT be able to fetch user details? Shouldn't they be able to see their own details?
        response = self.client.get(self.usersBaseUrl)
        print response.status_code
        self.assertEqual(response.status_code,401, "User forbidden")
        self.delete_user(self.user1_info['email'])
        print 'DONE'
        print '---------------------------------------'

    ## WORK ON FIGURING OUT HOW TO SEND A HEADER
    def test_get_user_failure_forbidden(self):
        print 'testing user without token'
        response=self.client.post(self.usersBaseUrl,self.user1_info)
        print response.status_code
        self.assertEqual(response.status_code,201,"User created")
        userinfo = json.loads(response.content)
        print userinfo

        print 'Getting user with GET and Token header..'
        authheader = {'Authorization': 'Token ' + userinfo['token']}
        print authheader
        #Any random user should NOT be able to fetch user details? Shouldn't they be able to see their own details?
        response = self.client.get(self.usersBaseUrl, **authheader)
        print response.status_code
        self.assertEqual(response.status_code,403, "User forbidden")
        self.delete_user(self.user1_info['email'])
        print 'DONE'
        print '---------------------------------------'
    
    #This test should fail with a 400. No password is supplied
    def test_create_user_nopassword(self):
    	print 'RUNNING test_create_user_nopassword..'
    	userInformation = {
                'email': 'deleteme2@test.com',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
            }
        response=self.client.post(self.usersBaseUrl,userInformation)
        print response.status_code
        self.assertEqual(response.status_code,400,"User password not supplied")
        userinfo = json.loads(response.content)
        print userinfo
        self.assertEqual(userinfo['detail'],'No password supplied')
        print "DONE"
        print '---------------------------------------'

    #If we attempt to create without e-mail, it should fail with a 400 and an error message to go along
    def test_create_user_noEmail(self):
        print 'RUNNING test_create_user_noEmail...'
        userInformation = {
                'password': 'deleme',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
            }
        response=self.client.post(self.usersBaseUrl,userInformation)
        print response.status_code
        self.assertEqual(response.status_code,400,"User email not supplied")
        userinfo = json.loads(response.content)
        print userinfo
        self.assertTrue('detail' in userinfo, "Explanation exists in the JSON for failure")
        print 'DONE'
        print '---------------------------------------'

    def delete_user(self, user_email):
        #print "calling teardown..."
        u = User.objects.get(email=user_email)
        print u.email
        u.delete()
    
        
    def tearDown(self):
        #print "calling teardown..."
        u = User.objects.get(email=self.adminUser.email)
        print u.email
        u.delete()
        #print "User deleted"

    
