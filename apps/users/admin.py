from django.contrib import admin

from .models import Organization, User, UserOrganization

class UserOrganizationInline(admin.TabularInline):
    model = UserOrganization
    extra = 1

class OrganizationAdmin(admin.ModelAdmin):
    inlines = (UserOrganizationInline,)

admin.site.register(Organization, OrganizationAdmin)
admin.site.register(User)
