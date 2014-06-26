from django.utils import unittest
from django.test import TestCase
from django.test.client import Client
import json
import csv


class ApiTestCase(unittest.TestCase):

    def setUp(self):
        self.c = Client()

    def test_passing_test(self):
        x = 2
        self.assertEquals(x, 2, "2 is equal to 2")

    def test_api_schools_list(self):
        base_url = "/api/v1/schools/list?"
        query_url = base_url + '''bbox=77.54537736775214,12.950457093960514,
            77.61934126017755,13.022529216896507&geometry=yes'''
        response = self.c.get(query_url)
        self.assertEqual(response.status_code, 200,
                         "schools list status code is 200")
        results = json.loads(response.content)
        self.assertEqual(len(results['features']), 50,
                         "got 50 schools as first page")
        sample_school = results['features'][0]
        self.assertTrue('id' in sample_school['properties'],
                        "has a property called id")
        self.assertTrue('name' in sample_school['properties'],
                        "has a property called name")
        base_response = self.c.get(base_url)
        base_results = json.loads(base_response.content)
        base_count = base_results['count']
        query_count = results['count']
        self.assertTrue(base_count > query_count,
                        "Total results > results within bbox")

    '''
    def test_api_schools_list_csv(self):
        response = self.c.get("/api/v1/schools/list?format=csv")
        self.assertEqual(response.status_code, 200,
                         "schools list csv status code is 200")
        #TODO: actually test the csv
    '''

    def test_api_schools_info(self):
        base_url = "/api/v1/schools/info?"
        query_url = base_url + "geometry=yes"
        response = self.c.get(query_url)
        self.assertEqual(response.status_code, 200,
                         "schools info status code is 200")
        results = json.loads(response.content)
        self.assertEqual(len(results['features']), 50,
                         "got 50 schools as first page")
        sample_school = results['features'][0]
        self.assertTrue('mgmt' in sample_school['properties'],
                        'has a property called management')
        self.assertTrue('cat' in sample_school['properties'],
                        'has a property called category')
        self.assertTrue('address_full' in sample_school['properties'],
                        'has a property called address')
        self.assertTrue('dise_code' in sample_school['properties'],
                        "has a property called dise_code")
        response_page2 = self.c.get(query_url + "&page=2")
        self.assertEqual(response_page2.status_code, 200,
                         "schools info page 2 status code is 200")
        results_page2 = json.loads(response_page2.content)
        self.assertEqual(len(results_page2['features']), 50,
                         "got 50 schools as second page")
        sample_school_2 = results_page2['features'][0]
        school1id = sample_school['properties']['id']
        school2id = sample_school_2['properties']['id']
        self.assertFalse(school1id == school2id, "page 2 differs from page 1")

    '''
    #FIXME: CSV Tests are really slow because of pagination is turned off.
        Perhaps we should move this to a different test module or so?
    def test_api_schools_info_csv(self):
        response = self.c.get("/api/v1/schools/info?format=csv")
        self.assertEqual(response.status_code, 200,
                         "schools list csv status code is 200")
        #TODO: actually test the csv
    '''

    def test_api_school_info(self):
        response = self.c.get("/api/v1/schools/school/33312?geometry=yes")
        self.assertEqual(response.status_code, 200,
                         "school info status code is 200")
        data = json.loads(response.content)
        school_id = data['properties']['id']
        self.assertEqual(school_id, 33312, "school id is 33312")

    def test_api_districts(self):
        response = self.c.get("/api/v1/boundary/districts?geometry=yes")
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
