(function() {
    var t = klp.volunteer_map = {};

    var map;
    var activitiesLayer;
    var tplVolunteerListItem = swig.compile($('#tplVolunteerListItem').html());
    var tplVolunteerMapPopup = swig.compile($('#tplVolunteerMapPopup').html());
    var tplVolunteerEmptyList = swig.compile($('#tplVolunteerEmptyList').html());
    t.init = function() {
        load_map();

        // Google Geocode Search
        var searchInput = $('.search-input');
        searchInput.on('keypress', function(e) {
            if (e.keyCode === 13) {
                search($(e.target).val());
                }
            });

        function search(query) {
            var apiKey = "AIzaSyB19tHGJ8R3eX3JhR655zzo72dyB4628vc";
            query = query+", Karnataka";
            var url = "https://maps.googleapis.com/maps/api/geocode/json?address="+query+"&region=in&key="+apiKey;
            $.ajax({
                url: url
            }).done(function (data) {
                if (data.results.length > 0) {
                    var location = data.results[0].geometry.location;
                    var resultLocation = L.latLng([location.lat, location.lng]);
                    map.setView(resultLocation, 15);
                }
            });
        }

        function setURL() {
            var currentZoom = map.getZoom();
            var mapCenter = map.getCenter();
            var mapURL = currentZoom+'/'+mapCenter.lat.toFixed(5)+'/'+mapCenter.lng.toFixed(5);
            klp.router.setHash(mapURL, {}, {trigger: false, replace: true});
        }

        klp.router.events.on('hashchange', function (event, params) {
            var url = params.url,
                oldURL = params.oldURL;
            if (url === '') {
                setURL();
            } else {
                if (oldURL !== url) {
                    //currentURL = url;
                    var urlSplit = url.split('/');
                    var urlZoom = urlSplit[0];
                    var urlLatLng = L.latLng(urlSplit[1], urlSplit[2]);
                    map.setView(urlLatLng, urlZoom);

                }
            }
        });

        // Map Events
        map.on('moveend', function () {
            setURL();
        });

        $('#filterOrganization, #filterActivityType').on('change', function(e) {
            // console.log("filter changed");
            t.applyFilters();
        });
    };

    t.applyFilters = function() {
        var params = getFilters();
        params.geometry = 'yes';
        var $activitiesXHR = klp.api.do('volunteer_activities', params);
        $activitiesXHR.done(function(data) {
            // console.log("activities", data);
            clearActivities();
            loadActivities(data);
        });
    };

    function getFilters() {
        var filterParams = {};
        var date = $('[name=date]').val();
        var org = $('#filterOrganization').val();
        var typ = $('#filterActivityType').val();
        if (date) {
            filterParams.date = date;
        }
        if (org) {
            filterParams.org = org;
        }
        if (typ) {
            filterParams.activity_type = typ;
        }
        return filterParams;
    }

    function clearActivities() {
        $('#volunteerActivityList').empty();
        activitiesLayer.clearLayers();
    }

    function loadActivities(data) {
        var activities = data.features;
        if (activities.length > 0) {
            _(activities).each(function(activity) {
                var html = tplVolunteerListItem(activity.properties);
                $('#volunteerActivityList').append(html);
            });
        } else {
            var context = {};
            var html = tplVolunteerEmptyList(context);
            $('#volunteerActivityList').html(html);
        }
        var geojson = klp.utils.filterGeoJSON(data);
        activitiesLayer.addData(geojson);
        map.fitBounds(activitiesLayer.getBounds());
    }

    function load_map() {
        var southWest = L.latLng(11.57, 73.87),
            northEast = L.latLng(18.45, 78.57),
            bounds = L.latLngBounds(southWest, northEast);
        map = L.map('js-map-canvas', {maxBounds: bounds}).setView([12.9793998, 77.5903608], 14);
        L.tileLayer(klp.settings.tilesURL, {
            maxZoom: 16,
            attribution: 'OpenStreetMap, OSM-Bright'
        }).addTo(map);

        map.locate({setView: true, maxZoom: 15});
        activitiesLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: klp.utils.mapIcon(feature.properties.school_details.type.name)});
            },
            onEachFeature: onEachSchool
        }).addTo(map);
    }

    function markerPopup(marker, feature) {
        var school_id = feature.properties.school_details.id;
        var date = $('[name=date]').val();
        var organisation = $('#filterOrganization').val();
        var type = $('#filterActivityType').val();
        var params = {
            'date': date,
            'school': school_id
        };
        if (organisation) {
            params['organization'] = organisation;
        }

        if (type) {
            params['activity_type'] = type;
        }

        var popupInfoXHR = klp.api.do('volunteer_activities', params);
        popupInfoXHR.done(function (data) {
            marker.bindPopup(tplVolunteerMapPopup(data), {maxWidth:381, minWidth:381}).openPopup();
        });

    }

    function onEachSchool(feature, layer) {
    if (feature.properties) {
        layer.on('click', function(e) {
            markerPopup(this, feature);
            //setMarkerURL(feature);
        });
    }
}



})();
