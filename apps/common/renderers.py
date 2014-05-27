from rest_framework.renderers import JSONRenderer
from rest_framework_csv.renderers import CSVRenderer

class KLPJSONRenderer(JSONRenderer):
    
    media_type = 'application/json'
    format = 'json'

    def render(self, data, media_type=None, renderer_context=None):

        #figure out whether we need to render geometry based on GET param
        render_geometry = renderer_context['request'].GET.get('geometry', 'no')
        if render_geometry == 'yes':
            self.render_geometry = True
        else:
            self.render_geometry = False

        #if geometry=yes and results are a list, convert to geojson
        if self.render_geometry and data.has_key('features') and isinstance(data['features'], list):
            data['type'] = 'FeatureCollection'
            features = data.pop('features')
            data['features'] = [self.get_feature(elem) for elem in features]
 
        #if geometry=yes and is a single feature, convert data to geojson
        elif self.render_geometry:
            data = self.get_feature(data)

        #err, bad code
        else:
            data = data #FIXME: haha, if we dont need to do anything here, just make previous elif an else.

        return super(KLPJSONRenderer, self).render(data, media_type, renderer_context)

    def get_feature(self, data):
        #this should never be called if geometry=no
        if 'geometry' not in data:
            raise Exception("no geometry even though geometry=yes, wut?")
        #convert flat dict representation to geojson for the feature
        geometry = data.pop('geometry')
        feature = {
            'type': 'Feature',
            'geometry': geometry,
            'properties': data
        }
        return feature


class KLPCSVRenderer(CSVRenderer):
    pass

