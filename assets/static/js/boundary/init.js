'use strict';
(function() {
    klp.init = function() {
        klp.router = new KLPRouter({});
        klp.router.init();
        //klp.tabs.init();
        /*------------------- WISH WASH FOR MAP-------------*/
        var $infoXHR = klp.api.do("schools/school/" + "33312", {geometry: 'yes'});

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
                        return L.marker(latLng, {icon: klp.utils.mapIcon("primaryschool_cluster")});
                    }
                }).addTo(map);

                map.panBy([0,50], {animate: true, duration: 0.50});
            } else {
                //if school does not have any coordinates, what to do?
                $('.map-canvas').hide();
            }
            /*------------------- WISH WASH FOR MAP-------------*/
            var tpl = swig.compile($('#tpl-boundary-info').html());
            //var html = swig.render($('#tpl-school-info').html(), {locals: data});
            var context = data.properties;
            //console.log('context', context);
            context['type_name'] = 'cluster';
            var html = tpl(context);
            $('#boundary-info-wrapper').html(html);
        });
        klp.router.start();
        renderSummary();
    };

    function renderSummary(){
        var data =  
            {"klp": {
                'schools': 1000,
                'students': 4440,
                "acadyear" : "2014-2015"
            }, 
            "dise" : {
                'schools': 1000,
                'students': 4440,
                'ptr' : '30:1',
                "acadyear" : "2014-2015"
            }
            
        };
        var tpl = swig.compile($('#tpl-school-summary').html());
            var html = tpl(data);
            $('#school-summary').html(html);   
    }

})();


