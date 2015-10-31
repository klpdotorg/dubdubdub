import csv
import StringIO

from django.contrib import admin
from django.http import HttpResponse

from .models import State
from schools.models import School

class StateAdmin(admin.ModelAdmin):
    actions = ['download_csv']
    list_filter = ['date_of_visit', 'ivrs_type']

    def download_csv(self, request, queryset):
        ivrs_type = request.GET.get('ivrs_type', None)
        f = StringIO.StringIO()
        writer = csv.writer(f)
        writer.writerow(
            [
                "Sl. No",
                "School ID",
                "School name",
                "District",
                "Block",
                "Cluster",
                "Telephone",
                "Date Of Visit",
                "Invalid",
                "Was the school open?",
                "Class visited",
                "Was Math class happening on the day of your visit?",
                "Which chapter of the textbook was taught?",
                "Which Ganitha Kalika Andolana TLM was being used by teacher?",
                "Did you see children using the Ganitha Kalika Andolana TLM?",
                "Was group work happening in the class on the day of your visit?",
                "Were children using square line book during math class?",
                "Are all the toilets in the school functional?",
                "Does the school have a separate functional toilet for girls?",
                "Does the school have drinking water?",
                "Is a Mid Day Meal served in the school?"
            ]
        )
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
