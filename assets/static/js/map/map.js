(function() {
    var t = klp.map = {};
    var window_width,
        $mobile_details_wrapper,
        $_filter_layers_list,
        $_filter_layers_button,
        $_filter_radius_button,
        map,
        marker_overlay_html;

    var tpl_map_popup;
    var tpl_mobile_place_details;
    var map_voluteer_date = false;
    var mapIcon = klp.utils.mapIcon;
    var mapBbox;

    var districtLayer,
        preschoolDistrictLayer,
        blockLayer,
        clusterLayer,
        projectLayer,
        circleLayer,
        schoolCluster,
        preschoolCluster,
        popupInfoXHR,
        preschoolXHR,
        schoolXHR;

    var mapLayers = {};

    var disabledLayers,
        enabledLayers,
        allLayers,
        selectedLayers;

    var filterGeoJSON = function(geojson) {
        return geojson.features.filter(emptyGeom);

        function emptyGeom(feature) {
            return !_.isEmpty(feature.geometry);
        }
    };

    var getLayerFromName = function(name) {
        var invertedMapLayers = _.invert(mapLayers);
        var layerID = invertedMapLayers[name];

        //FIX ME: This is ugly.
        return allLayers._layers[layerID];
    };

    var boundaryZoomLevels = {
        'district': 8,
        'block': 9,
        'project': 9,
        'pincode': 9,
        'cluster': 10,
        'circle': 10
    };

    var schoolDistrictMap = {
        'primaryschool': 'Primary School',
        'preschool': 'Preschool'
    };

    t.init = function() {
        // $_filter_layers_list = $("#filter-layers-list");
        // $_filter_layers_button = $("#filter-layers-button");
        // $_filter_radius_button = $("#filter-radius-button");
        // $(document).on("click", ".js-toggle-layers-list", function(e){
        //     var $trigger = $(e.target).closest(".js-toggle-layers-list");

        //     if(!$_filter_layers_list.hasClass("show")){
        //         // $trigger.addClass("open");
        //         $_filter_layers_list.addClass("show");
        //     } else {
        //         // $trigger.removeClass("open");
        //         $_filter_layers_list.removeClass("show");
        //     }
        // });

        // $_filter_radius_button.on("click", toggleFilterRadius);
        var currentURL, currentLayers, currentMarker;

        // Search.
        var $searchInput = $(".search-input");
        $searchInput.select2({
            placeholder: 'Search for schools, boundaries and PIN codes',
            minimumInputLength: 3,
            ajax: {
                url: "/api/v1/search",
                quietMillis: 300,
                allowClear: true,
                data: function (term, page) {
                    return {
                        text: term,
                        geometry: 'yes'
                    };
                },
                results: function (data, page) {
                    var searchResponse = {
                        results: [
                        {
                            text: "Schools",
                            children: makeResults(data.schools.features, 'school')
                        },
                        {
                            text: "Boundaries",
                            children: makeResults(data.boundaries.features, 'boundary')   
                        },
                        {
                            text: "Parliaments",
                            children: makeResults(data.parliaments.features, 'parliament')
                        },
                        {
                            text: "Assemblies",
                            children: makeResults(data.assemblies.features, 'assembly')
                        },
                        {
                            text: "PIN codes",
                            children: makeResults(data.pincodes.features, 'pincode')
                        }
                        ]
                    };
                    return {results: searchResponse.results};
                }
            }
        });

        $searchInput.on('change', function(choice) {
            var data = choice.added.data;
            console.log(data);
            var searchPoint;
            var searchGeometryType = data.geometry.type;
            var searchGeometry = data.geometry.coordinates;
            var searchEntityType = data.entity_type;

            selectedLayers.clearLayers();
            // selectedMarkers.clearLayers();

            if (searchEntityType === 'school') {
                console.log('searched for schools');
                searchPoint = L.latLng(data.geometry.coordinates[1], data.geometry.coordinates[0]);
                var marker = L.marker(searchPoint, {icon: mapIcon(data.properties.type.name)});
                markerPopup(marker, data);
                map.setView(searchPoint, 14);
                setMarkerURL(data);
            }

            if (searchEntityType === 'boundary') {
                console.log('boundary');
                var boundaryType = data.properties.type;
                searchPoint = L.latLng(searchGeometry[1], searchGeometry[0]);
                setBoundaryResultsOnMap(boundaryType, searchPoint, data);
            }
            if (searchEntityType === 'pincode') {
                var searchLayer = L.geoJson(data);
                searchLayer.addTo(selectedLayers);
                searchPoint = searchLayer.getBounds().getCenter();
                map.setView(searchPoint, 14);
                // setBoundaryResultsOnMap('pincode', searchPoint, data);
            }
                // if (boundaryType === 'district') {

                //     console.log('district');
                //     var schoolType = data.properties.school_type;
                //     var marker = L.marker(searchPoint, {icon: mapIcon(schoolType+'_district')});
                //     marker.bindPopup(data.properties.name);
                //     marker.addTo(searchLayer).openPopup();
                //     map.setView(searchPoint, boundaryZoomLevels['district']);
    });

        function setBoundaryResultsOnMap(type, point, data) {
            var marker;
            if (type === 'district') {
                var schoolType = data.properties.school_type;
                marker = L.marker(point, {icon: mapIcon(schoolType+'_district')});
            } else {
                marker = L.marker(point, {icon: mapIcon(type)});
            }
            marker.bindPopup(data.properties.name);
            marker.addTo(selectedLayers).openPopup();
            console.log(boundaryZoomLevels[type]);
            map.setView(point, boundaryZoomLevels[type]);
        }

            // if (searchGeometryType === 'Point') {
            //     console.log('Point searched');
            //     var isSchool = data.properties.type && data.properties.type.id && (data.properties.type.id === 1 || data.properties.type.id === 2);
            //     console.log("is school", isSchool);
            //     if (isSchool) {
    
            //     } else {
            //         searchPoint = L.latLng(searchGeometry[1], searchGeometry[0]);
            //     }
            //     map.setView(searchPoint, 14);
            // } else {
            //     console.log('Polygon searched');
            //     var searchLayer = L.geoJson(choice.added.data);
            //     searchPoint = searchLayer.getBounds().getCenter();
            //     L.marker(searchPoint).addTo(map);
            // }
            //     map.setView(searchPoint, 14);
            // var searchPoint = 

        function makeResults(array, type) {
            return _(array).map(function(obj) {
                var name = obj.properties.name;
                if (type === 'boundary') {
                    if (obj.properties.type === 'district') {
                        name = obj.properties.name + ' - ' + schoolDistrictMap[obj.properties.school_type] + ' ' + obj.properties.type;
                    } else {
                        name = obj.properties.name + ' - ' + obj.properties.type;
                    }
                }
                if (type === 'pincode') {
                    name = obj.properties.pincode;
                }
                obj.entity_type = type;
                return {
                    id: obj.properties.id,
                    text: _.str.titleize(name),
                    data: obj
                };
            });
        }

        klp.router.events.on('hashchange', function (event, url, queryParams) {
            if (url === '') {
                setURL();
            } else {
                if (currentURL !== url) {
                    currentURL = url;
                    var urlSplit = url.split('/');
                    var urlZoom = urlSplit[0];
                    var urlLatLng = L.latLng(urlSplit[1], urlSplit[2]);
                    map.setView(urlLatLng, urlZoom);

                }
            }
            if (queryParams.hasOwnProperty('marker')) {
                if (currentMarker !== queryParams['marker']) {
                    currentMarker = queryParams['marker'];
                    var urlMarker = queryParams.marker.split('-');
                    var schoolType = urlMarker[0];
                    var schoolID = urlMarker[1];
                    var thisSchoolLayer = getLayerFromName(schoolType);
                    // console.log('thisSchoolLayer', thisSchoolLayer);
                    var thisSchoolXHR = klp.api.do('schools/school/'+schoolID, {'geometry': 'yes'});
                    thisSchoolXHR.done(function(data) {
                        var thisSchoolMarker = L.geoJson(data, {
                            pointToLayer: function(feature, latlng) {
                                map.setView(latlng);
                                return L.marker(latlng, {icon: mapIcon(schoolType)});
                            },
                            onEachFeature: function(feature, layer) {
                                markerPopup(layer, feature);
                            }
                        }).addTo(map);
                    });
                }
            } else if (currentMarker) {
                map.closePopup();
                currentMarker = null;
            }
        });

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

        disabledLayers = L.layerGroup();
        enabledLayers = L.layerGroup().addTo(map);
        selectedMarkers = L.layerGroup().addTo(map);
        selectedLayers = L.featureGroup().addTo(map);

        // var mapIcon = function (type) {

        //     // FIXME: May be fix this in the icon name.
        //     // This is Sanjay's fault.
        //     if (type === 'primaryschool') {
        //         type = 'school';
        //     }
        //     return L.icon({
        //         iconUrl: 'static/images/map/icon_'+type+'.png',
        //         iconSize: [20, 30],
        //         iconAnchor: [10, 26],
        //         popupAnchor: [0, -25]
        //     });
        // };

        preschoolCluster = L.markerClusterGroup({chunkedLoading: true,removeOutsideVisibleBounds: true, showCoverageOnHover: false, iconCreateFunction: function(cluster) {
            return new L.DivIcon({ className:'marker-cluster marker-cluster-preschool', style:'style="margin-left: -20px; margin-top: -20px; width: 40px; height: 40px; transform: translate(293px, 363px); z-index: 363;"', html: "<div><span>" + cluster.getChildCount() + "</span></div>" });
            }}).addTo(enabledLayers);


        schoolCluster = L.markerClusterGroup({chunkedLoading: true, removeOutsideVisibleBounds: true, showCoverageOnHover: false, iconCreateFunction: function(cluster) {
            return new L.DivIcon({ className:'marker-cluster marker-cluster-school', style:'style="margin-left: -20px; margin-top: -20px; width: 40px; height: 40px; transform: translate(293px, 363px); z-index: 363;"', html: "<div><span>" + cluster.getChildCount() + "</span></div>" });
            }}).addTo(enabledLayers);

        // var preschoolXHR = klp.api.do('schools/list', {'type': 'preschools', 'geometry': 'yes', 'per_page': 0, 'bbox': map.getBounds().toBBoxString()});

        // var schoolXHR = klp.api.do('schools/list', {'type': 'primaryschools', 'geometry': 'yes', 'per_page': 0, 'bbox': map.getBounds().toBBoxString()});

        var districtXHR = klp.api.do('boundary/admin1s', {'school_type':'primaryschools', 'geometry': 'yes', 'per_page': 0});

        var preschoolDistrictXHR = klp.api.do('boundary/admin1s', {'school_type': 'preschools', 'geometry': 'yes', 'per_page': 0});

        var blockXHR = klp.api.do('boundary/admin2s', {'school_type': 'primaryschools', 'geometry': 'yes', 'per_page': 0});

        var projectXHR = klp.api.do('boundary/admin2s', {'school_type': 'preschools', 'geometry': 'yes', 'per_page': 0});

        var clusterXHR = klp.api.do('boundary/admin3s', {'school_type': 'primaryschools', 'geometry': 'yes', 'per_page': 0});

        var circleXHR = klp.api.do('boundary/admin3s', {'school_type': 'preschools', 'geometry': 'yes', 'per_page': 0});

        function onEachSchool(feature, layer) {
            if (feature.properties) {
                layer.on('click', function(e) {
                    markerPopup(this, feature);
                    setMarkerURL(feature);
                });
            }
        }

        function setMarkerURL(feature) {
            var typeID = feature.properties.type.id;
            var schoolID = feature.properties.id;
            var opts = {
                trigger: false,
            }
            if (typeID === 1) {
                klp.router.setHash(null, {marker: 'primaryschool-'+schoolID}, opts);
            } else {
                klp.router.setHash(null, {marker: 'preschool-'+schoolID}, opts);
            }
        }

        function onEachFeature(feature, layer) {
            if (feature.properties) {
                layer.bindPopup(_.str.titleize(feature.properties.name));
            }
        }

        // preschoolXHR.done(function (data) {
        //     var preschoolLayer = L.geoJson(filterGeoJSON(data), {
        //         pointToLayer: function(feature, latlng) {
        //             return L.marker(latlng, {icon: mapIcon('preschool')});
        //         },
        //         onEachFeature: onEachSchool
        //     }).addTo(preschoolCluster);
        // });

        // schoolXHR.done(function (data) {
        //     var schoolLayer = L.geoJson(filterGeoJSON(data), {
        //         pointToLayer: function(feature, latlng) {
        //             return L.marker(latlng, {icon: mapIcon('school')});
        //         },
        //         onEachFeature: onEachSchool
        //     }).addTo(schoolCluster);
        // });

        function loadPointsByBbox() {
            var bbox = map.getBounds();
            if (mapBbox && mapBbox.contains(bbox)) {
                return;
            }

            var bboxString = map.getBounds().pad(0.5).toBBoxString();
            mapBbox = bbox.pad(0.5); 

            if (preschoolXHR && preschoolXHR.state() === 'pending') {
                console.log('aborting preschool xhr');
                preschoolXHR.abort();
            }

            if (schoolXHR && schoolXHR.state() === 'pending') {
                console.log("aborting school xhr");
                schoolXHR.abort();
            }
            
            if (enabledLayers.hasLayer(preschoolCluster)) {
                preschoolXHR = klp.api.do('schools/list', {'type': 'preschools', 'geometry': 'yes', 'per_page': 0, 'bbox': bboxString});
                preschoolXHR.done(function (data) {
                    preschoolCluster.clearLayers();
                    var preschoolLayer = L.geoJson(filterGeoJSON(data), {
                        pointToLayer: function(feature, latlng) {
                            return L.marker(latlng, {icon: mapIcon('preschool')});
                        },
                        onEachFeature: onEachSchool
                    }).addTo(preschoolCluster);
                });
            }

            if (enabledLayers.hasLayer(schoolCluster)) {
                schoolXHR = klp.api.do('schools/list', {'type': 'primaryschools', 'geometry': 'yes', 'per_page': 0, 'bboxString': bboxString});
                schoolXHR.done(function (data) {
                    schoolCluster.clearLayers();
                    var schoolLayer = L.geoJson(filterGeoJSON(data), {
                        pointToLayer: function(feature, latlng) {
                            return L.marker(latlng, {icon: mapIcon('school')});
                        },
                        onEachFeature: onEachSchool
                    }).addTo(schoolCluster);
                });
            }
        }

        loadPointsByBbox();

        districtLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: mapIcon('school_district')});
            },
            onEachFeature: onEachFeature
        });

        preschoolDistrictLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: mapIcon('preschool_district')});
            },
            onEachFeature: onEachFeature
        });

        blockLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: mapIcon('school_block')});
            },
            onEachFeature: onEachFeature
        });

        clusterLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: mapIcon('school_cluster')});
            },
            onEachFeature: onEachFeature
        });

        projectLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: mapIcon('preschool_project')});
            },
            onEachFeature: onEachFeature
        });

        circleLayer = L.geoJson(null, {
            pointToLayer: function(feature, latlng) {
                return L.marker(latlng, {icon: mapIcon('preschool_circle')});
            },
            onEachFeature: onEachFeature
        });

        districtXHR.done(function (data) {
            districtLayer.addData(filterGeoJSON(data));
            districtLayer.addTo(disabledLayers);
        });

        preschoolDistrictXHR.done(function (data) {
            preschoolDistrictLayer.addData(filterGeoJSON(data));
            preschoolDistrictLayer.addTo(disabledLayers);
        });

        blockXHR.done(function (data) {
            blockLayer.addData(filterGeoJSON(data));
            blockLayer.addTo(disabledLayers);
        });

        clusterXHR.done(function (data) {
            clusterLayer.addData(filterGeoJSON(data));
            clusterLayer.addTo(disabledLayers);
        });

        projectXHR.done(function (data) {
            projectLayer.addData(filterGeoJSON(data));
            projectLayer.addTo(disabledLayers);
        });

        circleXHR.done(function (data) {
            circleLayer.addData(filterGeoJSON(data));
            circleLayer.addTo(disabledLayers);
        });

        function markerPopup(marker, feature) {
            console.log("marker popup called", marker, feature);
            var duplicateMarker;
            if (feature.properties.type.id === 1) {
                duplicateMarker = L.marker(marker._latlng, {icon: mapIcon('school')});
            } else {
                duplicateMarker = L.marker(marker._latlng, {icon: mapIcon('preschool')});
            }
            selectedLayers.addLayer(duplicateMarker);
            // if (popupInfoXHR && popupInfoXHR.hasOwnProperty('state') && popupInfoXHR.state() === 'pending') {
            //     popupInfoXHR.abort();
            // }
            popupInfoXHR = klp.api.do('schools/school/'+feature.properties.id, {});
            popupInfoXHR.done(function(data) {
                //marker.bindPopup(tpl_map_popup(data), {maxWidth:380, minWidth:380}).openPopup();
                duplicateMarker.bindPopup(tpl_map_popup(data), {maxWidth:380, minWidth:380}).openPopup();
                document.title = "School: " + feature.properties.name;
                if (window_width < 768) {
                    // Its a phone
                    marker.closePopup(); // Close popup
                    // map.setView(marker.getLatLng(), 15);
                    setTimeout(function() {
                        var details_ht = $mobile_details_wrapper.height();
                        var pan_y = parseInt(details_ht / 2.5);
                        map.panBy(L.point(0, pan_y));
                    }, 300);
                    var html = tpl_mobile_place_details(data);
                    $mobile_details_wrapper.html(html).addClass("show");
                }
            });
        }

        var overlays = {
            '<span class="en-icon small en-school">s</span> <span class="label en-school">SCHOOL</span>': schoolCluster,
            '<span class="en-icon small en-preschool">p</span> <span class="label en-preschool">PRESCHOOL</span>': preschoolCluster,
            '<span class="en-icon small en-school-district">sd</span> <span class="label en-school-district">SCHOOL DISTRICT</span>': districtLayer,
            '<span class="en-icon small en-preschool-district">pd</span> <span class="label en-preschool-district">PRESCHOOL DISTRICT</span>': preschoolDistrictLayer,
            '<span class="en-icon small en-school-block">sb</span> <span class="label en-school-block">SCHOOL BLOCK</span>': blockLayer,
            '<span class="en-icon small en-school-cluster">sc</span> <span class="label en-school-cluster">SCHOOL CLUSTER</span>': clusterLayer,
            '<span class="en-icon small en-preschool-project">pp</span> <span class="label en-preschool-project">PRESCHOOL PROJECT</span>': projectLayer,
            '<span class="en-icon small en-preschool-circle">pc</span> <span class="label en-preschool-circle">PRESCHOOL CIRCLE</span>': circleLayer

        };

        L.control.layers({}, overlays, {collapsed: true}).addTo(map);

        mapLayers[preschoolCluster._leaflet_id] = 'preschool' ;
        mapLayers[schoolCluster._leaflet_id] = 'school';
        mapLayers[districtLayer._leaflet_id] = 'district';
        mapLayers[preschoolDistrictLayer._leaflet_id] = 'preschooldistrict';
        mapLayers[blockLayer._leaflet_id] = 'block';
        mapLayers[clusterLayer._leaflet_id] = 'cluster';
        mapLayers[circleLayer._leaflet_id] = 'circle';
        mapLayers[projectLayer._leaflet_id] = 'project';

        allLayers = L.layerGroup([preschoolCluster, schoolCluster, districtLayer, preschoolDistrictLayer, blockLayer, clusterLayer, projectLayer, circleLayer]);

        // Control for Filters.

        var filterControl = L.Control.extend({
            options: {
                position: 'topright'
            },

            onAdd: function(map) {
                var container = L.DomUtil.create('div', 'leaflet-control filter-control');
                container.title = 'Filter Schools';
                button = "<a class='filter-tool' href='#'></a>";
                container.innerHTML = button;
                L.DomEvent
                .addListener(container, 'click', L.DomEvent.stopPropagation)
                .addListener(container, 'click', L.DomEvent.preventDefault)
                .addListener(container, 'click', this.onClick);

                return container;
            },

            onClick: function(e) {
                L.DomUtil.addClass(e.target, 'active');
                klp.filters_modal.open();
            }
        });

        map.addControl(new filterControl());
        // var filter = new filterControl();
        // filter.addTo(map);

        // Map Events
        map.on('zoomend', updateLayers);
        // map.on('movestart', function() {
        //     currentMapBounds = map.getBounds().toBBoxString();
        //     console.log(currentMapBounds);
        // })
        map.on('moveend', function() {
            loadPointsByBbox();
            setURL();
        });

        map.on('popupclose', function(e) {
            document.title = "School Map";
            selectedLayers.clearLayers();
            klp.router.setHash(null, {marker: null}, {trigger: false});
        });

        t.map = map;
    };

    function updateLayers() {

        var currentZoom = map.getZoom();
        if (currentZoom <= 8) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(districtLayer);
            enabledLayers.addLayer(preschoolDistrictLayer);
        }
        if (currentZoom == 9) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(blockLayer);
            enabledLayers.addLayer(projectLayer);
        }
        if (currentZoom == 10) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(clusterLayer);
            enabledLayers.addLayer(circleLayer);
        }
        if (currentZoom >= 11) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(schoolCluster);
            enabledLayers.addLayer(preschoolCluster);
        }

    }

    function setURL() {

        var currentZoom = map.getZoom();
        var mapCenter = map.getCenter();
        var mapURL = currentZoom+'/'+mapCenter.lat.toFixed(5)+'/'+mapCenter.lng.toFixed(5);
        klp.router.setHash(mapURL, {}, {trigger: false, replace: true});
    }

    // marker.bindPopup(tpl_map_popup({}), {maxWidth: 380, minWidth: 380}).openPopup();

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
        var southWest = L.latLng(11.57, 73.87),
            northEast = L.latLng(18.45, 78.57),
            bounds = L.latLngBounds(southWest, northEast);

        marker_overlay_html = $("#tpl_marker_overlay").html();
        map = L.map('map_canvas', {maxBounds: bounds}).setView([12.9793998, 77.5903608], 14);
        L.tileLayer('http://geo.klp.org.in/osm/{z}/{x}/{y}.png', {
            maxZoom: 16,
            attribution: 'OpenStreetMap, OSM-Bright'
        }).addTo(map);

        // t.loadPlaces(place_data);
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

        // t.loadPlaces = function(places) {
        //     for (var place_id in places) {
        //         if (places.hasOwnProperty(place_id)) {
        //             add_place_marker(place_id);
        //         }
        //     }
        // };

        // function add_place_marker(place_id) {
        //     var place = place_data[place_id];
        //     var marker = L.marker(place.latlong, {
        //         clickable: true
        //     }).addTo(map);
        //     marker.bindPopup("", {
        //         maxWidth: 380,
        //         minWidth: 380
        //     });
        //     marker.on('click', function(e) {
        //         if (window_width < 768) {
        //             // Its a phone
        //             marker.closePopup(); // Close popup
        //             console.log("open details from bottom");
        //             show_mobile_place_details(place_id);
        //             // show_place_details(place_id);
        //         } else {
        //             // Set popup content
        //             console.log("show popup");
        //             var content = build_popup_content(place_id);
        //             marker.setPopupContent(content);
        //         }
        //     });
        // }

        // function show_mobile_place_details(place_id) {
        //     var latlong = place_data[place_id].latlong;
        //     map.setView(latlong, 15);
        //     setTimeout(function() {
        //         var details_ht = $mobile_details_wrapper.height();
        //         var pan_y = parseInt(details_ht / 2.5);
        //         map.panBy(L.point(0, pan_y));
        //     }, 300);
        //     var html = build_mobile_details_content(place_id);
        //     $mobile_details_wrapper.html(html).addClass("show");
        // }

        // function build_popup_content(place_id) {
        //     var ctx = {
        //         date: map_voluteer_date
        //     };
        //     var html = tpl_map_popup(ctx);
        //     return html;
        // }

        // function build_mobile_details_content(place_id) {
        //     var ctx = {
        //         name: place_data[place_id].name
        //     }
        //     var html = tpl_mobile_place_details(ctx);
        //     return html;
        // }

        // function toggleFilterRadius(){
        //     var $filter_radius_msg = $("#msg-filter-radius");

        //     if(!$_filter_radius_button.hasClass("active")) {
        //         // $_filter_radius_button.addClass("active");
        //         $filter_radius_msg.removeClass("hide");
        //     } else {
        //         // $_filter_radius_button.removeClass("active");
        //         $filter_radius_msg.addClass("hide");
        //     }
        // };

        // function getUrlVar(key) {
        //     var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
        //     return result && unescape(result[1]) || "";
        // }

})();