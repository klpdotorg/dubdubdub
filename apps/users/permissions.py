from rest_framework import permissions
from rest_framework.exceptions import APIException
from .models import Organization


class UserListPermission(permissions.BasePermission):
    '''
        Permission class for whether user can see a list of
        all user and create new users.
        Only superusers can see a list of users
        Anyone can create a new user (signup)
    '''

    def has_permission(self, request, view):
        if request.method == 'POST':
            return True
        if request.method == 'GET':
            if request.user.is_superuser:
                return True
            else:
                return False
        return False


class IsAdminOrIsSelf(permissions.BasePermission):
    '''
        Permission class for user profile editing funcs
        Checks whether user is superuser or the same user as being edited
    '''

    def has_object_permission(self, request, view, obj):
        return request.user == obj or request.user.is_superuser


class OrganizationsPermission(permissions.BasePermission):
    '''
        Permission class to check whether user can create new organizations
        Only superusers can create new organizations
        Anyone can see the list of organizations
    '''

    def has_permission(self, request, view):
        if request.method == 'POST':
            if request.user.is_superuser is True:
                return True
            else:
                return False
        return True


class OrganizationPermission(permissions.BasePermission):
    '''
        Permission class to check if user has permissions to view / edit
        an organization instance
        Calls has_read_perms and has_write_perms methods on Organization model
    '''

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            return obj.has_read_perms(user)
        else:
            return obj.has_write_perms(user)


class OrganizationUsersPermission(permissions.BasePermission):
    '''
        Permission class to check if user has permissions
        to view / edit users of an organization
    '''
    def has_permission(self, request, view):
        org_id = view.kwargs['org_pk']
        org = Organization.objects.get(pk=org_id)
        if request.method in permissions.SAFE_METHODS:
            return org.has_read_perms(request.user)
        else:
            return org.has_write_perms(request.user)


class VolunteerActivitiesPermission(permissions.BasePermission):

    def has_permission(self, request, view):
        if request.user.is_superuser:
            return True

        #Anyone can see the list of volunteer activities
        if request.method in permissions.SAFE_METHODS:
            return True
        post_data = request.POST
        org_id = post_data.get('organization', None)

        #FIXME: raise better error if org_id is invalid / missing
        try:
            organization = Organization.objects.get(pk=org_id)
        except:
            raise APIException("organization not specified or not found")
        #If user has write perms on org, allow him / her to create
        #a volunteer activity for that org
        if organization.has_write_perms(request.user):
            return True

        #If none of the above conditions returned True, the user
        #does not have permissions (for eg. non logged in user trying to POST)
        return False


class VolunteerActivityPermission(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        if request.user.is_superuser:
            return True

        #Anyone can see the list of volunteer activities
        if request.method in permissions.SAFE_METHODS:
            return True
        if obj.has_write_perms(request.user):
            return True
        return False


class UserVolunteerActivityPermission(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        if not request.user.is_authenticated():
            return False
        if request.user.is_superuser:
            return True
        organization = obj.activity.organization
        method = request.method
        user = request.user
        is_org_writable = organization.has_write_perms(user)
        is_own_activity = obj.user == user
        if method == 'PATCH':
            return is_org_writable
        if method == 'GET':
            return is_org_writable or is_own_activity
        if method == 'DELETE':
            return is_own_activity
        return False


class DonorRequirementsPermission(VolunteerActivitiesPermission):
    pass
