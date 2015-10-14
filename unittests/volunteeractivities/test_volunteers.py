from django.test import TestCase
from django.test import Client
from django.conf import settings
import unittest
import json
import csv


class VolunteersApiTestCase(TestCase):

    activities_base_url = "/api/v1/volunteer_activities"

    def setUp(self):
        self.client = Client()
        self.activity_id = settings.TESTS_ACTIVITIES_INPUT['ACTIVITY_ID']
        print self.activity_id
        self.organization_id = settings.TESTS_ACTIVITIES_INPUT['ORG_ID']
    
    def test_api_volunteer_activities(self):
        response = self.client.get(self.activities_base_url)
        self.assertEqual(
            response.status_code, 200,
            "Volunteer activities has returned %s" % response.status_code
        )
        results = json.loads(response.content)
        activities = results['features'][0]
        self.assertTrue('id' in activities, "has property activity id")
        self.assertTrue('organization' in activities, "has property org")
        self.assertTrue('date' in activities, "has property date")
        self.assertTrue('type' in activities, "has property type")
        self.assertTrue('school' in activities, "has property school")
        self.assertTrue('text' in activities, "has property text")
        self.assertTrue('organization_details' in activities, "has org details")
        self.assertTrue('school_details' in activities, "has school details")
        self.assertTrue('users' in activities, "has users field")
        self.assertTrue('activity_type_details' in activities, "has activity type details")

    def test_single_acitivity_noid(self):
        response = self.client.get(self.activities_base_url)
        print response.status_code

    def test_single_activity_byid(self):
        query_url=self.activities_base_url+"/" + self.activity_id
        print query_url
        response=self.client.get(query_url)
        print response
        self.assertEqual(response.status_code,200)