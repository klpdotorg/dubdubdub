from django.views.decorators.cache import cache_page
from rest_framework.views import APIView


class CacheMixin(APIView):
    @classmethod
    def as_view(cls, **initkwargs):
        view = super(CacheMixin, cls).as_view(**initkwargs)
        return cache_page(60 * 15)(view)
