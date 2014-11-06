'use strict';
(function() {
    klp.init = function() {
        klp.router = new KLPRouter({});
        klp.router.init();
        klp.tabs.init();
        klp.share_story.init(SCHOOL_ID);
        klp.comparison.init();
        klp.volunteer_here.init();
        var $infoXHR = klp.api.do("schools/school/" + SCHOOL_ID, {geometry: 'yes'});

        // FIX THIS LATER
        $('#map-canvas').css('zIndex', 1);
        $infoXHR.done(function(data) {
            $('.js-trigger-compare').click(function(e) {
                e.preventDefault();
                klp.comparison.open(data.properties);
            });
            if (data.geometry && data.geometry.coordinates) {
                var markerLatlng = L.latLng(data.geometry.coordinates[1], data.geometry.coordinates[0]);
                var map = L.map('map-canvas', {
                    touchZoom: false,
                    scrollWheelZoom: false,
                    doubleClickZoom: false,
                    boxZoom: false,
                    zoomControl: false,
                    attributionControl: false
                }).setView(markerLatlng, 15);

                L.tileLayer(klp.settings.tilesURL, {
                    attribution: 'OpenStreetMap, OSM-Bright'
                }).addTo(map);

                // console.log('markerLatlng', markerLatlng);
                var marker = L.geoJson(data, {
                    pointToLayer: function(feature, latLng) {
                        return L.marker(latLng, {icon: klp.utils.mapIcon(data.properties.type.name)});
                    }
                }).addTo(map);

                map.panBy([0,50], {animate: true, duration: 0.50});
            } else {
                //if school does not have any coordinates, what to do?
                $('.map-canvas').hide();
            }

            var tpl = swig.compile($('#tpl-school-info').html());
            //var html = swig.render($('#tpl-school-info').html(), {locals: data});
            var context = data.properties;
            //console.log('context', context);
            context['type_name'] = context.type.id === 1 ? 'school' : 'preschool';
            var html = tpl(context);
            $('#school-info-wrapper').html(html);
        });
        klp.router.start();
    };

})();
