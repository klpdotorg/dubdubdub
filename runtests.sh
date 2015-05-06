#!/bin/sh
#This script runs all the existing unit tests for the users, schools and stories apps.
# You will need to create a "test" db by cloning the main databasee (eg. createdb -T klpwww_ver4 test_klpwww_ver4 )
#The name of the "test" DB should be entered in the dubdubdub/local_test_settings.py file. Please see those files for further instructions. 

#Read the local settings file and get the name of the DB. Used a python script to read the DB name from DJango settings.
# Maybe a better way of doing this?

mainDBName=$(python -m read_local_settings)
exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Failure to read settings file from django. Please check if settings file exists. Aborting unit tests"
    exit $exit_status
else
    echo "Database being used by app is $mainDBName"
fi

#Use the db name to create a clone
testDB="test_$mainDBName"
echo "Creating database $testDB as a clone of $mainDBName...."
sudo -i -u postgres createdb -T $mainDBName $testDB
exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Failure creating a test DB. Aborting unit tests"
    exit $exit_status
else
    echo "Created $testDB successfully..."
fi

# Start running the unit tests...

echo "Running schools related unit tests.."
python manage.py test schools.tests --settings dubdubdub.test_settings
echo "Done with schools unit tests ----------"
echo "Running users related unit tests..."
python manage.py test users.tests --settings dubdubdub.test_settings
echo "Done with users unit tests............."
echo "Running stories related unit tests"
python manage.py test stories --settings dubdubdub.test_settings
echo "Done with stories unit tests"

# Now, clean up the test database
echo "Deleting test database $testDB"
sudo -i -u postgres dropdb $testDB
exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Failure deleting the test DB $testDB. Please clean up before running tests again"
    exit $exit_status
else
    echo "Successfully deleted test database $testDB. Exiting.."
fi