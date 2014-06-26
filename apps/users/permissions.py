from rest_framework import permissions
from .models import Organization

class UserListPermission(permissions.BasePermission):
    '''
        Permission class for whether user can see a list of all user and create new users
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
    '''

    def has_permission(self, request, view):
        if request.method == 'POST':
            if request.user.is_superuser == True:
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
        Permission class to check if user has permissions to view / edit users of an organization
    '''
    def has_permission(self, request, view):
        org_id = view.kwargs['org_pk']
        org = Organization.objects.get(pk=org_id)
        if request.method in permissions.SAFE_METHODS:
            return org.has_read_perms(request.user)
        else:
            return org.has_write_perms(request.user)