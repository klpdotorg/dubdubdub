from django.contrib import admin

from .models import (Organization, User, UserOrganization, VolunteerActivityType,
    DonationItemCategory, VolunteerActivity, UserVolunteerActivity)

class UserOrganizationInline(admin.TabularInline):
    model = UserOrganization
    extra = 1

class OrganizationAdmin(admin.ModelAdmin):
    inlines = (UserOrganizationInline,)

admin.site.register(Organization, OrganizationAdmin)
admin.site.register(User)
admin.site.register([VolunteerActivityType, VolunteerActivity, UserVolunteerActivity])
admin.site.register(DonationItemCategory)
