from django.shortcuts import render
from common.views import StaticPageView

class IVRSPageView(StaticPageView):
    template_name = 'ivrs.html'
    