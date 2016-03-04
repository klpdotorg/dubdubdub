(function() {

    var t = klp.gka_filters_modal = {},
        $_filter_button,
        $trigger,
        template;

    t.init = function() {
        $('.btn-modal-close').click();
        $trigger = $('<div />');
        $trigger.rbox({
            'type': 'inline',
            'inline': '#tpl-gka-filters-modal',
            'onopen': onOpen,
            'onclose': t.close
        });
    };

    var onOpen = function() {
        console.log("onOpen rbox");
        // $('.js-filters-dropdown').select2();
        var $select_district = $("#select-district");
        var $select_block = $("#select-block");
        var $select_cluster = $("#select-cluster");
        var $select_school = $("#select-school");
        var $search_button = $("#search");

       
        //$select_type.select2();
        // $select_district.select2();
        var data = {"count": 6, "next": null, "previous": null, "type": "FeatureCollection", "features": [ {"geometry": {"type": "Point", "coordinates": [76.53, 15.11]}, "type": "Feature", "properties": {"id": 424, "name": "bellary", "type": "district", "school_type": "primaryschool"}}, {"geometry": {"type": "Point", "coordinates": [77.23, 17.95]}, "type": "Feature", "properties": {"id": 417, "name": "bidar", "type": "district", "school_type": "primaryschool"}}, {"geometry": {"type": "Point", "coordinates": [76.88, 17.05]}, "type": "Feature", "properties": {"id": 416, "name": "gulbarga", "type": "district", "school_type": "primaryschool"}}, {"geometry": {"type": "Point", "coordinates": [76.22, 15.56]}, "type": "Feature", "properties": {"id": 419, "name": "koppal", "type": "district", "school_type": "primaryschool"}}, {"geometry": {"type": "Point", "coordinates": [76.89, 16.09]}, "type": "Feature", "properties": {"id": 418, "name": "raichur", "type": "district", "school_type": "primaryschool"}}, {"geometry": {"type": "Point", "coordinates": [75.69, 13.45]}, "type": "Feature", "properties": {"id": 445, "name": "yadgiri", "type": "district", "school_type": "primaryschool"}}]};
        populateSelect($select_district, data);

        var districtsXHR = function(school_type) {
            return klp.api.do('boundary/admin1s', {'school_type':school_type, 'geometry': 'yes'});
        };


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

        $select_district.on("change", function(selected) {
            console.log(selected.val);
            var blockXHR = klp.api.do('boundary/admin1/'+selected.val+'/admin2', {'geometry': 'yes', 'per_page': 0});
            $search_button.attr('href', '/gka/#searchmodal?admin1='+selected.val);
            blockXHR.done(function (data) {
                populateSelect($select_block, data);
            });
        });

        $select_block.on("change", function(selected) {
            var clusterXHR = klp.api.do('boundary/admin2/'+selected.val+'/admin3', {'geometry': 'yes', 'per_page': 0});
            $search_button.attr('href', '/gka/#searchmodal?admin2='+selected.val);
            clusterXHR.done(function (data) {
                populateSelect($select_cluster, data);
            });
        });

        $select_cluster.on("change", function(selected) {
            var schoolXHR = klp.api.do('schools/info', {'admin3':selected.val, 'geometry': 'yes', 'per_page': 0});
            $search_button.attr('href', '/gka/#searchmodal?admin3='+selected.val);
            schoolXHR.done(function (data) {
                // console.log('schools', data);
                populateSelect($select_school, data);
            });
        });

        $select_school.on("change", function(selected) {
            // FIXME: make this a close function. This is Sanjay's fault.
            $('.btn-modal-close').click();
            $search_button.attr('href', '/gka/#searchmodal?school_id=' + selected.val + '&school_type=Primary School');
            var schoolType = selected.added.properties.type.name.toLowerCase().replace(' ', '');
            // console.log(schoolType);
            klp.router.setHash(null, {marker: schoolType+'-'+selected.val}, {trigger:true});
        });

    };

    t.setFilter = function(filterName, selectedValue) {
        // console.log("set " + filterName + " to " + selectedValue);
    };

    t.open = function() {
        console.log("open filter modal");
        klp.openModal = t;
        $trigger.click();
    };

    t.close = function() {
        var $filter_toggle = $(".js-filter-tool");
        $filter_toggle.removeClass('active');
    };

})();
