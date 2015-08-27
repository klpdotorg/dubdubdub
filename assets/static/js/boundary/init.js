'use strict';
(function() {
    var utils;
    var ADMIN_LEVEL_MAP = {
        'district': 'admin_1',
        'block': 'admin_2',
        'cluster': 'admin_3',
        'project': 'admin_2',
        'circle': 'admin_3'
    };
    klp.init = function() {
        utils = klp.boundaryUtils;
        //klp.router = new KLPRouter({});
        //klp.router.init();       
        //klp.router.start();
        render(BOUNDARY_ID);
    };

    function render(boundaryID, academicYear) {
        /*------------------- WISH WASH FOR MAP-------------*/
        var $infoXHR = klp.api.do("aggregation/boundary/" + boundaryID + '/schools/', {
            geometry: 'yes'
        });

        // FIX THIS LATER
        $('#map-canvas').css('zIndex', 1);
        $infoXHR.done(function(data) {
                var boundary = data.properties.boundary;
                var boundaryType = boundary.school_type;

                if (boundaryType === 'primaryschool') {
                    renderPrimarySchool(data, academicYear);
                } else {
                    renderPreSchool(data, academicYear);
                }

                $('.js-trigger-compare').click(function(e) {
                    e.preventDefault();
                    klp.comparison.open(data.properties);
                });
                var geom;
                if (boundary.geometry) {
                    geom = boundary.geometry;
                } else {
                    geom = null;
                }
                
                if (geom && geom.coordinates) {
                    var markerLatlng = L.latLng(geom.coordinates[1], geom.coordinates[0]);
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

                    var marker = L.geoJson(geom, {
                        pointToLayer: function(feature, latLng) {
                            return L.marker(latLng, {
                                icon: klp.utils.mapIcon("primaryschool_cluster")
                            });
                        }
                    }).addTo(map);

                    map.panBy([0, 50], {
                        animate: true,
                        duration: 0.50
                    });
                } else {
                    //if school does not have any coordinates, what to do?
                    $('.map-canvas').hide();
                }

                var tpl = swig.compile($('#tpl-boundary-info').html());
                var context = data.properties;
                context['type_name'] = 'cluster';
                var html = tpl(context);
                $('#boundary-info-wrapper').html(html);
            })
            .fail(function(err) {
                klp.utils.alertMessage("Something went wrong. Please try later.", "error");
            });
    }

    function renderPrimarySchool(data, academicYear) {
        var queryParams = {};
        var boundaryID = data.properties.boundary.id;
        var adminLevel = ADMIN_LEVEL_MAP[data.properties.boundary.type];
        queryParams[adminLevel] = boundaryID;        
        $('#school-data').removeClass("hidden");
        //renderSummary("school");
        //renderGenderCharts("school");
        //renderCategories("school");
        //renderLanguages("school");
        //renderEnrolment("school");
        //renderGrants();
        //renderInfra("school");
        //renderPrograms("school");
        klp.api.do('programme/',queryParams)
               .done(function(progData) {                    
                    renderPrograms(utils.getSchoolPrograms(progData, boundaryID, adminLevel),'primaryschool');            
               })
               .fail(function(err) {
                    klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
            });
        console.log('data', data);
    }

    function renderPreSchool(data, academicYear) {
        var queryParams = {};
        var boundaryID = data.properties.boundary.id;
        var adminLevel = ADMIN_LEVEL_MAP[data.properties.boundary.type];
        queryParams[adminLevel] = boundaryID;        
        klp.api.do('programme/',queryParams)
               .done(function(progData) {                    
                    renderPrograms(utils.getSchoolPrograms(progData, boundaryID, adminLevel),'preschool');            
               })
               .fail(function(err) {
                    klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
            });
        $('#preschool-data').removeClass("hidden");
        renderSummary(utils.getPreSchoolSummary(data), 'preschool');
        renderGenderCharts(utils.getKLPGenderData(data), 'preschool');
        renderCategories(utils.getPreSchoolCategories(data), 'preschool');
        renderLanguages(utils.getSchoolsByLanguage(data), 'preschool');
        renderEnrolment("preschool");
        renderInfra("preschool");
        

        console.log('data', data);
    }

    function renderSummary(data, schoolType) {
        var tpl = swig.compile($('#tpl-school-summary').html());
        data["school_type"] = schoolType;
        var html = tpl(data);
        if (schoolType == "school")
            $('#school-summary').html(html);
        else
            $('#preschool-summary').html(html);
    }

    function renderGenderCharts(data, schoolType) {
        var tpl = swig.compile($('#tpl-gender-summary').html());
        var gender = null;
        var html = tpl(gender);
        var prefix = '';
        if (schoolType == "school") {
            gender = {
                "gender": data["dise"]
            };
            html = tpl(gender);
            $('#dise-gender').html(html);
            gender = {
                "gender": data["klp"]
            };
        } else {
            prefix = "ang-";
            gender = {
                "gender": data["klp"]
            };
            gender["gender"]["align"] = "left";
        }
        html = tpl(gender);
        $('#' + prefix + 'klp-gender').html(html);

    }

    function renderCategories(data, schoolType) {
        /*if(schoolType == "school") {
            data = { 
            "model primary": {
                "type_name":"model primary",
                "klp_perc": 20,
                "dise_perc": 21,
                "klp_count": 40,
                "dise_count": 42
            },
            "upper primary": {
                "type_name":"upper primary",
                "klp_perc": 50,
                "dise_perc": 48,
                "klp_count": 100,
                "dise_count": 96
            },
            "lower primary": {
                "type_name":"lower primary",
                "klp_perc": 30,
                "dise_perc": 31,
                "klp_count": 60,
                "dise_count": 62 }
            };
        }
        */
        var tpl_func = '#tpl-category-summary';
        var prefix = '';
        if (schoolType == "preschool") {
            prefix = "ang-";
            tpl_func = '#tpl-ang-category-summary';
        }
        var tpl = swig.compile($(tpl_func).html());
        var html = tpl({
            "categories": data
        });
        $('#' + prefix + 'category-summary').html(html);
    }

    function renderLanguages(data, schoolType) {
        //Handle For Primary School
        /*var data = { 
            "kannada": {
                "typename":"kannada",
                "count": 200,
                "perc": 20
            },
            "urdu": {
                "typename":"urdu",
                "count": 400,
                "perc": 41
            },
            "tamil": {
                "typename":"tamil",
                "count": 400,
                "perc": 39
            }
            
        };*/
        var tpl_func = "#tpl-language";
        var prefix = '';
        if (schoolType == "preschool") {
            prefix = "ang-"
            tpl_func = "#tpl-ang-language";
        }
        var tpl = swig.compile($(tpl_func).html());
        var html = tpl({
            "languages": data
        });
        $('#' + prefix + 'klp-language').html(html);
    }

    function renderEnrolment(schoolType) {
        var data = null;
        if (schoolType == "school") {
            data = {
                "model primary": {
                    "type_name": "model primary",
                    "count": 2000,
                    "perc": 21,
                    "avg": 80
                },
                "upper primary": {
                    "type_name": "upper primary",
                    "count": 4000,
                    "perc": 80,
                    "avg": 100
                },
                "lower primary": {
                    "type_name": "lower primary",
                    "count": 1000,
                    "perc": 19,
                    "avg": 90
                }

            };
        } else {
            data = {
                "anganwadi": {
                    "type_name": "anganwadi",
                    "count": 2000,
                    "perc": 21,
                    "avg": 80
                },
                "balwadi": {
                    "type_name": "balwadi",
                    "count": 4000,
                    "perc": 80,
                    "avg": 100
                },
                "independent balwadi": {
                    "type_name": "independent balwadi",
                    "count": 1000,
                    "perc": 19,
                    "avg": 90
                },
                "others": {
                    "type_name": "others",
                    "count": 1000,
                    "perc": 19,
                    "avg": 90
                }
            };
        }

        var tpl = swig.compile($('#tpl-enrolment').html());
        var html = tpl({
            "categories": data
        });
        var prefix = 'dise-';
        if (schoolType == "preschool") {
            prefix = "ang-"
        }
        $('#' + prefix + 'enrolment').html(html);
    }

    function renderGrants() {
        var data = {
            "received": {
                "sg_perc": 35,
                "sg_amt": 3500,
                "smg_perc": 55,
                "smg_amt": 5500,
                "tlm_perc": 10,
                "tlm_amt": 1000
            },
            "expected": {
                "sg_perc": 35,
                "sg_amt": 3500,
                "smg_perc": 55,
                "smg_amt": 5500,
                "tlm_perc": 10,
                "tlm_amt": 1000
            }
        };
        drawStackedBar([
            [data["expected"]["sg_perc"]],
            [data["expected"]["smg_perc"]],
            [data["expected"]["tlm_perc"]]
        ], "#chart-expected");
        drawStackedBar([
            [data["received"]["sg_perc"]],
            [data["received"]["smg_perc"]],
            [data["received"]["tlm_perc"]]
        ], "#chart-received");

        var tpl = swig.compile($('#tpl-grants').html());
        var html = tpl({
            "grants": data["expected"]
        });
        $('#dise-expected').html(html);
        html = tpl({
            "grants": data["received"]
        });
        $('#dise-received').html(html);
    }

    function drawStackedBar(data, element_id) {
        new Chartist.Bar(element_id, {
            labels: [''],
            series: data
        }, {
            stackBars: true,
            horizontalBars: true,
            axisX: {
                showGrid: false
            },
            axisY: {
                showGrid: false,
                labelInterpolationFnc: function(value) {
                    return '';
                }
            }
        }).on('draw', function(data) {
            if (data.type === 'bar') {
                data.element.attr({
                    style: 'stroke-width: 20px'
                });
            }
        });
    }

    function renderInfra(schoolType) {
        var tpl = swig.compile($('#tpl-infra-summary').html());

        var facilities = [{
            'facility': 'All weather pucca building',
            'icon': ['fa fa-university'],
            'percent': 70,
            'total': 10
        }, {
            'facility': 'Playground',
            'icon': ['fa fa-futbol-o'],
            'percent': 50,
            'total': 10
        }, {
            'facility': 'Drinking Water',
            'icon': ['fa  fa-tint'],
            'percent': 30,
            'total': 10
        }, {
            'facility': 'Toilets',
            'icon': ['fa fa-male', 'fa fa-female'],
            'percent': 20,
            'total': 20
        }];
        if (schoolType == "school") {
            facilities = facilities.concat(
                [{
                    'facility': 'Library',
                    'icon': ['fa fa-book'],
                    'percent': 70,
                    'total': 10
                }, {
                    'facility': 'Secure Boundary Wall',
                    'icon': ['fa fa-circle-o-notch'],
                    'percent': 80,
                    'total': 10
                }, {
                    'facility': 'Electricity',
                    'icon': ['fa fa-plug'],
                    'percent': 10,
                    'total': 10
                }, {
                    'facility': 'Mid-day Meal',
                    'icon': ['fa fa-spoon'],
                    'percent': 90,
                    'total': 10
                }, {
                    'facility': 'Computers',
                    'icon': ['fa fa-laptop'],
                    'percent': 15,
                    'total': 10
                }])

        } else {
            facilities = facilities.concat(
                [{
                    'facility': 'Healthy and Timely Meal',
                    'icon': ['fa fa-cutlery'],
                    'percent': 70,
                    'total': 10
                }, {
                    'facility': 'Functional Bal Vikas Samithis',
                    'icon': ['fa fa-users'],
                    'percent': 80,
                    'total': 10
                }])
        }

        var html = '<div class="page-parent">'
        for (var pos in facilities) {
            html = html + tpl(facilities[pos]);
        }
        var prefix = '';
        if (schoolType == "preschool") {
            prefix = "ang-"
        }
        $('#' + prefix + 'infra-summary').html(html + '</div>');

    }

    function renderPrograms(data, schoolType) {
        var tpl = swig.compile($('#tpl-program-summary').html());               
        var html = '<div class="page-parent">'
        for (var program in data) {
            html = html + '<div class="third-column">' + '<div class="heading-tiny-uppercase">' + program + '</div>' + tpl({
                "programs": data[program]
            }) + '</div>';
        }
        var prefix = '';
        if (schoolType == "preschool") {
            prefix = "ang-"
        }
        $('#' + prefix + 'program-summary').html(html + '</div>');
    }

})();