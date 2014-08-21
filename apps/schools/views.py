#page views go here. For API views, use api_views.py
from django.views.generic.detail import DetailView
from .models import School


class SchoolPageView(DetailView):
    model = School
    template_name = 'school.html'
