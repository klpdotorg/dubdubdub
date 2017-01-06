#!/bin/bash
# Script usage: runtests.sh <Optional createDB: false>
# Example: To use existing test DB and not create a new one, use ./runtests.sh skipdbcreate
#This script runs all the existing unit tests for the users, schools and stories apps.
# You will need to create a "test" db by cloning the main databasee (eg. createdb -T klpwww_ver4 test_klpwww_ver4 )
#The name of the "test" DB should be entered in the dubdubdub/local_test_settings.py file. Please see those files for further instructions. 


# Create the test database from the dev DB

#Read the local settings file and get the name of the DB. Used a python script to read the DB name from DJango settings.
# Maybe a better way of doing this?
CREATE_DB=true

if [ $# -eq 1 ]; then
    echo $1
    CREATE_DB=$1
fi

# Call script to create test database if CREATE_DB is true

if [ "$CREATE_DB" == "true" ]; then
    testDB=''
    source createTestDb.sh
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
        exit $exit_status
    fi
fi

# Start running the unit tests...

cd ..
echo "Running schools related unit tests.."
python manage.py test unittests.schools --settings dubdubdub.test_settings
echo "Done with schools unit tests ----------"
echo "Running users related unit tests..."
python manage.py test unittests.users --settings dubdubdub.test_settings
echo "Done with users unit tests............."
echo "Running stories related unit tests"
python manage.py test unittests.stories --settings dubdubdub.test_settings
echo "Done with stories unit tests"
echo "Running ivrs related unit tests..."
python manage.py test unittests.ivrs --settings dubdubdub.test_settings
echo "Done with ivrs unit tests"

# Now, clean up the test database (if it was created at all in the first place)
if [ "$CREATE_DB" == "true" ]; then
    source unittests/deleteTestDb.sh $testDB
fi
