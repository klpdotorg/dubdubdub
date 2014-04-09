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
