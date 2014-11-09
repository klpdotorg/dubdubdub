# from django.utils import unittest
from django.test import TestCase
from django.test import Client
from django.conf import settings
import unittest
import json
import csv


class SchoolsApiTestCase(TestCase):

    schools_base_url = "/api/v1/schools/school/"

    def setUp(self):
        self.client = Client()
        self.schools_lib_id = settings.TESTS_SCHOOLS_INPUT['SCHOOLS_LIB_ID']
        self.schools_lib_id2 = settings.TESTS_SCHOOLS_INPUT['SCHOOLS_LIB_ID2']
        self.school_info_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_INFO_ID']
        self.school_demographics_id=settings.TESTS_SCHOOLS_INPUT['SCHOOL_DEMOGRAPHICS_ID']
        self.school_programmes_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_PROGRAMMES_ID']
        self.school_finance_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_FINANCE_ID']
        self.school_infra_id = settings.TESTS_SCHOOLS_INPUT['SCHOOL_INFRA_ID']

    def test_passing_test(self):
        x = 2
        self.assertEquals(x, 2, "2 is equal to 2")

    def test_api_schools_list_geometry(self):

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
        pass

    def test_api_schools_info_geometry(self):

        base_url = "/api/v1/schools/info?"
        query_url = base_url + "geometry=yes"
        response = self.client.get(query_url)
        self.assertEqual(response.status_code, 200,
                         "schools info status code is 200")
        results = json.loads(response.content)
        self.assertEqual(len(results['features']), 50,
                         "got 50 schools as first page")
        sample_school = results['features'][0]
        self.assertTrue('geometry' in sample_school, "has property geometry")
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
        pass

    def test_api_school_info_badid(self):
        query_url = self.schools_base_url + "badidea" + "?geometry=yes"
        print "Testing school info API -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 404,
                         "school info status code is 404")

    def test_api_school_info_geometry(self):

        #schools_base_url = "/api/v1/schools/school/"
        query_url = self.schools_base_url + self.school_info_id + "/?geometry=yes"
        print "Testing school info API -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 200,
                         "school info status code is 200")
        data = json.loads(response.content)
        school_id = data['properties']['id']
        self.assertEqual(school_id, long(self.school_info_id), "school id is 33312")
        self.assertTrue('geometry' in data)

    def test_api_school_demographics(self):
        #schools_base_url = "/api/v1/schools/school/"
        query_url = self.schools_base_url + self.school_demographics_id + "/demographics"
        print "Testing school demographics API -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 200,
                         "school demographics status code is 200")
        data = json.loads(response.content)
        school_id = data['id']
        self.assertEqual(school_id, long(self.school_demographics_id), "school id is 33312")
        num_boys=data['num_boys']
        self.assertFalse('geometry' in data)
        self.assertTrue('num_boys' in data, "has a property called num_boys")
        #Assert that we have some value being returned for num_boys and it is not null
        self.assertTrue(num_boys > 0)
        self.assertTrue('num_girls' in data, "has a property called num_girls")
        self.assertTrue(data['num_girls'] > 0)

    def test_api_school_library(self):
        pass

    def test_api_school_library_geometry(self):
        pass

    def test_api_school_demographics_geometry(self):
        pass

        #How to pick a random school ID from the DB? Input from a properties file?
    def test_api_school_programmes(self):

        query_url = self.schools_base_url + self.school_programmes_id + "/programmes"
        print "Testing school programmes API -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 200,
                         "school programmes status code is 200")
        data = json.loads(response.content)
        school_id = data['id']
        self.assertEqual(school_id, long(self.school_programmes_id), "school id is 25139")
        self.assertTrue('name' in data, "has a property called name")

    def test_api_school_programmes_geometry(self):
        pass

    def test_api_school_finance(self):

        query_url = self.schools_base_url + self.school_finance_id + "/finance"

        print "Testing schools finance API -- " + query_url
        response=self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code,200,"school finance status code is 200")
        data = json.loads(response.content)
        self.assertEqual(data['id'],long(self.school_finance_id),"school id is 4708")
        self.assertTrue(data['classroom_count'] > 0)
        self.assertTrue(data['teacher_count'] > 0)
        self.assertTrue('tlm_expnd_dise' in data, "has a property called tlm_expnd_dise")
        self.assertTrue('tlm_recd_dise' in data, "has a property called tlm_recd_dise")
        self.assertTrue('sg_recd_dise' in data, "has a property called sg_recd_dise")
        # SS: Not sure I can assert the expenditure pieces because these may vary

    def test_api_school_finance_geometry(self):
        pass

    def test_api_school_infra(self):

        query_url = self.schools_base_url + self.school_infra_id + "/infrastructure"
        print "Testing schools infrastructure API -- " + query_url
        response=self.client.get(query_url)
        self.assertEqual(response.status_code,200,"school infra status code is 200")
        data = json.loads(response.content)
        self.assertEqual(data['id'],long(self.school_infra_id),"school id is " + self.school_infra_id)
        #self.assertEqual(data['name'],"GOVT LPS URDU SIRWAL","School name is GOVT LPS URDU SIRWAL")
        self.assertTrue(data['classroom_count'] > 0)
        self.assertTrue(data['teacher_count'] > 0)
        self.assertTrue('num_boys_dise' in data, "has a property called num_boys_dise")
        self.assertTrue('num_girls_dise' in data, "has a property called num_girls_dise")
        self.assertTrue('lowest_class' in data, "has a property called lowest_class")
        self.assertTrue('highest_class' in data, "has a property called highest_class")
        self.assertTrue('status' in data, "has a property called status")
        self.assertTrue('dise_books' in data, "has a property called dise_books")
        self.assertTrue('dise_rte' in data, "has a property called dise_rte")
        self.assertTrue('facilities' in data, "has a property called facilities")

    def test_api_school_infra_geometry(self):
        pass
