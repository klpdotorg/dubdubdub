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

#### CSS workflow:
1. Add a partial to assets/static/sass/dev and import it in assets/static/sass/style.scss. For example, see [assets/static/sass/dev/_sample.scss](https://github.com/klpdotorg/dubdubdub/blob/develop/assets/static/sass/dev/_sample.scss).

2. Run Sass before you commit the changes
    
    $ sass assets/static/sass/style.scss assets/static/css/style.css

#### Running unit tests

Unit tests are available for the schools and users endpoints. Below are instructions to run the unit tests available so far. 

Clone the development database:

sudo -u postgres createdb -T <existing_db_name> <test_db_name>

Create a local test_local_settings file by doing the following:

    $ cp dubdubdub/local_test_settings.py.sample dubdubdub/local_test_settings.py

Modify the database name in local_test_settings.py to reflect the name you gave to your test db.

Make sure the runtests.sh script has execute permissions. Then, run the shell script as follows to run the existing unit tests:

./runtests.sh

All the unit tests should pass.
