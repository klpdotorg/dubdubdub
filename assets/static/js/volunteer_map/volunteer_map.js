(function() {
    var t = klp.volunteer_map = {};

    var map;
    t.init = function() {
//        console.log("initting");
        load_map();

        var sidebar_height = $("#sidebar_wrapper").height();
        $('#sidebar_wrapper ul').slimScroll({
            height: sidebar_height+'px',
            size: '5px',
            color: '#8d8d8d',
            railVisible: false
        });
    };

    function load_map() {
        var southWest = L.latLng(11.57, 73.87),
            northEast = L.latLng(18.45, 78.57),
            bounds = L.latLngBounds(southWest, northEast).pad(1);
        map = L.map('map_canvas', {maxBounds: bounds}).setView([12.9793998, 77.5903608], 14);
        L.tileLayer('http://geo.klp.org.in/osm/{z}/{x}/{y}.png', {
            maxZoom: 16,
            attribution: 'OpenStreetMap, OSM-Bright'
        }).addTo(map);
    }


})();