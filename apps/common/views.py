from django import http
try:
    import json
except:
    import simplejson as json
import csv
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


class CSVResponseMixin(object):

    def render_json_to_csv(self, json, status=200):
        header_row, csv_data = self._convert_json_csv(json)
        return self.render_to_csv_response(header_row, csv_data, status=status)

    def render_geojson_to_csv(self, geojson, status=200):
        "converts a geojson object to csv"
        header_row, csv_data = self._convert_geojson_to_csv(geojson)
        return self.render_to_csv_response(header_row, csv_data, status=status)

    def render_to_csv_response(self, csv_header_row, csv_data, filename="csv_data.csv", extra_http_headers=[], status=200):
        "render csv response"
        response = http.HttpResponse(content_type="text/csv", status=status)
        response['Content-Disposition'] = 'attachment; filename="%s"' % filename
        writer = csv.writer(response)
        writer.writerow(csv_header_row)
        for row in csv_data:
            writer.writerow(row)
        return response


    def _convert_geojson_to_csv(self, geojson):
        "convert geojson obj to csv"
        header_row = []
        data_arr = []
        features = geojson['features']
        #FIXME: if len(features) == 0, raise error
        property_keys = features[0]['properties'].keys()
        header_row = property_keys + ['geometry']
        for f in features:
            row = f['properties'].values()
            row = row + [json.dumps(f['geometry'])]
            data_arr.append(row)
        return (header_row, data_arr,)


    def _convert_json_to_csv(self, json):
        '''
        convert regular json array to csv
        QUESTION: this seems a bit awkward, its not json really, its a list of dicts.
        '''
        #FIXME: if not a list, raise error
        obj = json[0]
        header_row = obj.keys()
        data_arr = [d.values() for d in json]
        return (header_row, data_arr,)


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