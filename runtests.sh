#!/bin/sh
#This script runs all the existing unit tests for the users, schools and stories apps.
# You will need to create a "test" db by cloning the main databasee (eg. createdb -T klpwww_ver4 test_klpwww_ver4 )
#The name of the "test" DB should be entered in the dubdubdub/local_test_settings.py file. Please see those files for further instructions. 

echo "Running schools related unit tests.."
python manage.py test schools.tests --settings dubdubdub.test_settings
echo "Done with schools unit tests ----------"
echo "Running users related unit tests..."
python manage.py test users.tests --settings dubdubdub.test_settings
echo "Done with users unit tests............."
echo "Running stories related unit tests"
python manage.py test stories --settings dubdubdub.test_settings
echo "Done with stories unit tests"
