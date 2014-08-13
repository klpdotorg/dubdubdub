#!/bin/sh
#This script runs all the existing unit tests for the users and schools apps. Expects a file called test_settings.py and test_local_settings.py
# in the apps/users/tests directory. The "users" tests require insertions into the DB. Hence, it is recommended that a separate test
# DB be created by cloning the development DB. The following command to be run:
# CREATE DATABASE newdb WITH TEMPLATE originaldb; as the postgres user from the command line.
#The name of the "test" DB should be entered in the test_local_settings.py file. Please see those files for further instructions. 

FILE="apps/users/tests/test_local_settings.py"
if [ -f $FILE ];
then
    echo "File $FILE exists"
else
    echo "File $FILE does not exist. Please create this file by copying from test_local_settings.py.sample and update the DB name in the file."
    exit 1 
fi
echo "Running schools related unit tests.."
python manage.py test schools.tests
echo "Done with schools unit tests ----------"
echo "Running users related unit tests..."
python manage.py test users.tests --settings users.tests.test_settings
echo "Done with users unit tests............."