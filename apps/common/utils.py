from django.http import HttpResponse
import json
from django.core.mail import EmailMultiAlternatives
from django.template.loader import get_template
from django.template import Context


def send_templated_mail(from_email, to_emails, subject, template_name, context=None):
    plaintext = get_template(template_name + '.txt')
    htmly = get_template(template_name + '.html')

    con = Context(context)

    text_content = plaintext.render(con)
    html_content = htmly.render(con)
    msg = EmailMultiAlternatives(subject, text_content, from_email, to_emails)
    msg.attach_alternative(html_content, "text/html")
    msg.send()

def render_to_json_response(obj, status=200):
    return HttpResponse(json.dumps(obj), content_type='application/json',
                        status=status)
