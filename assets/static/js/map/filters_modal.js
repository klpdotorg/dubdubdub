(function() {

    var t = klp.filters_modal = {},
        $_filter_button,
        $trigger,
        template;

    t.init = function() {
        $trigger = $('<div />');
        $trigger.rbox({
            'type': 'inline',
            'inline': '#tpl-filters-modal',
            'onopen': onOpen,
            'onclose': t.close
        });
    };

    var onOpen = function() {
        console.log("onOpen rbox");
        // $('.js-filters-dropdown').select2();
        var $select_type = $("#select-type");
        var $select_district = $("#select-district");
        var $select_block = $("#select-block");
        var $select_cluster = $("#select-cluster");
        var $select_school = $("#select-school");
        var $download_button = $("#download");

        $select_type.select2();
        // $select_district.select2();

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

        $select_type.on("change", function(selected) {
            console.log("select type changed");
            if (selected.val == 'Primary School') {
                districtsXHR('primaryschools').done(function (data) {
                    populateSelect($select_district, data);
                });
            }

            if (selected.val == 'Preschool') {
                districtsXHR('preschools').done(function (data) {
                    populateSelect($select_district, data);
                });
            }
        });

        $select_district.on("change", function(selected) {
            setMapView(selected, 8);
            var blockXHR = klp.api.do('boundary/admin1/'+selected.val+'/admin2', {'geometry': 'yes', 'per_page': 0});
            blockXHR.done(function (data) {
                populateSelect($select_block, data);
            });
        });

        $select_block.on("change", function(selected) {
            setMapView(selected, 9);
            var clusterXHR = klp.api.do('boundary/admin2/'+selected.val+'/admin3', {'geometry': 'yes', 'per_page': 0});
            clusterXHR.done(function (data) {
                populateSelect($select_cluster, data);
            });
        });

        $select_cluster.on("change", function(selected) {
            setMapView(selected, 10);
            var schoolXHR = klp.api.do('schools/info', {'admin3':selected.val, 'geometry': 'yes', 'per_page': 0});
            $download_button.attr('href', '/api/v1/schools/info?admin3='+selected.val+'&format=csv');
            $download_button.removeClass('hide');
            schoolXHR.done(function (data) {
                // console.log('schools', data);
                populateSelect($select_school, data);
            });
        });

        $select_school.on("change", function(selected) {
            setMapView(selected, 13);
            // FIXME: make this a close function. This is Sanjay's fault.
            $('.btn-modal-close').click();
            var schoolType = selected.added.properties.type.name.toLowerCase().replace(' ', '');
            // console.log(schoolType);
            klp.router.setHash(null, {marker: schoolType+'-'+selected.val}, {trigger:true});
        });

        function setMapView(selection, zoom) {
            if (_.isEmpty(selection.added.geometry)) {
                klp.utils.alertMessage('No location data');
            } else {
                var selectedLatlng = L.latLng(selection.added.geometry.coordinates[1], selection.added.geometry.coordinates[0]);
                klp.map.map.setView(selectedLatlng, zoom);
            }
        }
    };

    t.setFilter = function(filterName, selectedValue) {
        // console.log("set " + filterName + " to " + selectedValue);
    };

    t.open = function() {
        console.log("open filter modal");
        klp.openModal = t;
        $trigger.click();
        // var $modal_overlay = $("#modal_overlay");
        // var $modal = $(".modal-map-filter");
        // $modal_overlay.addClass("show");
        // $modal.addClass("show");
    };

    t.close = function() {
        var $filter_toggle = $(".js-filter-tool");
        $filter_toggle.removeClass('active');
    };






    //     toggleList: function(obj) {
    //         var state_open = false;
    //         if ($(obj).parent().find('.item_values').hasClass('open')) {
    //             state_open = true;
    //         }
    //         $('.item_values').removeClass('open');
    //         if (state_open) {
    //             $(obj).parent().find('.item_values').removeClass('open');
    //         } else {
    //             $(obj).parent().find('.item_values').addClass('open');
    //         }
    //         //$(obj).parent().find('.item_values').toggleClass('open');
    //         //event.stopPropagation();
    //     },

    //     select: function(obj) {
    //         return false;
    //         window.location = "{{ site_url }}status_3.php";
    //         // var parent_option_item = $(obj).parent().parent().parent().parent().parent();
    //         // $(parent_option_item).find('.item_values').toggleClass('open');
    //         // $(parent_option_item).find('.value').text($(obj).text());
    //         //return false;
    //     }
    // }

})();
