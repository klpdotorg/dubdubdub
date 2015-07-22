from django.shortcuts import render
from common.views import StaticPageView
from django.views.generic.detail import DetailView
from schools.models import School
from models import Story, StoryImage

class IVRSPageView(StaticPageView):
    template_name = 'ivrs.html'


class SYSView(DetailView):
    template_name = 'sys_form.html'
    model = School

    def get_context_data(self, **kwargs):
        context = super(SYSView, self).get_context_data(**kwargs)
        school = context['object']
        context['school_type'] = 'school' if school.schooldetails.type.id == 1 else 'preschool' 
        context['total_verified_stories'] = Story.objects.filter(
                                            is_verified=True).count()
        context['total_images'] = StoryImage.objects.count()
        return context

    