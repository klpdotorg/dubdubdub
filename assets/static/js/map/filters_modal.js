(function() {

    var t = klp.filters_modal = {},
        $_filter_button;

    t.init = function() {
        $_filter_button = $("#filter-button");
        $_filter_button.on("click", t.open);
        $('.filters-dropdown').select2();
        // $('.filters-dropdown').easyDropDown({
        //     onChange: function(selected) {
        //         var filterName = $(this).attr('name');
        //         var selectedValue = selected.value;
        //         t.setFilter(filterName, selectedValue);
        //     }
        // });
        // $('.option_item .item_values ul').slimScroll({
        //     height: '200px',
        //     size: '6px',
        //     color: '#8d8d8d',
        //     railVisible: true,
        //     railColor: '#f6f6f6',
        //     railOpacity: 1
        // });
        var $select_district = $("#select-districts");
        var $select_school = $("#select-school");

        var districtsXHR = function(school_type) {
            return klp.api.do('boundary/admin1s', {'school_type':school_type});
        };

        function format(item) { 
            return _.str.titleize(item.name); 
        };

        $select_school.on("change", function(selected) {
            if (selected.val == 'Primary School') {
                districtsXHR('primaryschools').done(function (data) {
                    $select_district.select2({
                        data: {
                            results: data.features,
                            text: function(item) {
                                return item.name;
                            }
                        },
                        formatSelection: format,
                        formatResult: format,
                        width: 'element'
                    });
                });      
            }

            if (selected.val == 'Preschool') {
                districtsXHR('preschools').done(function (data) {
                    console.log('preschool', data);
                });
            }
        });


    };

    t.setFilter = function(filterName, selectedValue) {
        console.log("set " + filterName + " to " + selectedValue);
    };

    t.open = function() {
        klp.openModal = t;
        var $modal_overlay = $("#modal_overlay");
        var $modal = $(".modal-map-filter");      
        $modal_overlay.addClass("show");
        $modal.addClass("show");
    };

    t.close = function() {
        var $filter_toggle = $(".filter-tool");
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