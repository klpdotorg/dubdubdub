'use strict';
(function() {
    var t = klp.map = {};
    var window_width,
        $mobile_details_wrapper,
        $_filter_layers_list,
        $_filter_layers_button,
        $radiusButton,
        map,
        marker_overlay_html;

    var tpl_map_popup;
    var tpl_mobile_place_details;
    var map_voluteer_date = false;
    var mapIcon = klp.utils.mapIcon;
    var mapBbox;
    var state = {
        'addPopupCloseHistory': true
    };
    var districtLayer,
        preschoolDistrictLayer,
        blockLayer,
        clusterLayer,
        projectLayer,
        circleLayer,
        schoolCluster,
        preschoolCluster,
        radiusLayer,
        popupInfoXHR,
        preschoolXHR,
        schoolXHR;

    var mapLayers = {};

    var disabledLayers,
        enabledLayers,
        allLayers,
        selectedLayers,
        allMarkersOnMap = [];

    var $_form_advanced_search,
        $_input_partner,
        $_input_programme,
        $_btn_reset_adv_search;

    var isMobile = $(window).width() < 768;

    var filterGeoJSON = klp.utils.filterGeoJSON;

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

        $(document).on('click', '.js-map-popup-close', function(e) {
            e.preventDefault();
            map.closePopup();
        });

        $_form_advanced_search = $('#form_advanced_search');
        $_input_partner = $('input[name="partner_id"]:radio');
        $_input_programme = $('#multi_programmes');
        $_btn_reset_adv_search = $('.adv-search-reset-btn');

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
                            text: "Pre-Schools",
                            children: makeResults(data.pre_schools.features, 'school')
                        },
                        {
                            text: "Primary Schools",
                            children: makeResults(data.primary_schools.features, 'school')
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
            //console.log(data);
            var searchPoint;
            var searchGeometryType = data.geometry.type;
            var searchGeometry = data.geometry.coordinates;
            var searchEntityType = data.entity_type;
            if (map._popup) {
                state.addPopupCloseHistory = false;
            }

            selectedLayers.clearLayers();

            if (searchEntityType === 'school') {
                searchPoint = L.latLng(data.geometry.coordinates[1], data.geometry.coordinates[0]);
                var marker = L.marker(searchPoint, {icon: mapIcon(data.properties.type.name)});
                markerPopup(marker, data);
                map.setView(searchPoint, 14);
            }

            if (searchEntityType === 'boundary') {
                klp.router.setHash(null, {marker: 'boundary-'+data.properties.id}, {trigger: false});
                var boundaryType = data.properties.type;
                searchPoint = L.latLng(searchGeometry[1], searchGeometry[0]);
                setBoundaryResultsOnMap(boundaryType, searchPoint, data);
            }
            if (searchEntityType === 'pincode'  || searchEntityType === 'parliament' || searchEntityType === 'assembly') {
                var urlID = data.properties.id;
                if (searchEntityType === 'pincode') {
                    urlID = data.properties.pincode;
                }
                klp.router.setHash(null, {marker: searchEntityType+'-'+urlID}, {trigger: false});
                var searchLayer = L.geoJson(data);
                searchLayer.addTo(selectedLayers);
                var geomBounds = searchLayer.getBounds();
                map.fitBounds(geomBounds);
            }
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
            map.setView(point, boundaryZoomLevels[type]);
        }

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

        // Advanced Search
        var do_search = function(e) {
            e.preventDefault();
            var data = get_form_data();
            klp.router.setHash('/', data);
            loadPointsByBbox();
        }

        var get_form_data = function() {
            var formdata = $_form_advanced_search.serializeArray();

            var data = {};
            $(formdata ).each(function(index, obj){
                if (data.hasOwnProperty(obj.name)) {
                    data[obj.name] += ',' + encodeURIComponent(obj.value);
                } else {
                    data[obj.name] = encodeURIComponent(obj.value);
                }
            });
            return data;
        }

        var fill_program = function(e) {
            e.preventDefault();
            var formdata = get_form_data();

            var thisEntityXHR = klp.api.do('programme/', formdata);
            thisEntityXHR.done(function(data) {
                $_input_programme.select2('destroy');
                $_input_programme.append( $.map(data.features, function(v, i){
                    return $('<option>', { val: v.id, text: v.name });
                }) );
            });
        }

        $_form_advanced_search.on('submit', do_search);
        $_input_partner.on('change', fill_program);

        klp.router.events.on('hashchange', function (event, params) {
            var url = params.url,
                oldURL = params.oldURL;

            if (url === 'close') {
                // 'close' is because of the advanced search modal
                setURL();
            } else {
                if (oldURL !== url) {
                    //currentURL = url;
                    var urlSplit = url.split('/');
                    if (urlSplit.length < 3) {
                        // when the advanced search modal is displayed,
                        // it sets url as 'advanced' or 'close'
                        return;
                    }

                    var urlZoom = urlSplit[0];
                    var urlLatLng = L.latLng(urlSplit[1], urlSplit[2]);
                    map.setView(urlLatLng, urlZoom);
                }
            }
        });

        klp.router.events.on('hashchange:marker', function (event, params) {
            console.log(event);
            var queryParams = params.queryParams,
                changed = params.changed;
            if (map._popup) {
                state.addPopupCloseHistory = false;
            }
            if (changed.marker.oldVal && !changed.marker.newVal) {
                map.closePopup();
                return;
            }
            var urlMarker = queryParams.marker.split('-');
            var entityType = urlMarker[0];
            var entityID = urlMarker[1];

            selectedLayers.clearLayers();

            if (entityType === 'primaryschool' || entityType === 'preschool') {
                var thisSchoolXHR = klp.api.do('schools/school/'+entityID, {'geometry': 'yes'});
                thisSchoolXHR.done(function(data) {
                    var thisSchoolMarker = L.geoJson(data, {
                        pointToLayer: function(feature, latlng) {
                            map.setView(latlng);
                            return L.marker(latlng, {icon: mapIcon(entityType)});
                        },
                        onEachFeature: function(feature, layer) {
                            markerPopup(layer, feature);
                        }
                    }).addTo(map);
                });
            } else if (entityType === 'pincode' || entityType === 'parliament' || entityType === 'assembly') {
                var urlString = entityType+'/'+entityID;
                var thisEntityXHR = klp.api.do('boundary/'+urlString, {'geometry':
                    'yes'});
                thisEntityXHR.done(function(data) {
                    var thisEntityPolygon = L.geoJson(data);
                    thisEntityPolygon.addTo(selectedLayers);
                    var geomBounds = selectedLayers.getBounds();
                    map.fitBounds(geomBounds);
                });
            } else if (entityType === 'boundary') {
                var thisEntityXHR = klp.api.do('boundary/admin/'+entityID, {'geometry': 'yes'});
                thisEntityXHR.done(function(data) {
                    var iconType = data.properties.school_type+'_'+data.properties.type;
                    // console.log('iconType', iconType);
                    var thisEntityMarker = L.geoJson(data, {
                        pointToLayer: function(feature, latlng) {
                            map.setView(latlng);
                            return L.marker(latlng, {icon: mapIcon(iconType)});
                        }
                    });
                    thisEntityMarker.bindPopup(data.properties.name);
                    thisEntityMarker.addTo(selectedLayers);
                    thisEntityMarker.openPopup();
                });
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
            klp.router.setHash(null, {marker: null});
            document.title = 'School Map';
        });

        var map_overlay_top = $(".main-header").height() + 20 + 100;
        $("#map_overlay").css({
            'top': map_overlay_top + 'px'
        });

        load_map();

        disabledLayers = L.layerGroup();
        enabledLayers = L.layerGroup().addTo(map);
        selectedLayers = L.featureGroup().addTo(map);

        preschoolCluster = L.markerClusterGroup({chunkedLoading: true,removeOutsideVisibleBounds: true, showCoverageOnHover: false, iconCreateFunction: function(cluster) {
            return new L.DivIcon({ className:'marker-cluster marker-cluster-preschool', style:'style="margin-left: -20px; margin-top: -20px; width: 40px; height: 40px; transform: translate(293px, 363px); z-index: 363;"', html: "<div><span>" + cluster.getChildCount() + "</span></div>" });
            }}).addTo(enabledLayers);


        schoolCluster = L.markerClusterGroup({chunkedLoading: true, removeOutsideVisibleBounds: true, showCoverageOnHover: false, iconCreateFunction: function(cluster) {
            return new L.DivIcon({ className:'marker-cluster marker-cluster-school', style:'style="margin-left: -20px; margin-top: -20px; width: 40px; height: 40px; transform: translate(293px, 363px); z-index: 363;"', html: "<div><span>" + cluster.getChildCount() + "</span></div>" });
            }}).addTo(enabledLayers);

        var bbox = map.getBounds().toBBoxString();

        var districtXHR = klp.api.do('boundary/admin1s', {'school_type':'primaryschools', 'geometry': 'yes', 'per_page': 0});

        var preschoolDistrictXHR = klp.api.do('boundary/admin1s', {'school_type': 'preschools', 'geometry': 'yes', 'per_page': 0});

        var blockXHR = klp.api.do('boundary/admin2s', {'school_type': 'primaryschools', 'geometry': 'yes', 'bbox': bbox});

        var projectXHR = klp.api.do('boundary/admin2s', {'school_type': 'preschools', 'geometry': 'yes', 'bbox': bbox});

        var clusterXHR = klp.api.do('boundary/admin3s', {'school_type': 'primaryschools', 'geometry': 'yes', 'bbox': bbox});

        var circleXHR = klp.api.do('boundary/admin3s', {'school_type': 'preschools', 'geometry': 'yes', 'bbox': bbox});

        function onEachSchool(feature, layer) {
            if (feature.properties) {
                layer.on('click', function(e) {
                    markerPopup(this, feature);
                    //setMarkerURL(feature);
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
                var markerParam = 'primaryschool-' + schoolID;
            } else {
                var markerParam = 'preschool-' + schoolID;
            }
            if (typeID === 1) {
                klp.router.setHash(null, {marker: markerParam}, opts);
            } else {
                klp.router.setHash(null, {marker: markerParam}, opts);
            }
        }

        function onEachFeature(feature, layer) {
            if (feature.properties) {
                layer.bindPopup(_.str.titleize(feature.properties.name));
            }
        }

        // var $sidebar_school_items = $('.sidebar-school');
        $('body').on('click', '.sidebar-school', function(e) {
            e.preventDefault();

            var opts = {
                trigger: false,
            }

            var school_element = e.target;
            if (e.target.tagName !== 'LI' ) {
                var school_parents = $(e.target).parents('.sidebar-school');
                if (school_parents.length > 0) {
                    school_element = school_parents[0];
                } else {
                    console.log('cannot find a list element');
                    return;
                }
            }

            $(school_element).siblings('li').css('background-color', '')

            var school_id = $(school_element).data('id');
            $.each(allMarkersOnMap, function(idx, marker) {
                if (marker.feature.properties.id == school_id) {
                    marker.fire('click');
                }
            })

            $(school_element).css('background-color', '#ddd')
        })

        function shuffle(array) {
          var currentIndex = array.length, temporaryValue, randomIndex;

          // While there remain elements to shuffle...
          while (0 !== currentIndex) {

            // Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex -= 1;

            // And swap it with the current element.
            temporaryValue = array[currentIndex];
            array[currentIndex] = array[randomIndex];
            array[randomIndex] = temporaryValue;
          }

          return array;
        }

        function listPointsOnSidebar(allTheLayers) {
            var bbox = map.getBounds();
            allMarkersOnMap = [];

            allTheLayers.eachLayer(function(parentLayer) {
                parentLayer.eachLayer(function(marker) {
                    if (bbox.contains(marker.getLatLng())) {
                        allMarkersOnMap.push(marker);
                    }
                })
            });

            if (allMarkersOnMap.length > 0) {
                $('#school-list').html('');
                shuffle(allMarkersOnMap);
                $.each(allMarkersOnMap, function(idx, marker) {
                    var tplSchoolItem = swig.compile($('#tpl-school-item').html());

                    var html = tplSchoolItem(marker.feature);
                    $('#school-list').append(html);
                })
            } else {
                $('#school-list').html('Sorry, no schools were found in the current map view. Please zoom out or move around to find more schools.')
            }
        }

        $_btn_reset_adv_search.on('click', function(e) {
            window.location.hash = '';
            map.setZoom(map.getZoom() - 1);
        });

        function loadPointsByBbox() {
            var bbox = map.getBounds();
            // FIXME
            // if (mapBbox && mapBbox.contains(bbox)) {
            //     console.log('this is quitting here');
            //     return;
            // }

            var bboxString = map.getBounds().pad(0.05).toBBoxString();
            mapBbox = bbox.pad(0.05);

            if (preschoolXHR && preschoolXHR.state() === 'pending') {
                preschoolXHR.abort();
            }

            if (schoolXHR && schoolXHR.state() === 'pending') {
                schoolXHR.abort();
            }

            var formdata = klp.router.getHash();
            console.log('form data parsed from url', formdata);

            console.log(Object.getOwnPropertyNames(formdata.queryParams).length);
            if (Object.getOwnPropertyNames(formdata.queryParams).length > 0) {
                $('.adv-search-reset-btn').show();
            }

            var options = {
                'geometry': 'yes',
                'per_page': 400,
                'bbox': bboxString
            }
            for (var attrname in formdata.queryParams) {
                options[attrname] = formdata.queryParams[attrname];
            }

            if (enabledLayers.hasLayer(preschoolCluster)) {
                t.startLoading();

                options['school_type'] = 'preschools';

                preschoolXHR = klp.api.do('schools/list', options);
                preschoolXHR.done(function (data) {
                    t.stopLoading();
                    preschoolCluster.clearLayers();

                    var preschoolLayer = L.geoJson(filterGeoJSON(data), {
                        pointToLayer: function(feature, latlng) {
                            return L.marker(latlng, {icon: mapIcon('preschool')});
                        },
                        onEachFeature: onEachSchool
                    }).addTo(preschoolCluster);

                    // this is here so that it gets called
                    // after both the preschool and primary school
                    // API calls are done.
                    listPointsOnSidebar(enabledLayers);
                });
            }

            if (enabledLayers.hasLayer(schoolCluster)) {
                t.startLoading();

                options['school_type'] = 'primaryschools';

                schoolXHR = klp.api.do('schools/list', options);
                schoolXHR.done(function (data) {
                    t.stopLoading();
                    schoolCluster.clearLayers();

                    var schoolLayer = L.geoJson(filterGeoJSON(data), {
                        pointToLayer: function(feature, latlng) {
                            return L.marker(latlng, {icon: mapIcon('school')});
                        },
                        onEachFeature: onEachSchool
                    }).addTo(schoolCluster);

                    // this is here so that it gets called
                    // after both the preschool and primary school
                    // API calls are done.
                    listPointsOnSidebar(enabledLayers);
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
            var duplicateMarker;
            if (feature.properties.type.id === 1) {
                duplicateMarker = L.marker(marker._latlng, {icon: mapIcon('school')});
            } else {
                duplicateMarker = L.marker(marker._latlng, {icon: mapIcon('preschool')});
            }
            selectedLayers.addLayer(duplicateMarker);
            if (map._popup) {
                state.addPopupCloseHistory = false;
            }
            t.startLoading();
            popupInfoXHR = klp.api.do('schools/school/'+feature.properties.id, {});
            popupInfoXHR.done(function(data) {
                var facilitiesXHR = fetchBasicFacilities(data);
                facilitiesXHR.done(function(basicFacilities) {
                    t.stopLoading();
                    data.basic_facilities = basicFacilities;
                    data.has_basic_facilities = data.basic_facilities.computer_lab ||
                                                data.basic_facilities.library ||
                                                data.basic_facilities.playground ||
                                                data.has_volunteer_activities;
                    data.total_students = getTotalStudents(data);
                    duplicateMarker.bindPopup(tpl_map_popup(data), {maxWidth:300, minWidth:300}).openPopup();
                    setMarkerURL(feature);
                    document.title = "School: " + feature.properties.name;
                    $('.js-trigger-compare').unbind('click');
                    $('.js-trigger-compare').click(function(e) {
                        e.preventDefault();
                        klp.comparison.open(data);
                    });
                });
            });
        }

        function fetchBasicFacilities(data) {
            var $deferred = $.Deferred();
            if (data.type.id === 2) { //is a preschool
                setTimeout(function() {
                    $deferred.resolve(data.basic_facilities);
                }, 0);
            } else {
                var facilitiesXHR = klp.dise_api.fetchSchoolInfra(data.dise_code);
                facilitiesXHR.done(function(diseData) {
                    if (diseData.hasOwnProperty('properties')) {
                        var basicFacilities = klp.dise_infra.getBasicFacilities(diseData.properties);
                        $deferred.resolve(basicFacilities);
                    } else {
                        $deferred.resolve({});
                    }
                });
                facilitiesXHR.fail(function(err) {
                    klp.utils.alertMessage("Temporary error fetching basic facilities data for this school.");
                    $deferred.resolve({});
                });
            }
            return $deferred;
        }

        function getTotalStudents(data) {
            var boys = data.num_boys ? data.num_boys : 0;
            var girls = data.num_girls ? data.num_girls : 0;
            return parseInt(boys) + parseInt(girls);

        }

        var overlays = {
            '<span class="brand-school"><span class="icon-button-round-sm"><span class="k-icon">s</span></span> <span class="font-small">SCHOOL</span></span>': schoolCluster,
            '<span class="brand-preschool"><span class="icon-button-round-sm"><span class="k-icon">p</span></span> <span class="font-small">PRESCHOOL</span>': preschoolCluster,
            '<span class="brand-school-district"><span class="icon-button-round-sm"><span class="k-icon">sd</span></span> <span class="font-small">SCHOOL DISTRICT</span>': districtLayer,
            '<span class="brand-preschool-district"><span class="icon-button-round-sm"><span class="k-icon">pd</span></span> <span class="font-small">PRESCHOOL DISTRICT</span>': preschoolDistrictLayer,
            '<span class="brand-school-block"><span class="icon-button-round-sm"><span class="k-icon">sb</span></span> <span class="font-small">SCHOOL BLOCK</span>': blockLayer,
            '<span class="brand-school-cluster"><span class="icon-button-round-sm"><span class="k-icon">sc</span></span> <span class="font-small">SCHOOL CLUSTER</span>': clusterLayer,
            '<span class="brand-preschool-project"><span class="icon-button-round-sm"><span class="k-icon">pp</span></span> <span class="font-small">PRESCHOOL PROJECT</span>': projectLayer,
            '<span class="brand-preschool-circle"><span class="icon-button-round-sm"><span class="k-icon">pc</span></span> <span class="font-small">PRESCHOOL CIRCLE</span>': circleLayer

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


       // Radius tool.
        // Initialise the FeatureGroup to store editable layers
        var drawnItems = new L.FeatureGroup();
        map.addLayer(drawnItems);

        // Initialise the draw control and pass it the FeatureGroup of editable layers
        var drawControl = new L.Control.Draw({
            position: 'bottomright',
            draw: {
                polyline: false,
                polygon: false,
                rectangle: false,
                marker: false,
                circle: true
            },
            edit: {
                featureGroup: drawnItems,
                edit: false,
                remove: false
            }
        });
        map.addControl(drawControl);

        // Control for Filters.

        var filterControl = L.Control.extend({
            options: {
                position: 'bottomright'
            },

            onAdd: function(map) {
                var container = L.DomUtil.create('div', 'leaflet-control filter-control');
                container.title = 'Filter Schools';
                var button = "<a class='js-filter-tool filter-tool' href='#'></a>";
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

        // Map Events
        map.on('zoomend', updateLayers);
        map.on('moveend', _.debounce(function() {
            loadPointsByBbox();
            setURL();
        }, 300));

        map.on('popupclose', function(e) {
            //If we don't wrap this in a setTimeout, there is some
            //some strange race condition in leaflet since we are calling
            //clearLayers() on selectedLayers inside the select2 onchange
            //which conflicts with this, but is okay if we wrap in a setTimeout
            //FIXME: but really not sure how to fix.
            setTimeout(function() {
                selectedLayers.removeLayer(e.popup._source);
            }, 0);
            if (state.addPopupCloseHistory) {
                klp.router.setHash(null, {marker: null}, {trigger: false});
                document.title = "School Map";
            } else {
                state.addPopupCloseHistory = true;
            }
        });

        map.on('draw:drawstart', function (e) {
            $radiusButton = $('.leaflet-draw-draw-circle');
            $radiusButton.addClass('active');
        });

        map.on('draw:drawstop', function (e) {
            $radiusButton.removeClass('active');
        });

        map.on('draw:created', function (e) {
            var type = e.layerType,
                layer = e.layer,
                bbox = e.layer.getBounds().pad(0.01),
                bboxString = bbox.toBBoxString();

            map.fitBounds(bbox);
            var radiusXHR = klp.api.do('schools/info', {'bbox':bboxString, 'geometry': 'yes', 'per_page': 0});
            radiusXHR.done(function (data) {
                radiusLayer = L.geoJson(filterGeoJSON(data), {
                    pointToLayer: function(feature, latlng) {
                        if (feature.properties.type.id == 1) {
                            return L.marker(latlng, {icon: mapIcon('primaryschool')});
                        } else {
                            return L.marker(latlng, {icon: mapIcon('preschool')});
                        }
                    },
                    onEachFeature: onEachSchool
                    });
                enabledLayers.clearLayers();
                enabledLayers.addLayer(radiusLayer);
            });
        });

    };

    t.startLoading = function() {
        t.map.spin(true, {top: '40px', 'left': '70px'});
    };

    t.stopLoading = function() {
        t.map.spin(false);
    };

    function updateLayers() {

        var currentZoom = map.getZoom();
        if (currentZoom < 8) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(districtLayer);
            enabledLayers.addLayer(preschoolDistrictLayer);
        }
        if (currentZoom == 8 || currentZoom == 9) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(blockLayer);
            enabledLayers.addLayer(projectLayer);
        }
        if (currentZoom == 10 || currentZoom == 11) {
            enabledLayers.clearLayers();
            enabledLayers.addLayer(clusterLayer);
            enabledLayers.addLayer(circleLayer);
        }
        if (currentZoom >= 12) {
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


    t.closePopup = function() {
        map.closePopup();
    };

    function load_map() {

        var southWest = L.latLng(11.57, 73.87),
            northEast = L.latLng(18.45, 78.57),
            bounds = L.latLngBounds(southWest, northEast);

        marker_overlay_html = $("#tpl_marker_overlay").html();
        t.map = map = L.map('js-map-canvas', {maxBounds: bounds}).setView([12.9793998, 77.5903608], 14);
        L.tileLayer(klp.settings.tilesURL, {
            maxZoom: 16,
            attribution: 'OpenStreetMap, OSM-Bright'
        }).addTo(map);

        // Try to find users location.
        map.locate({setView: false, maxZoom: 15});
        map.on('locationfound', onLocationFound);

        function onLocationFound(e) {
            if (bounds.contains(e.latlng)) {
                map.setView(e.latlng, 15);
            }
        }

        $(document).on('click', ".js-trigger-volunteer-map", function() {
            map.closePopup();
            map_voluteer_date = false;
        });
    }

})();
