import json
import datetime
import os
from django.utils import timezone
from django.http import HttpResponse
from django.core.mail import EmailMultiAlternatives
from django.template.loader import get_template
from django.template import Context
from django.conf import settings


def send_templated_mail(from_email, to_emails, subject, template_name, context=None):
    plaintext = get_template('email_templates/{}.txt'.format(template_name))
    htmly = get_template('email_templates/{}.html'.format(template_name))

    con = Context(context)

    text_content = plaintext.render(con)
    html_content = htmly.render(con)
    msg = EmailMultiAlternatives(subject, text_content, from_email, to_emails)
    msg.attach_alternative(html_content, "text/html")
    msg.send()


def render_to_json_response(obj, status=200):
    return HttpResponse(json.dumps(obj), content_type='application/json',
                        status=status)


class cached_property(object):
    """ A property that is only computed once per instance and then replaces
        itself with an ordinary attribute. Deleting the attribute resets the
        property.

        Source: https://github.com/bottlepy/bottle/commit/fa7733e075da0d790d809aa3d2f53071897e6f76
        """

    def __init__(self, func):
        self.__doc__ = getattr(func, '__doc__')
        self.func = func

    def __get__(self, obj, cls):
        if obj is None:
            return self
        value = obj.__dict__[self.func.__name__] = self.func(obj)
        return value

def get_logfile_path(name, ext):
    """
        Returns a full log-file path given a name and a file extension 
    """
    #Create log folder if does not exist
    if not os.path.exists(settings.LOGS_FOLDER):
        os.mkdir(settings.LOGS_FOLDER)
    base_path = os.path.join(settings.LOGS_FOLDER, name)
    datestamp = datetime.datetime.now().strftime("%Y-%m-%d-%s")
    filename = "%s_%s.%s" % (base_path, datestamp, ext,)
    return filename

class Date(object):
    """
    A class with helper functions for checking and retrieving datetime objects.
    """

    def get_datetime(self, date):
        return datetime.datetime.strptime(date, '%Y-%m-%d')

    def check_date_sanity(self, date):
        try:
            year = date.split("-")[0]
            month = date.split("-")[1]
            day = date.split("-")[2]
        except:
            return False

        if not self.is_day_correct(day):
            return False

        if not self.is_month_correct(month):
            return False

        if not self.is_year_correct(year):
            return False

        return True

    def is_day_correct(self, day):
        return int(day) in range(1,32)

    def is_month_correct(self, month):
        return int(month) in range(1,13)

    def is_year_correct(self, year):
        return (len(year) == 4 and int(year) <= timezone.now().year)
