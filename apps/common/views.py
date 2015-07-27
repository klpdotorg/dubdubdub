from django import http
from django.views.generic.base import TemplateView
from django.core.exceptions import PermissionDenied
from common.pagination import KLPPaginationSerializer
from rest_framework import generics
from rest_framework.views import APIView
from rest_framework.response import Response
from common.filters import KLPInBBOXFilter


class StaticPageView(TemplateView):
    extra_context = {}

    def get_context_data(self, **kwargs):
        context = super(StaticPageView, self).get_context_data(**kwargs)
        context.update(self.extra_context)
        return context


class KLPAPIView(APIView):
    pass


class KLPListAPIView(generics.ListAPIView):

    pagination_serializer_class = KLPPaginationSerializer

    def __init__(self, *args, **kwargs):
        super(KLPListAPIView, self).__init__(*args, **kwargs)
        if hasattr(self, 'bbox_filter_field') and self.bbox_filter_field and KLPInBBOXFilter not in self.filter_backends:
            self.filter_backends += (KLPInBBOXFilter,)

    def finalize_response(self, *args, **kwargs):
        '''
            For CSV requests, this sets the Content-Disposition header
        '''
        response = super(KLPListAPIView, self).finalize_response(*args,
                                                                 **kwargs)
        if self.request.accepted_renderer.format == 'csv':

            #FIXME, better way to get filename?
            filename = self.request.path.split("/")[-1] + ".csv"
            response['Content-Disposition'] = \
                'attachment; filename="%s"' % filename
        return response

    def get_paginate_by(self, *args, **kwargs):
        '''
            If per_page = 0, don't paginate.
            If format == csv, don't paginate.
        '''
        if self.request.accepted_renderer.format == 'csv':
            return None

        #FIXME: Number should come from settings
        per_page = int(self.request.GET.get('per_page', 50))
        if per_page == 0:
            return None
        return per_page


class KLPDetailAPIView(generics.RetrieveAPIView):
    pass


class URLConfigView(APIView):
    def get(self, *args, **kwargs):
        from dubdubdub.api_urls import urlpatterns

        ALLOWED_PATTERNS = (
            'api_merge', 'api_school_info', 'api_donationuser_view'
        )

        patterns = []
        for pattern in urlpatterns:
            if pattern.name in ALLOWED_PATTERNS:
                patterns.append(dict(name=pattern.name, pattern=pattern.regex.pattern))

        return Response(dict(patterns=patterns))
