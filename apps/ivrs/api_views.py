from rest_framework.response import Response

from common.views import KLPAPIView, KLPDetailAPIView, KLPListAPIView

from schools.models import School, SchoolDetails


class CheckSchool(KLPAPIView):
    def get(self, request):
        return Response("Excellent", status=200, content_type='text/plain')
