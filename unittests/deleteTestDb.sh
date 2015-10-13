#!/bin/bash
#Script to delete the test database. Takes the name of the test database as argument
# Check input args and exit if param not passed in
echo "Preparing to delete test database $1"
if [ $# -eq 0 ]; then
    echo "Please pass in the name of the test database as argument."
    exit 1
fi
#Check validity of argument passed in
if [ -z "$1" ]; then
    echo "Please supply a valid test database name."
    exit 2
fi
#Proceed with deletion
testDB=$1
echo "Deleting test database $testDB"
sudo -i -u postgres dropdb $testDB
exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Failure deleting the test DB $testDB. Please clean up before running tests again"
    exit $exit_status
else
    echo "Successfully deleted test database $testDB. Exiting.."
fi