(function() {
    var t = klp.map = {};
    var window_width,
        $mobile_details_wrapper,
        $_filter_layers_list,
        $_filter_layers_button,
        $_filter_radius_button,
        map,
        marker_overlay_html;
    var place_data = {
        1: {
            name: "Gian Jyoti Public School",
            latlong: [12.979, 77.590]
        },
        2: {
            name: "Karnataka Public School",
            latlong: [12.97, 77.59]
        }
    };
    var tpl_map_popup;
    var tpl_mobile_place_details;
    var map_voluteer_date = false;

    t.init = function() {
        $_filter_layers_list = $("#filter-layers-list");
        $_filter_layers_button = $("#filter-layers-button");
        $_filter_radius_button = $("#filter-radius-button");
        $(document).on("click", ".js-toggle-layers-list", function(e){
            var $trigger = $(e.target).closest(".js-toggle-layers-list");

            if(!$_filter_layers_list.hasClass("show")){
                // $trigger.addClass("open");
                $_filter_layers_list.addClass("show");
            } else {
                // $trigger.removeClass("open");
                $_filter_layers_list.removeClass("show");
            }
        });

        $_filter_radius_button.on("click", toggleFilterRadius);
        
        window_width = $(window).width();
        tpl_map_popup = swig.compile($("#tpl-map-popup").html());
        tpl_mobile_place_details = swig.compile($(
            "#tpl_mobile_place_details").html());
        $mobile_details_wrapper = $("#mobile-details-wrapper");
        $mobile_details_wrapper.on("click", ".js-close-details", function(e) {
            e.preventDefault();
            $mobile_details_wrapper.removeClass("show");
        });
        // $('input').iCheck({
        //  checkboxClass: 'icheckbox_minimal',
        //  radioClass: 'iradio_minimal',
        //  increaseArea: '20%' // optional
        // });
        var sidebar_height = $("#sidebar_wrapper").height();
        $('#sidebar_wrapper ul').slimScroll({
            height: sidebar_height + 'px',
            size: '5px',
            color: '#8d8d8d',
            railVisible: false,
        });
        var map_overlay_top = $(".main-header").height() + 20 + 100;
        $("#map_overlay").css({
            'top': map_overlay_top + 'px'
        });
        load_map();
    };

    t.closePopup = function() {
        map.closePopup();
    };

    $(window).resize(onWindowResize);

    function onWindowResize() {
        window_width = $(window).width();
        // console.log(window_width);
        if (window_width < 768) {
            map.closePopup();
        } else {
            $mobile_details_wrapper.removeClass("show");
        }
    }

    function load_map() {
        // var param_location = getUrlVar("location");
        // var param_date = getUrlVar("date");
        // var param_type = getUrlVar("type");
        // // Some check to ensure values are valid and is set for every param
        // if (param_date) {
        //     map_voluteer_date = param_date;
        //     // console.log("params set: "+map_voluteer_date);
        // }
        marker_overlay_html = $("#tpl_marker_overlay").html();
        map = L.map('map_canvas').setView([12.9793998, 77.5903608], 14);
        L.tileLayer('http://geo.klp.org.in/osm/{z}/{x}/{y}.png', {
            maxZoom: 18,
            attribution: '',
            id: 'examples.map-i86knfo3'
        }).addTo(map);

        t.loadPlaces(place_data);
        // for (var place_id in place_data) {
        //     if (place_data.hasOwnProperty(place_id)) {
        //         add_place_marker(place_id);
        //     }
        // }
        $(document).on('click', ".js-trigger-volunteer-map", function() {
            map.closePopup();
            map_voluteer_date = false;
        });
    }

    t.loadPlaces = function(places) {
        for (var place_id in places) {
            if (places.hasOwnProperty(place_id)) {
                add_place_marker(place_id);
            }
        }
    };

    function add_place_marker(place_id) {
        var place = place_data[place_id];
        var marker = L.marker(place.latlong, {
            clickable: true
        }).addTo(map);
        marker.bindPopup("", {
            maxWidth: 380,
            minWidth: 380
        });
        marker.on('click', function(e) {
            if (window_width < 768) {
                // Its a phone
                marker.closePopup(); // Close popup
                console.log("open details from bottom");
                show_mobile_place_details(place_id);
                // show_place_details(place_id);
            } else {
                // Set popup content
                console.log("show popup");
                var content = build_popup_content(place_id);
                marker.setPopupContent(content);
            }
        });
    }

    function show_mobile_place_details(place_id) {
        var latlong = place_data[place_id].latlong;
        map.setView(latlong, 15);
        setTimeout(function() {
            var details_ht = $mobile_details_wrapper.height();
            var pan_y = parseInt(details_ht / 2.5);
            map.panBy(L.point(0, pan_y));
        }, 300);
        var html = build_mobile_details_content(place_id);
        $mobile_details_wrapper.html(html).addClass("show");
    }

    function build_popup_content(place_id) {
        var ctx = {
            date: map_voluteer_date
        };
        var html = tpl_map_popup(ctx);
        return html;
    }

    function build_mobile_details_content(place_id) {
        var ctx = {
            name: place_data[place_id].name
        }
        var html = tpl_mobile_place_details(ctx);
        return html;
    }

    function toggleFilterRadius(){
        var $filter_radius_msg = $("#msg-filter-radius");

        if(!$_filter_radius_button.hasClass("active")) {
            // $_filter_radius_button.addClass("active");
            $filter_radius_msg.removeClass("hide");
        } else {
            // $_filter_radius_button.removeClass("active");
            $filter_radius_msg.addClass("hide");
        }
    };

    // function getUrlVar(key) {
    //     var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
    //     return result && unescape(result[1]) || "";
    // }

})();