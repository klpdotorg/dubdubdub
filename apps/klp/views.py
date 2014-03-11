from django.shortcuts import render
from django.contrib.gis.geos import Polygon
from coords.models import InstCoord
from klp.models import TbSchool
import json
from django.http import HttpResponse

def schools(request):
    bbox_string = request.GET.get("bounds")
    bbox = Polygon.from_bbox([float(b) for b in bbox_string.split(",")])
    insts_qset = InstCoord.objects.filter(coord__within=bbox)
    insts_dict = {}
    for inst in insts_qset:
        insts_dict[inst.instid] = inst
    schools = TbSchool.objects.filter(id__in=insts_dict.keys())
    count = schools.count()
    d = {
        'type': 'FeatureCollection',
        'count': count,
        'features': [s.get_geojson(insts_dict[s.id]) for s in schools]
    }
    return HttpResponse(json.dumps(d))

# Create your views here.
