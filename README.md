dubdubdub
=========

Home of KLP. Houses *most* of the data and APIs that powers the features on the home page and reports.

### Development Setup

We use Vagrant for development. Here's everything you need to know about setting up dubdubdub for development.

#### Install Vagrant

[Vagrant Downloads](https://www.vagrantup.com/downloads.html)

#### Install Virtualbox

[Virtualbox Download](https://www.virtualbox.org/wiki/Downloads)

(Please note it's recommended to use the virtualbox supplied by your package manager if you're running Linux)

#### Clone the code

    git clone git@github.com:klpdotorg/dubdubdub.git

#### Setup Vagrant

    $ vagrant up

(The above step will also provision the dev environment when it's running for the first time.)

    $ vagrant ssh

#### Run:

    $ runserver

and go to `http://localhost:8088`

#### CSS workflow:

1. Add a partial to assets/static/sass/dev and import it in assets/static/sass/style.scss. For example, see [assets/static/sass/dev/_sample.scss](https://github.com/klpdotorg/dubdubdub/blob/develop/assets/static/sass/dev/_sample.scss).

2. Run Sass before you commit the changes

    $ sass assets/static/sass/style.scss assets/static/css/style.css

3. Alternately, you can simply watch and compile the Sass outside vagrant by running this command:
sass --watch assets/static/sass/style.scss:assets/static/css/style.css

#### Running unit tests

Unit tests are available for the schools and users endpoints. Below are instructions to run the unit tests available so far. 

Clone the development database:

sudo -u postgres createdb -T existing_db_name test_db_name

All test settings are in the test_settings.py file.

Modify the database name in test_settings.py to reflect the name you gave to your test db.

Make sure the runtests.sh script has execute permissions. Then, run the shell script as follows to run the existing unit tests:

./runtests.sh

All the unit tests should pass.
