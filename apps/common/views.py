from django import http
from django.views.generic.base import TemplateView
from django.core.exceptions import PermissionDenied
from common.exceptions import APIError
from common.pagination import KLPPaginationSerializer
from rest_framework import generics
from common.filters import KLPInBBOXFilter


class StaticPageView(TemplateView):
    extra_context = {}

    def get_context_data(self, **kwargs):
        context = super(StaticPageView, self).get_context_data(**kwargs)
        context.update(self.extra_context)
        return context


class KLPListAPIView(generics.ListAPIView):

    pagination_serializer_class = KLPPaginationSerializer
    filter_backends = (KLPInBBOXFilter,)


    def finalize_response(self, *args, **kwargs):
        '''
            For CSV requests, this sets the Content-Disposition header
        '''
        response = super(KLPListAPIView, self).finalize_response(*args, **kwargs)
        if self.request.accepted_renderer.format == 'csv':
            filename = self.request.path.split("/")[-1] + ".csv" #FIXME, better way to get filename?
            response['Content-Disposition'] = 'attachment; filename="%s"' % filename
        return response

    def get_paginate_by(self, *args, **kwargs):
        '''
            If per_page = 0, don't paginate.
            If format == csv, don't paginate.
        '''
        if self.request.accepted_renderer.format == 'csv':
            return None
        per_page = int(self.request.GET.get('per_page', 50)) #FIXME: Number should come from settings
        if per_page == 0:
            return None
        return per_page


class KLPDetailAPIView(generics.RetrieveAPIView):
    pass