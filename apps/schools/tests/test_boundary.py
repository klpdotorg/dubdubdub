from django.test import TestCase
from django.test import Client
import unittest
import json
import csv


class BoundaryApiTestCase(TestCase):

    def setUp(self):
        self.client = Client()

    def test_api_districts(self):
        print "Testing districts..."
        response = self.client.get("/api/v1/boundary/admin1s?geometry=yes")
        self.assertEqual(response.status_code, 200,
                         "districts api status code is 200")
        data = json.loads(response.content)
        self.assertTrue(len(data['features']) > 10,
                        "at least 10 districts returned")
        sample_district = data['features'][0]
        self.assertTrue('geometry' in sample_district,
                        "has geometry key")
        self.assertTrue('id' in sample_district['properties'],
                        "has a property called id")
        self.assertTrue('name' in sample_district['properties'],
                        "has a property called name")
        self.assertTrue('type' in sample_district['properties'],
                        "has a property called type")
        
    def test_api_blocks_schools(self):
        print "Testing blocks within districts..."
        response = self.client.get("/api/v1/boundary/admin1/8773/admin2?geometry=yes")
        print response.status_code
        self.assertEqual(response.status_code, 200,
                         "blocks per district api status code is 200")
        data = json.loads(response.content)
        self.assertTrue(len(data['features']) > 0,
                        "at least 1 districts returned")
        sample_district = data['features'][0]
        self.assertTrue('geometry' in sample_district,
                        "has geometry key")
        self.assertTrue('id' in sample_district['properties'],
                        "has a property called id")
        self.assertTrue('name' in sample_district['properties'],
                        "has a property called name")
        self.assertTrue('type' in sample_district['properties'],
                        "has a property called type")
