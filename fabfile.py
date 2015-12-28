from fabric.api import *
from fabric.contrib.files import *

env.use_ssh_config = True


def test():
    run('uname -a')


def dev():
    env.hosts = ['dev.klp.org.in']
    env.project_path = '/var/www/dubdubdub/'
    env.venv_path = '/home/dubdubdub/dubdubdub/'
    env.git_branch = 'develop'


def production():
    env.hosts = ['klp.org.in']
    env.project_path = '/var/www/dubdubdub/'
    env.venv_path = '/home/dubdubdub/dubdubdub/'
    env.git_branch = 'master'


def git(command='status'):
    with cd(env.project_path):
        sudo('git {}'.format(command), user='dubdubdub')


def git_pull(branch):
    with cd(env.project_path):
        sudo('git pull origin {}'.format(branch), user='dubdubdub')


def git_checkout(branch):
    with cd(env.project_path):
        sudo('git checkout {}'.format(branch), user='dubdubdub')


def run_mview():
    with cd(env.project_path):
        with prefix('source {venv_path}bin/activate'.format(venv_path=env.venv_path)):
            sudo('psql -d testassessments < sql/materialized_views.sql', user='postgres')


def pip_install_packages():
    with cd(env.project_path):
        with prefix('source {venv_path}bin/activate'.format(venv_path=env.venv_path)):
            sudo('pip install -r requirements.txt', user='dubdubdub')


def migrate_all():
    with cd(env.project_path):
        with prefix('source {venv_path}bin/activate'.format(venv_path=env.venv_path)):
            run('python manage.py migrate')


def apache_reload():
    sudo('service apache2 reload')


def collectstatic():
    with cd(env.project_path):
        with prefix('source {venv_path}bin/activate'.format(venv_path=env.venv_path)):
            sudo('python manage.py collectstatic --noinput', user='dubdubdub')


def deploy(pip_install=False, migrate=False, mview=False):
    # Use any of the commands

    # fab dev deploy
    # fab dev deploy:migrate=True
    # fab dev deploy:pip_install=True
    # fab dev deploy:pip_install=True,migrate=True
    # fab dev deploy:pip_install=True,migrate=True,mview=True

    git_pull(env.git_branch)

    if pip_install:
        pip_install_packages()

    if migrate:
        migrate_all()

    if mview:
        run_mview()

    collectstatic()
    apache_reload()
