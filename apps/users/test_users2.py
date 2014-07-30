from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from django.core.urlresolvers import reverse
from rest_framework import status
from django.conf import settings
from .models import User
import unittest
import json
import csv

class UsersApiTestCase2(APITestCase):

    usersBaseUrl="/api/v1/users"
    test_user1_information = {
                'email': 'deleteme2@test.com',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
                'password' : 'deleteme2'
            }

    def setup(self):
    	print 'setup'
    	self.url="/api/v1/users"

    #Test attempts to create a test user via the REST API
    def test_create_user_success(self):

        print 'RUNNING test_create_user_success...'
        
        response=self.client.post(self.usersBaseUrl,self.test_user1_information)
        print response.status_code
        self.assertEqual(response.status_code,status.HTTP_201_CREATED,"User created")
        print response.data

        #Now, test logging in as this user with username/pwd
        #print "TESTING user login"
        #userLoginInfo={'email': 'deleteme2@test.com','password':'deleteme2'}
        #response = self.client.post(self.usersBaseUrl+"/login",userLoginInfo)
        #print response.status_code
        #self.assertEqual(response.status_code,status.HTTP_200_OK)
        #print response.data

        self.delete_user(self.test_user1_information['email'])
        print 'DONE'
        print '---------------------------------------'
	
    #Regular users should not be able to GET users information. It should fail with a 403 even if token is supplied
    def test_regular_user_GET_forbidden(self):
    	print 'testing users sample 2'
    	url = '/api/v1/users'
        print 'RUNNING test_create_user_success...'
        userInformation = {
                'email': 'deleteme2@test.com',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
                'password' : 'deleteme2'
            }
        response=self.client.post(url,userInformation)
        print response.status_code
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        token = response.data['token']

        self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response=self.client.get(url)
        print response.status_code
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        print response.data

    #Regular users should not be able to GET if no token is supplied. 401 should result
    def test_regular_user_GET_unauthorized(self):
    	print 'testing users sample 2'
    	url = '/api/v1/users'
        print 'RUNNING test_create_user_success...'
        userInformation = {
                'email': 'deleteme2@test.com',
                'first_name': 'deleteme2',
                'last_name': 'deleteme2',
                'mobile_no': '9837543232',
                'password' : 'deleteme2'
            }
        response=self.client.post(url,userInformation)
        print response.status_code
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        #token = response.data['token']

        #self.client.credentials(HTTP_AUTHORIZATION='Token ' + token)
        response=self.client.get(url)
        print response.status_code
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        print response.data

    def test_super_user_GET(self):
    	print 'testing super user GET'
    	url = '/api/v1/users'
        print 'RUNNING test_create_user_success...'
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
        
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.adminToken)
        response=self.client.get(url)
        print response.status_code
        print response.data
        self.assertEqual(response.status_code,status.HTTP_200_OK)

        print "Getting the user profile"
        response=self.client.get(url+"/profile")
        print response.status_code
        print response.data
        self.assertEqual(response.status_code,status.HTTP_200_OK)

        self.delete_user('test_superuser@test.com')

    def test_super_user_GET_notoken(self):
        print 'testing super user GET without token'
        url = '/api/v1/users'
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
        
        # Don't set the token. Super user should still get unauthorized
        response=self.client.get(url)
        print response.status_code
        print response.data
        self.assertEqual(response.status_code,status.HTTP_401_UNAUTHORIZED)
    


    def delete_user(self, user_email):
        u = User.objects.get(email=user_email)
        print u.email
        u.delete()
    
        
    def tearDown(self):
        print "calling teardown..."
        #u = User.objects.get(email='test_superuser@test.com')
        #print u.email
        #u.delete()
        #print "User deleted"
		
    
		
		