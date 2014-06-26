from rest_framework_gis.filters import InBBOXFilter


class KLPInBBOXFilter(InBBOXFilter):
    bbox_param = 'bbox'
