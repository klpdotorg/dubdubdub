from django import http
try:
    import json
except:
    import simplejson as json

from django.views.generic.base import View, TemplateView
from django.core.exceptions import PermissionDenied

class JSONResponseMixin(object):
    def render_to_response(self, context, status=200):
        "Returns a JSON response containing 'context' as payload"
        return self.get_json_response(self.convert_context_to_json(context), status)

    def get_json_response(self, content, status=200, **httpresponse_kwargs):
        "Construct an `HttpResponse` object."
        return http.HttpResponse(content,
                                 status=status,
                                 content_type='application/json',
                                 **httpresponse_kwargs)

    def convert_context_to_json(self, context):
        "Convert the context dictionary into a JSON object"
        # Note: This is *EXTREMELY* naive; in reality, you'll need
        # to do much more complex handling to ensure that arbitrary
        # objects -- such as Django model instances or querysets
        # -- can be serialized as JSON.
        return json.dumps(context)


class StaticPageView(TemplateView):
    extra_context = {}

    def get_context_data(self, **kwargs):
        context = super(StaticPageView, self).get_context_data(**kwargs)
        context.update(self.extra_context)
        return context


class APIView(View, JSONResponseMixin):
    def get(self, *args, **kwargs):
        raise PermissionDenied('Not Permitted')

    def post(self, *args, **kwargs):
        raise PermissionDenied('Not Permitted')