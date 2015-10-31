import csv
import StringIO

from django.contrib import admin
from django.http import HttpResponse

from .models import State
from schools.models import School
from stories.models import Questiongroup, Source


class StateAdmin(admin.ModelAdmin):
    actions = ['download_csv']
    list_filter = ['date_of_visit', 'ivrs_type']

    def download_csv(self, request, queryset):
        source = Source.objects.get(name='ivrs')

        f = StringIO.StringIO()
        writer = csv.writer(f)
        headers = [
            "Sl. No",
            "School ID",
            "School name",
            "District",
            "Block",
            "Cluster",
            "Telephone",
            "Date Of Visit",
            "Invalid",
        ]

        ivrs_type = request.GET.get('ivrs_type', None)

        if ivrs_type == 'gka':
            question_group = Questiongroup.objects.get(
                version=2,
                source=source
            )
        elif ivrs_type == 'ivrs-pri':
            question_group = Questiongroup.objects.get(
                version=3,
                source=source
            )
        elif ivrs_type == 'gka-new':
            question_group = Questiongroup.objects.get(
                version=4,
                source=source
            )
        else: # ivrs_type = 'ivrs-pre'
            question_group = Questiongroup.objects.get(
                version=5,
                source=source
            )

        questions = question_group.questions.all().values_list(
            'text',
            flat=True
        ).order_by(
            'questiongroupquestions__sequence'
        )
        questions = list(questions) # Converting the Queryset into a list.
        writer.writerow(headers + questions)

        for (number, state) in enumerate(queryset):
            try:
                school = School.objects.get(id=state.school_id)
                district = school.admin3.parent.parent.name.replace(',', '-')
                block = school.admin3.parent.name.replace(',', '-')
                cluster = school.admin3.name.replace(',', '-')
                school_name = school.name.replace(',', '-')
            except:
                school_name = district = block = cluster = None

            values = [str(number + 1),
                      str(state.school_id),
                      str(school_name),
                      str(district),
                      str(block),
                      str(cluster),
                      str(state.telephone),
                      str(state.date_of_visit.date()),
                      str(state.is_invalid)
            ]
            writer.writerow(values + [answer for answer in state.answers[1:]])

        f.seek(0)
        response = HttpResponse(f, content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename=ivrs-data.csv'
        return response

    def get_actions(self, request):
        actions = super(StateAdmin, self).get_actions(request)
        del actions['delete_selected']
        return actions


admin.site.register(State, StateAdmin)
