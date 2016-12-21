from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import check_password
from django.db.models import Q
from rest_framework.exceptions import AuthenticationFailed
# Get user model
User = get_user_model()


class EmailMobileUsernameBackend(object):
    def authenticate(self, username=None, password=None):
        qset = User.objects.filter(Q(email__iexact=username) | Q(mobile_no__iexact=username))
        if qset.count() == 1:
            user = qset.first()

            if check_password(password, user.password):
                return user
        else:
            raise AuthenticationFailed('More than one user exists with username: {}'.format(username))

        return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None
