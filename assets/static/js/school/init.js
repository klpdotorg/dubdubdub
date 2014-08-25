(function() {
    klp.init = function() {
        klp.router = new KLPRouter({});
        klp.router.init();
        klp.tabs.init();
        var $infoXHR = klp.api.do("schools/school/" + SCHOOL_ID, {geometry: 'yes'});

        // FIX THIS LATER
        $('#map-canvas').css('zIndex', 1);
        $infoXHR.done(function(data) {
            var markerLatlng = L.latLng(data.geometry.coordinates[1], data.geometry.coordinates[0]);
            var map = L.map('map-canvas', {
                touchZoom: false,
                scrollWheelZoom: false,
                doubleClickZoom: false,
                boxZoom: false,
                zoomControl: false,
                attributionControl: false
            }).setView(markerLatlng, 15);

            L.tileLayer('http://geo.klp.org.in/osm/{z}/{x}/{y}.png', {
                attribution: 'OpenStreetMap, OSM-Bright'
            }).addTo(map);

            console.log('markerLatlng', markerLatlng);
            var marker = L.geoJson(data, {
                pointToLayer: function(feature, latLng) {
                    return L.marker(latLng, {icon: klp.utils.mapIcon(data.properties.type.name)});
                }
            }).addTo(map);

            map.panBy([0,50], {animate: true, duration: 0.50});

            var tpl = swig.compile($('#tpl-school-info').html());
            //var html = swig.render($('#tpl-school-info').html(), {locals: data});
            var context = data.properties;
            console.log('context', context);
            context['type_name'] = context.type.id === 1 ? 'school' : 'preschool';
            var html = tpl(context);
            $('#school-info-wrapper').html(html);
        });
        klp.router.start();
    };

})();