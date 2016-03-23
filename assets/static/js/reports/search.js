'use strict';
(function() {
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
        initSelect2();
        $(".box").hide();
        $(".report-list").hide();
        $(document).ready(function(){
            $('input[type="radio"]').click(function(){
                if($(this).attr("value")=="edu"){
                    $(".box").not(".educational").hide();
                    $(".educational").show();
                    initEduSearch();
                }
                if($(this).attr("value")=="elec"){
                    $(".box").not(".electoral").hide();
                    $(".electoral").show();
                }
            });
            $(".js-example-basic-single").select2();
            $(".js-example-basic-single").change(function(){
               $(".report-list").show();
            });
        });
        
    }


    function format(item) {
        return _.str.titleize(item.properties.name);
    }

    function populateSelect(container, data) {
        data.features.forEach(function(d) {
            d.id = d.properties.id;
        });
        container.select2({
            sortResults: function(results) {
                return _.sortBy(results, function(result) {
                    return result.properties.name;
                });
            },
            data: {
                results: data.features,
                text: function(item) {
                    return item.properties.name;
                }
            },
            formatSelection: format,
            formatResult: format,
        });
    }


    function initEduSearch() {
        var $select_district = $("#select-district");
        var $select_block = $("#select-block");
        var $select_cluster = $("#select-cluster");

        var districtsXHR = klp.api.do('boundary/admin1s', {'school_type':"primaryschool", 'geometry': 'yes'});
        districtsXHR.done(function (data) {
            populateSelect($select_district, data);
        });

        $select_district.on("change", function(selected) {
            console.log(selected.val);
            var blockXHR = klp.api.do('boundary/admin1/'+selected.val+'/admin2', {'geometry': 'yes', 'per_page': 0});
            blockXHR.done(function (data) {
                populateSelect($select_block, data);
            });
        });

        $select_block.on("change", function(selected) {
            var clusterXHR = klp.api.do('boundary/admin2/'+selected.val+'/admin3', {'geometry': 'yes', 'per_page': 0});
            clusterXHR.done(function (data) {
                populateSelect($select_cluster, data);
            });
        });

        $select_cluster.on("change", function(selected) {
            var schoolXHR = klp.api.do('schools/info', {'admin3':selected.val, 'geometry': 'yes', 'per_page': 0});
            schoolXHR.done(function (data) {
                // console.log('schools', data);
                populateSelect($select_school, data);
            });
        });
    }

    function makeResults(array, type) {
        var schoolDistrictMap = {
            'primaryschool': 'Primary School',
            'preschool': 'Preschool'
        };
        return _(array).map(function(obj) {
            var name = obj.properties.name;
            if (type === 'boundary') {
                if (obj.properties.type === 'district') {
                    name = obj.properties.name + ' - ' + schoolDistrictMap[obj.properties.school_type] + ' ' + obj.properties.type;
                } else {
                    name = obj.properties.name + ' - ' + obj.properties.type;
                }
            }

            obj.entity_type = type;
            return {
                id: obj.properties.id,
                text: _.str.titleize(name),
                data: obj
            };
        });
    }


    function initSelect2() {
        $('#select2search').select2({
            placeholder: 'Search for schools and boundaries',
            minimumInputLength: 3,
            ajax: {
                url: "/api/v1/search",
                quietMillis: 300,
                allowClear: true,
                data: function(term, page) {
                    return {
                        text: term,
                        geometry: 'yes'
                    };
                },
                results: function(data, page) {
                    var searchResponse = {
                        results: [{
                            text: "Pre-Schools",
                            children: makeResults(data.pre_schools.features, 'school')
                        }, {
                            text: "Primary Schools",
                            children: makeResults(data.primary_schools.features, 'school')
                        }, {
                            text: "Boundaries",
                            children: makeResults(data.boundaries.features, 'boundary')
                        }]
                    };
                    return {
                        results: searchResponse.results
                    };
                }
            }
        });
    }

    function fillSelect2(entityDetails) {
        if (entityDetails.name == '') {
            $('#select2search').select2("data", null);
            return;
        }
        var currentData = $('#select2search').select2("data");

        var boundaryTypes = ['district', 'block', 'cluster', 'circle', 'project'];
        if (boundaryTypes.indexOf(entityDetails.type) !== -1) {
            var typ = 'boundary';
        } else {
            var typ = 'school';
        }
        var obj = entityDetails.obj;
        if (!obj.hasOwnProperty('properties')) {
            obj = {
                'properties': obj
            };
        }
        var dataObj = makeResults([obj], typ)[0];
        $('#select2search').select2("data", dataObj);
    }
 
})();

