from django.contrib import admin

from .models import (Organization, User, UserOrganization, VolunteerActivityType,
    DonationItemCategory, VolunteerActivity, UserVolunteerActivity)

class UserOrganizationInline(admin.TabularInline):
    model = UserOrganization
    extra = 1

class OrganizationAdmin(admin.ModelAdmin):
    inlines = (UserOrganizationInline,)



class UserAdmin(admin.ModelAdmin):
    search_fields = ('email', 'first_name', 'last_name')
    list_display = ('__unicode__', 'is_email_verified',)
    actions = ['mark_email_verified']
    #list_editable = ('is_email_verified',)
    
    def mark_email_verified(self, request, queryset):
        rows_updated = queryset.update(is_email_verified=True)
        if rows_updated == 1:
            user_string = 'user'
        else:
            user_string = 'users'
        message = "%s %s were marked as verified" % (rows_updated, user_string,)
        self.message_user(request, message)

    mark_email_verified.short_description = "Mark selected users as verified"




admin.site.register(Organization, OrganizationAdmin)
admin.site.register(User, UserAdmin)
admin.site.register([VolunteerActivityType, VolunteerActivity, UserVolunteerActivity])
admin.site.register(DonationItemCategory)
