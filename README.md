dubdubdub
=========

Home of OLP. Houses *most* of the data and APIs that powers the features on the home page and reports.

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

When developing locally, add the following line to local_settings.py to output emails to console and not attempt to actually send them:

    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

#### Run:

    $ runserver

and go to `http://localhost:8001`

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

#### Skipping DB creation when unit tests execute

The unit test script creates a test database and then executes tests against it. To skip creation of a database and leverage existing ones, run the script like so:

    ./runtests.sh skipdbcreate

The DB to use should be updated in the test_settings file.

### Populating local db with production dump

1. Copy the latest backup from the production server onto your machine.
 - `rsync -azP -e "ssh -p 2020" <your_username>@odisha.ilp.org.in:/home/vamsee/backups/db/dubdubdub/<backup_file_name>.gz .`
 - On the production server, you can find the backup files at `/home/vamsee/backups/db/dubdubdub/`.

2. Uncompress the downloaded file.
 - `gunzip <backup_file_name>.gz`

3. Drop the dubdubdub db on your local machine.
 - `dropdb dubdubdub`

4. Create a new dubdubdub db.
 - `createdb -U klp dubdubdub`

5. Copy the db dump you downloaded into the project root folder (the place where you Vagrantfile resides). # Not necessarily

6. Use pg_restore to populate your local db with the dump.
 - `pg_restore -U klp -h localhost -d dubdubdub <backup_file_name>`

7. Create the materialized views.
 - `psql -h localhost -U klp -d dubdubdub -f sql/materialized_views.sql`


#### Database refresh of dubdubub

1. The exported ems csv is put inside `data/ems/` directory
2. run `./imports/importdatatodb.sh -d <dbname>`
3. run `./imports/importdatafromdb.sh -d <dbname>`
4. run `./imports/post-import.sh -d <dbname>`
