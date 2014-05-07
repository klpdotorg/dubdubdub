from django.utils import unittest
from django.test import TestCase
from django.test.client import Client
import json

class ApiTestCase(unittest.TestCase):
   
    def setUp(self):
        self.c = Client()
 
    def test_passing_test(self):
        x = 2
        self.assertEquals(x, 2, "2 is equal to 2")
   
    def test_api_schools(self):
        response = self.c.get("/api/v1/schools/list?bounds=77.54537736775214,12.950457093960514,77.61934126017755,13.022529216896507")
        self.assertEqual(response.status_code, 200, "schools api status code is 200")
        results = json.loads(response.content)
        self.assertTrue(len(results['features']) > 50, "got more than 50 schools")
