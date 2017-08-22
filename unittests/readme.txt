HOW TESTS WORK:
===============

To run the unit tests, cd into the "unittests" folder and do:

./runtests.sh

This script creates a test database -- a clone of the dev database -- and then runs all the unit tests against the clone. The actual dev database will be untouched. After running the tests, the test database will get deleted. So you should be left with a "clean" slate as far as tests are concerned. 

CONTINOUS INTEGRATION FOR DUBDUBDUB:
===================================

A continous integration server -- Jenkins -- has been set up @ ci.odisha.ilp.org.in. If you need access to this server, please contact Subha or Sanjay. Jenkins will monitor the GitHub develop branch for any commits. When a new commit is recorded, Jenkins will re-deploy the latest code from 'develop' onto dev.odisha.ilp.org.in. Then, unit tests will be run against this latest codebase. If the tests fail, e-mails will be sent out to the development group and the last person who committed code will have to fix the breakage.

For continous integration to work, we need to keep tests in sync with new development code.

BEST PRACTICES IN WRITING UNIT TESTS FOR DUBDUBDUB
==================================================
All unit tests and associated automation scripts are grouped under the "unittests" folder. The "unittests" folder has sub-folders for each major endpoint that has tests. For examples of how tests are laid out, check out test_users.py under the "users" folder.

Here are some general tips and guidelines in writing unit tests for dubdubdub:

1. Tests should be written alongside new development code to keep up. The OLP Jenkins server will be running all the unit tests whenever new code gets committed to develop. If anything breaks, e-mails will be sent to the dev team and it will be upto the dev who made the last commit to fix breakages. 
2. Each major endpoint has to be tested. Eg. schools, users, stories, volunteer activities etc..
3. Group tests for each endpoint in one test file. 
4. Convention followed for naming test files so far has been test_xxxx.py
5. Write negative tests along with regular tests to uncover bugs. Negative testing is probably much more crucial than positive, passing tests.
6. Add lots of prints in the test code so it makes sense to follow along from the console and identify what really broke.

