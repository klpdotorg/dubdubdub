from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient
from rest_framework.test import APITestCase
from django.core.urlresolvers import reverse
from rest_framework import status
from django.conf import settings
from users.models import User
import unittest
import json
import csv


class UsersApiTestCase(APITestCase):

    usersBaseUrl = "/api/v1/users"
    loginUrl = "/api/v1/users/login"
    logoutUrl = "/api/v1/users/logout"
    profilesUrl = "/api/v1/users/profile"

    test_user1_information = {
        'email': 'deleteme2@test.com',
        'first_name': 'deleteme2',
        'last_name': 'deleteme2',
        'mobile_no': '9837543232',
        'password': 'deleteme2'
    }
    test_user2_information = {
        'email': 'iamtestbot2@test.com',
        'first_name': 'iamtestbot2',
        'last_name': 'iamtestbot2',
        'mobile_no': '9872321123',
        'password': 'iamtestbot2'
    }
    test_user1_token = ''

    def setUp(self):
        print 'setup'
        # Create a user user1 for usage in all the tests.
        response = self.client.post(self.usersBaseUrl, self.test_user1_information)
        print 'Status code:' + str(response.status_code) + '; Expected: ' + str(status.HTTP_201_CREATED)
        print response.data
        self.test_user1_token = response.data['token']
        print '---------------------------------------'

    # Test attempts to create a test user via the REST API
    def test_create_user_success(self):

        print 'RUNNING test_create_user_success...'

        response = self.client.post(self.usersBaseUrl, self.test_user2_information)
        print 'POST ' + self.usersBaseUrl
        print 'Status code:' + str(response.status_code) + '; Expected: ' + str(status.HTTP_201_CREATED)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED, "User created")
        print 'Response:' + str(response.data)

        self.delete_user(self.test_user2_information['email'])
        print 'DONE'
        print '---------------------------------------'

    # Tests user login using an already created user
    def test_user_login(self):

        print 'Testing user login'
        response = self.client.post(self.usersBaseUrl, self.test_user2_information)
        print 'POST ' + self.usersBaseUrl
        print 'Status code:' + str(response.status_code) + '; Expected: ' + str(status.HTTP_201_CREATED)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED, "User created")
        print 'Response:' + str(response.data)

        # Now, test logging in as this user with username/pwd

        userLoginInfo = {
            'email': self.test_user2_information['email'],
            'password': self.test_user2_information['password']
        }
        response = self.client.post(self.loginUrl, userLoginInfo)
        print 'POST ' + self.loginUrl
        print 'Status code:' + str(response.status_code) + '; Expected: ' + str(status.HTTP_200_OK)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        print 'Response:' + str(response.data)

        # Get profile
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + str(response.data['token']))
        response = self.client.get(self.profilesUrl)
        print 'GET ' + self.profilesUrl
        print 'Status code:' + str(response.status_code) + '; Expected: ' + str(status.HTTP_200_OK)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Edit Profile, POST shouldn't work
        response = self.client.post(self.profilesUrl, {'about': 'foobar'})
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED, response.status_code)
        # Patch should work
        response = self.client.patch(self.profilesUrl, {'about': 'foobar'})
        self.assertEqual(response.status_code, status.HTTP_200_OK, response.status_code)
        # verify edit
        response = self.client.get(self.profilesUrl)
        self.assertEqual(response.status_code, status.HTTP_200_OK, response.status_code)
        self.assertEqual(response.data['about'], 'foobar', response.data)

        # Test logout
        response = self.client.get(self.logoutUrl)
        print 'GET ' + self.logoutUrl
        print 'Status code: ' + str(response.status_code) + '; Expected: ' + str(status.HTTP_200_OK)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        print 'Response:' + str(response.data)

        # Now test fetching profiles, it should return a 401
        # Clear out credentials from the client
        self.client.credentials()
        response = self.client.get(self.profilesUrl)
        print 'GET ' + self.profilesUrl
        print 'Status code: ' + str(response.status_code) + '; Expected: ' + str(status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

        self.delete_user(self.test_user2_information['email'])
        print 'DONE'
        print '---------------------------------------'

    # Users should get a 401 if attempting to fetch profiles without login
    def test_user_getprofile_nologin(self):
        print "Testing user GET profile without login"
        print 'GET ' + self.profilesUrl
        response = self.client.get(self.profilesUrl)
        print 'Status code: ' + str(response.status_code) + '; Expected: ' + str(status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        print '---------------------------------------'

    # Regular users should not be able to GET users information. It should fail with a 403 even if token is supplied
    def test_regular_user_GET_forbidden(self):
        print 'Testing regular user GET forbidden'
        print 'User1 token is:' + self.test_user1_token
        # Get the user1's token and set it as credentials on the client
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.test_user1_token)

        print 'GET ' + self.usersBaseUrl
        response = self.client.get(self.usersBaseUrl)
        print 'Status code: ' + str(response.status_code) + '; Expected: ' + str(status.HTTP_403_FORBIDDEN)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        print response.data
        print '---------------------------------------'

    # Regular users should not be able to GET if no token is supplied. 401 should result
    def test_regular_user_GET_unauthorized(self):

        print 'RUNNING test regular user GET unauthorized...'

        print 'GET ' + self.usersBaseUrl

        response = self.client.get(self.usersBaseUrl)
        print 'Status code: ' + str(response.status_code) + '; Expected: ' + str(status.HTTP_401_UNAUTHORIZED)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        print 'Response: ' + str(response.data)
        print '---------------------------------------'

    # def test_super_user_GET(self):
    #     print 'testing super user GET'
    #     userInformation = {
    #         'mobile_no': '9837543232',
    #         'first_name': 'superuser',
    #         'last_name': 'superuser'
    #     }
    #     self.adminUser = User.objects.create_user('test_superuser@test.com', 'test_superuser', **userInformation)
    #     print self.adminUser.email
    #     self.adminToken = User.get_token(self.adminUser)
    #     print self.adminToken
    #     self.adminUser.is_superuser = True
    #     self.adminUser.save()

    #     print 'Getting all users..'
    #     self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.adminToken)
    #     response = self.client.get(self.usersBaseUrl)
    #     print response.status_code
    #     print response.data
    #     self.assertEqual(response.status_code, status.HTTP_200_OK)

    #     print "Getting the user profile for the super user"
    #     response = self.client.get(self.usersBaseUrl + "/profile")
    #     print response.status_code
    #     print response.data
    #     self.assertEqual(response.status_code, status.HTTP_200_OK)

    #     print "Deleting super user.."
    #     self.delete_user('test_superuser@test.com')
    #     print '---------------------------------------'

    def test_super_user_GET_notoken(self):
        print 'testing super user GET without token'
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
        response = self.client.get(self.usersBaseUrl)
        print 'Status code: ' + str(response.status_code) + '; Expected: ' + str(status.HTTP_401_UNAUTHORIZED)
        print response.data
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        print '---------------------------------------'

    def delete_user(self, user_email):
        u = User.objects.get(email=user_email)
        print 'Deleting user --' + u.email
        u.delete()

    def tearDown(self):
        print "calling teardown..."
        u = User.objects.get(email=self.test_user1_information['email'])
        email = u.email
        u.delete()
        print "User deleted -- " + email
