# from django.utils import unittest
from django.test import TestCase
from django.test import Client
import unittest
import json
import csv


class ApiTestCase(TestCase):

    def setUp(self):
        self.client = Client()

    def test_passing_test(self):
        x = 2
        self.assertEquals(x, 2, "2 is equal to 2")

    def test_api_schools_list(self):
        base_url = "/api/v1/schools/list?"
        query_url = base_url + '''bbox=77.54537736775214,12.950457093960514,
            77.61934126017755,13.022529216896507&geometry=yes'''
        response = self.client.get(query_url)
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
        base_response = self.client.get(base_url)
        base_results = json.loads(base_response.content)
        base_count = base_results['count']
        query_count = results['count']
        self.assertTrue(base_count > query_count,
                        "Total results > results within bbox")

    '''
    def test_api_schools_list_csv(self):
        response = self.client.get("/api/v1/schools/list?format=csv")
        self.assertEqual(response.status_code, 200,
                         "schools list csv status code is 200")
        #TODO: actually test the csv
    '''

    def test_api_schools_info(self):
        base_url = "/api/v1/schools/info?"
        query_url = base_url + "geometry=yes"
        response = self.client.get(query_url)
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
        response_page2 = self.client.get(query_url + "&page=2")
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
        response = self.client.get("/api/v1/schools/info?format=csv")
        self.assertEqual(response.status_code, 200,
                         "schools list csv status code is 200")
        #TODO: actually test the csv
    '''

    def test_api_school_info(self):
        response = self.client.get("/api/v1/schools/school/33312?geometry=yes")
        self.assertEqual(response.status_code, 200,
                         "school info status code is 200")
        data = json.loads(response.content)
        school_id = data['properties']['id']
        self.assertEqual(school_id, 33312, "school id is 33312")

    def test_api_school_demographics(self):
        response = self.client.get("/api/v1/schools/school/33312/demographics")
        print response.status_code
        self.assertEqual(response.status_code, 200,
                         "school demographics status code is 200")
        data = json.loads(response.content)
        school_id = data['id']
        self.assertEqual(school_id, 33312, "school id is 33312")
        num_boys=data['num_boys']
        self.assertTrue('num_boys' in data, "has a property called num_boys")
        #Assert that we have some value being returned for num_boys and it is not null
        self.assertTrue(num_boys > 0)
        self.assertTrue('num_girls' in data, "has a property called num_girls")
        self.assertTrue(data['num_girls'] > 0)

        #How to pick a random school ID from the DB? Input from a properties file?
    def test_api_school_programmes(self):
        response = self.client.get("/api/v1/schools/school/25139/programmes")
        print response.status_code
        self.assertEqual(response.status_code, 200,
                         "school programmes status code is 200")
        data = json.loads(response.content)
        school_id = data['id']
        self.assertEqual(school_id, 25139, "school id is 25139")
        self.assertTrue('name' in data, "has a property called name")
        self.assertEqual(data['name'], "GOVT HPS KARADKAL", "School name is GOVT HPS KARADKAL")
    
    def test_api_school_finance(self):
        print "Testing schools finance API"
        response=self.client.get("/api/v1/schools/school/4708/finance")
        self.assertEqual(response.status_code,200,"school finance status code is 200")
        data = json.loads(response.content)
        self.assertEqual(data['id'],4708,"school id is 4708")
        self.assertEqual(data['name'],"GOVT HPS TOGALUR","School name is GOVT HPS TOGALUR")
        self.assertTrue(data['classroom_count'] > 0)
        self.assertTrue(data['teacher_count'] > 0)
        self.assertTrue('tlm_expnd_dise' in data, "has a property called tlm_expnd_dise")
        self.assertTrue('tlm_recd_dise' in data, "has a property called tlm_recd_dise")
        self.assertTrue('sg_recd_dise' in data, "has a property called sg_recd_dise")
        # SS: Not sure I can assert the expenditure pieces because these may vary

    def test_api_school_infra(self):
        print "Testing schools infrastructure API"
        response=self.client.get("/api/v1/schools/school/24954/infrastructure")
        self.assertEqual(response.status_code,200,"school infra status code is 200")
        data = json.loads(response.content)
        self.assertEqual(data['id'],24954,"school id is 24954")
        self.assertEqual(data['name'],"GOVT LPS URDU SIRWAL","School name is GOVT LPS URDU SIRWAL")
        self.assertTrue(data['classroom_count'] > 0)
        self.assertTrue(data['teacher_count'] > 0)
        self.assertTrue('num_boys_dise' in data, "has a property called num_boys_dise")
        self.assertTrue('num_girls_dise' in data, "has a property called num_girls_dise")
        self.assertTrue('lowest_class' in data, "has a property called lowest_class")
        self.assertTrue('highest_class' in data, "has a property called highest_class")
        self.assertTrue('status' in data, "has a property called status")
        self.assertTrue('dise_books' in data, "has a property called dise_books")
        self.assertTrue('dise_rte' in data, "has a property called dise_rte")
        self.assertTrue('dise_facility' in data, "has a property called dise_facility")

    def test_api_districts(self):
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
