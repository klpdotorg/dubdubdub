from rest_framework import serializers
from rest_framework.exceptions import PermissionDenied
from .models import User
from django.contrib.auth import login, authenticate, logout

class UserSerializer(serializers.ModelSerializer):

    token = serializers.Field(source='get_token')

    def restore_object(self, attrs, instance=None):
        email = attrs.get('email', None)
        password = attrs.get('password', None)
        extras = {
            'mobile_no': attrs.get('mobile_no', None),
            'first_name': attrs.get('first_name', None),
            'last_name': attrs.get('last_name', None)
        }
        request = self.context['request']
        #import pdb;pdb.set_trace()
        if not instance: #create new user
            user = User.objects.create_user(email, password, **extras)
            email = request.POST.get('email')
            password = request.POST.get('password')
            user = authenticate(username=email, password=password)
            login(request, user)
            return user
        else:
            if request.user.id != instance.id and not request.user.is_superuser:
                raise PermissionDenied()
            for key in extras.keys():
                if extras[key] is not None:
                    setattr(instance, key, extras[key])
            if password and password != '':
                instance.set_password(password)
            instance.save()
            return instance

    def save_object(self, *args, **kwargs):
        pass

    class Meta:
        model = User
        fields = ('email', 'mobile_no', 'first_name', 'last_name', 'password', 'token',)
        write_only_fields = ('password',)

