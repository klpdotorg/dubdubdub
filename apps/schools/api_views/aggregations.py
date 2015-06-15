from schools.serializers import (
    BoundaryLibLangAggSerializer, BoundaryLibLevelAggSerializer
)
from common.views import KLPListAPIView, KLPDetailAPIView, KLPAPIView


class BoundaryLibLangAggView(KLPListAPIView):
    model = BoundaryLibLangAggSerializer.Meta.model
    serializer_class = BoundaryLibLangAggSerializer

    def get_queryset(self):
        boundary_id = self.kwargs.get('id')

        BoundaryLibLangAgg = BoundaryLibLangAggSerializer.Meta.model
        return BoundaryLibLangAgg.objects.filter(boundary_id=boundary_id)


class BoundaryLibLevelAggView(KLPListAPIView):
    model = BoundaryLibLevelAggSerializer.Meta.model
    serializer_class = BoundaryLibLevelAggSerializer

    def get_queryset(self):
        boundary_id = self.kwargs.get('id')

        BoundaryLibLevelAgg = BoundaryLibLevelAggSerializer.Meta.model
        return BoundaryLibLevelAgg.objects.filter(boundary_id=boundary_id)
