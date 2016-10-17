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
        //console.log("onOpen rbox");
        // $('.js-filters-dropdown').select2();
        var $select_district = $("#select-district");
        var $select_block = $("#select-block");
        var $select_cluster = $("#select-cluster");
        var $select_school = $("#select-school");
        var $search_button = $("#search");

       
        //$select_type.select2();
        // $select_district.select2();
        
        var districtsXHR = klp.api.do('stories/meta?source=sms');
        districtsXHR.done(function(data) {
            var districts = {"features": []}
            for (var each in data["sms"]["gka_districts"])
            {
                districts["features"].push(data["sms"]["gka_districts"][each])
            } 
            //console.log(districts);
            populateSelect($select_district, districts);
        });
       
 

        function format(item) {
            return _.str.titleize(item.name);
        }

        function populateSelect(container, data) {
            //console.log(data);
            data.features.forEach(function(d) {
                d.id = d.id;
            });
            
            container.select2({
                sortResults: function(results) {
                    return _.sortBy(results, function(result) {
                        return result.name;
                    });
                },
                data: {
                    results: data.features,
                    text: function(item) {
                        return item.name;
                    }
                },
                formatSelection: format,
                formatResult: format,
            });
        }

        $select_district.on("change", function(selected) {
            //console.log(selected.val);
            var blockXHR = klp.api.do('boundary/admin1/'+selected.val+'/admin2', {'geometry': 'no', 'per_page': 0});
            $search_button.attr('href', '/gka/#searchmodal?admin1='+selected.val);
            blockXHR.done(function (data) {
                populateSelect($select_block, data);
            });
        });

        $select_block.on("change", function(selected) {
            var clusterXHR = klp.api.do('boundary/admin2/'+selected.val+'/admin3', {'geometry': 'no', 'per_page': 0});
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
                var tx_data = {"features":[]}
                for (var each in data.features) {
                    tx_data["features"].push(data.features[each].properties)
                }
                console.log(tx_data)
                populateSelect($select_school, tx_data);
            });
        });

        $select_school.on("change", function(selected) {
            // FIXME: make this a close function. This is Sanjay's fault.
            $('.btn-modal-close').click();
            $search_button.attr('href', '/gka/#searchmodal?school_id=' + selected.val + '&school_type=Primary School');
            var schoolType = selected.added.type.name.toLowerCase().replace(' ', '');
            // console.log(schoolType);
            //klp.router.setHash(null, {marker: schoolType+'-'+selected.val}, {trigger:true});
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
