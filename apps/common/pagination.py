from rest_framework.pagination import PaginationSerializer

class KLPPaginationSerializer(PaginationSerializer):
    results_field = 'features'