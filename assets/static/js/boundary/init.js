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
        renderGenderCharts();
        renderCategories();
        renderLanguages();
        renderEnrolment();
        renderGrants();
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

    function renderGenderCharts(){
        var data =  
            {"klp": {
                'girl_count': 1000,
                'girl_perc': 33,
                "boy_count": 2000,
                "boy_perc": 66,
                "align":"right"
            }, 
            "dise" : {
                'girl_count': 1500,
                'girl_perc': 50,
                "boy_count": 1500,
                "boy_perc": 50,
                "align":"left"
            }
            
        };
        var tpl = swig.compile($('#tpl-gender-summary').html());
        var gender = {"gender":data["klp"]};
        var html = tpl(gender);
        $('#klp-gender').html(html);   
        gender = {"gender":data["dise"]};
        html = tpl(gender);
        $('#dise-gender').html(html);  
    }

    function renderCategories(){
        var data = { 
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
                "dise_count": 62            }
            
        };
        var tpl = swig.compile($('#tpl-category-summary').html());
        var html = tpl({"categories":data});
        $('#category-summary').html(html);  
    }

    function renderLanguages(){
        var data = { 
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
            
        };
        var tpl = swig.compile($('#tpl-language').html());
        var html = tpl({"languages":data});
        $('#klp-language').html(html);  
    }

    function renderEnrolment(){
        var data = { 
            "model primary": {
                "type_name":"model primary",
                "count": 2000,
                "perc": 21,
                "avg": 80
            },
            "upper primary": {
                "type_name":"upper primary",
                "count": 4000,
                "perc": 80,
                "avg": 100
            },
            "lower primary": {
                "type_name":"lower primary",
                "count": 1000,
                "perc": 19,
                "avg": 90          
            }
            
        };
        var tpl = swig.compile($('#tpl-enrolment').html());
        var html = tpl({"categories":data});
        $('#dise-enrolment').html(html);  
    }

    function renderGrants(){
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
        drawStackedBar([ [data["expected"]["sg_perc"]],
                         [data["expected"]["smg_perc"]],
                         [data["expected"]["tlm_perc"]]
                       ],"#chart-expected");
        drawStackedBar([ [data["received"]["sg_perc"]],
                         [data["received"]["smg_perc"]],
                         [data["received"]["tlm_perc"]]
                       ],"#chart-received");
        
        var tpl = swig.compile($('#tpl-grants').html());
        var html = tpl({"grants":data["expected"]});
        $('#dise-expected').html(html); 
        html = tpl({"grants":data["received"]});
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
                return (value / 1000) + 'k';
            }
        }
        }).on('draw', function(data) {
            if(data.type === 'bar') {
                data.element.attr({
                    style: 'stroke-width: 30px'
                });
            }
        });
    }

})();


