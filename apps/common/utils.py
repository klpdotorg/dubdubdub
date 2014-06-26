from django.http import HttpResponse
import json


def render_to_json_response(obj, status=200):
    return HttpResponse(json.dumps(obj), content_type='application/json',
                        status=status)
