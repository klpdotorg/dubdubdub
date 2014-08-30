from django.views.decorators.cache import cache_page
from rest_framework.views import APIView
from django.conf import settings


class CacheMixin(APIView):
    @classmethod
    def as_view(cls, **initkwargs):
        view = super(CacheMixin, cls).as_view(**initkwargs)

        if settings.CACHE_ENABLED:
            return cache_page(settings.CACHE_TIMEOUT)(view)
        else:
            return view
