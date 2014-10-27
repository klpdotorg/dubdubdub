from django.contrib import admin
from .models import School, Address, DiseInfo, Boundary


class SchoolAdmin(admin.ModelAdmin):
    search_fields = ('name', 'id',)
    raw_id_fields = ('admin3', 'address', 'dise_info')


class BoundaryAdmin(admin.ModelAdmin):
    search_fields = ('name',)
    list_display = ('__unicode__', 'hierarchy', 'type')


class DiseInfoAdmin(admin.ModelAdmin):
    search_fields = ('dise_code',)
    list_display = ('dise_code', 'school')

admin.site.register(School, SchoolAdmin)
admin.site.register(Boundary, BoundaryAdmin)
admin.site.register(DiseInfo, DiseInfoAdmin)
admin.site.register([Address])
