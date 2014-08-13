dubdubdub
=========

Home of KLP. Houses *most* of the data and APIs that powers the features on the home page and reports.

### Development Setup

We use Vagrant for development. Here's everything you need to know about setting up dubdubdub for development.

#### Install Vagrant
1. [Download for Ubuntu](https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.1_x86_64.deb)
2. [Download for OS X](https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.1.dmg)

#### Install Virtualbox
1. Ubuntu

        $ wget http://download.virtualbox.org/virtualbox/4.3.4/virtualbox-4.3_4.3.4-91027~Ubuntu~raring_amd64.deb
        $ sudo dpkg -i virtualbox-4.3_4.3.4-91027~Ubuntu~raring_amd64.deb

2. [Download for OS X](http://download.virtualbox.org/virtualbox/4.3.8/VirtualBox-4.3.8-92456-OSX.dmg)

#### Clone the code

    git clone git@github.com:klpdotorg/dubdubdub.git

#### Setup Vagrant

    $ vagrant up
    $ vagrant ssh

#### Copy Local settings file

    $ cp dubdubdub/local_settings.py{.sample,}

#### Run:

    $ runserver

and go to `http://localhost:8001`

#### Running unit tests

Unit tests are available for the schools and users endpoints. Below are instructions to run the unit tests available so far. 

NOTE: Schools endpoint performs read-only operations. Hence, these tests can be run against an existing development DB. However, the users endpoint performs insertions/deletions from the DB. Hence it is highly recommended that the development DB be cloned and the separate test DB be used for the users tests.

Clone the development database:

CREATE DATABASE newdb WITH TEMPLATE originaldb; as the postgres user from the command line.

Create a local test_local_settings file by doing the following:

    $ cp dubdubdub/apps/users/tests/tests_local_settings.py{.sample}

Note that the tests_local_settings.py file has to be inside the apps/users/tests directory. Modify the test DB name (created in the cloning step above) in the test_local_settings.py as appropriate. Otherwise, tests will fail.

Make sure the runtests.sh script has execute permissions. Then, run the shell script as follows to run the existing unit tests:

./runtests.sh

All the unit tests should pass.
