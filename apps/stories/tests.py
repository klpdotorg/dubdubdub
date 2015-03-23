from django.test import TestCase
from django.test import Client
from django.conf import settings
import unittest
import json
import csv


class StoriesApiTestCase(TestCase):

    stories_base_url = "/api/v1/stories/"

    def setUp(self):
        self.client = Client()
        self.schools_lib_id = settings.TESTS_STORIES_INPUT['SCHOOLS_TEST_ID1']

    def testGetStoryForSchoolId(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id
        print "Testing get story for school ID -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        print response
        self.assertEqual(response.status_code, 200,
                         "schools stories status code is 200")
        results = json.loads(response.content)
        print results
        if results['count'] > 0:
            print "Stories exist for this school"
            sample_school = results['features'][0]
            self.assertTrue('id' in sample_school,
                            "has no a property called id")
            self.assertTrue('name' in sample_school,
                            "has no a property called name")
            self.assertTrue('date' in sample_school, "has no property called date")
            self.assertTrue('date_of_visit' in sample_school, "has no property called date_of_visit")
            self.assertTrue('school' in sample_school, "has no school id")
            self.assertTrue('school_name' in sample_school, "has no school name")
            self.assertTrue('school_url' in sample_school, "has no school URL")
            self.assertTrue('is_verified' in sample_school, "has no verified field")
        else:
            print "No stories exist for this school"

    # This test exercises getting only verified stories for a schoo. Should NOT return is_verified=false stories.
    def testGetVerifiedStories(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id + "&verified=yes"
        print "Testing verified stories for school ID -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        #print response
        self.assertEqual(response.status_code, 200,
                         "schools stories status code is 200")
        results = json.loads(response.content)
        #print results
        for x in range(0,results['count']):
            sample_school = results['features'][x]
            print sample_school['is_verified']
            self.assertEqual(sample_school['is_verified'],True)
    
    # This test exercises getting only unverified stories for a school.
    # Results should not contain verified stories.
    def testGetUnverifiedStories(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id + "&verified=no"
        print "Testing unverified stories for school ID -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        #print response
        self.assertEqual(response.status_code, 200,
                         "schools stories status code is 200")
        results = json.loads(response.content)
        print "Number of unverified stories:" + str(results['count'])
        for x in range(0,results['count']):
            sample_school = results['features'][x]
            print sample_school['is_verified']
            self.assertEqual(sample_school['is_verified'],False)

    def testValidateUrlParamVerified(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id + "&verified=somethingbluw"
        print "Testing invalid param for stories for school ID -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        #print response
        self.assertNotEqual(response.status_code, 200,
                         "Shoud return a 400 application error in case of invalid param")

    def testGetAnswersForSchool(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id + "&answers=yes"
        print "Testing getting answers for school ID -- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        #print response
        self.assertEqual(response.status_code, 200,
                         "schools answers status code is 200")
        results = json.loads(response.content)
        sample_school = results['features'][0]
        self.assertTrue('answers' in sample_school, "has no property called answers")

    # Would be better if error is returned in case invalid params are entered for answers.
    def testGetAnswersForSchool2(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id + "&answers=no"
        print "Checking parameter validation for answers param-- " + query_url
        response = self.client.get(query_url)
        print response.status_code
        #print response
        self.assertEqual(response.status_code, 200,
                         "schools answers status code is 200")
        results = json.loads(response.content)
        sample_school = results['features'][0]
        self.assertFalse('answers' in sample_school, "has no property called answers")

    def testAnswersUrlParamVerified(self):
        query_url = self.stories_base_url + "?school_id=" + self.schools_lib_id + "&answers=something"
        response = self.client.get(query_url)
        self.assertEqual(response.status_code, 400,
                         "schools answers invalid param status code is 400")

    def testStoriesInformation(self):
        query_url=self.stories_base_url + "info/"
        print "Testing stories meta info..."
        response=self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 200, "stories meta info is 200")
        results=json.loads(response.content)
        self.assertTrue('total_verified_stories' in results, "Has no property called total_verified_stories")
        self.assertTrue('total_stories' in results, "has no property called total_stories")
        self.assertTrue('total_images' in results, "has no property called total_images") 

    def testStoriesMetaDataFail1(self):

        query_url=self.stories_base_url + "meta/?source=web"
        print "Testing stories meta data..." + query_url
        response=self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 500, "Need school type")
        
    def testStoriesMetaDataPrimary(self):
        schoolType="Primary School"
        query_url=self.stories_base_url + "meta/?source=web&school_type="+schoolType
        print "Testing stories meta data..." + query_url
        response=self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 200, "Need school type")
        results=json.loads(response.content)
        self.assertTrue('school_type' in results, "Has no property called school_type")
        self.assertTrue('total_responses' in results, "Has no property called total_responses")
        self.assertTrue('responses_yesterday' in results, "has no property called responses_yesterday")
        self.assertTrue('per_month_responses' in results, "has no property called per_month_responses")
        self.assertTrue('questions' in results, "has no property questions")       
        self.assertEqual(results['school_type'],schoolType)

    def testStoriesMetaDataPreschool(self):
        schoolType="Preschool"
        query_url=self.stories_base_url + "meta/?source=web&school_type="+schoolType
        print "Testing stories meta data..." + query_url
        response=self.client.get(query_url)
        print response.status_code
        self.assertEqual(response.status_code, 200, "Need school type")
        results=json.loads(response.content)
        self.assertTrue('school_type' in results, "Has no property called school_type")
        self.assertTrue('total_responses' in results, "Has no property called total_responses")
        self.assertTrue('responses_yesterday' in results, "has no property called responses_yesterday")
        self.assertTrue('per_month_responses' in results, "has no property called per_month_responses")
        self.assertTrue('questions' in results, "has no property questions")       
        self.assertEqual(results['school_type'],schoolType)
    
    def tearDown(self):
        pass
        

