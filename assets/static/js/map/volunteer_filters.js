(function() {
    var t = klp.volunteer_filters = {},
        $date_input,
        $calender_wrapper,
        $datepicker_wrapper;

    t.init = function() {
        // $(document).on("click", ".js-volunteer-trigger", function(e){
        //     e.preventDefault();
        //     t.show();
        // });
        $('.volunteer-filters-dropdown').easyDropDown({
            onChange: function(selected) {
                var filterName = $(this).attr('name');
                var selectedValue = selected.value;
                t.setFilter(filterName, selectedValue);
            }
        });

        $date_input = $("#vol-date-input");
        $calender_wrapper = $('.js-volunteer-cal');
        $datepicker_wrapper = $calender_wrapper.find(
            "#vol-datepicker-wrapper");
        $date_input.Zebra_DatePicker({
            always_visible: $datepicker_wrapper,
            format: 'd-m-Y',
            first_day_of_week: 0,
            show_clear_date: false,
            show_select_today: false,
            disabled_dates: ['1,3,4,5,12,13,14,22,24'],
            onSelect: onDateSelect,
            onClear: onDateClear
        });
        $(document).on("click", ".js-volunter-date-input-wrapper", function() {
            $(".js-volunteer-cal").toggleClass("show");
        });
    };

    function onDateSelect(date) {
        $date_input.val(date);
        $calender_wrapper.removeClass("show");
        t.setFilter('date', date);
        // $btn_next_step_cal.show();
    };

    function onDateClear() {
        t.setFilter('date', '');
        // $date_input.val("");
        // $btn_next_step_cal.hide();
    };

    t.setFilter = function(filterName, selectedValue) {
        console.log("set " + filterName + " to " + selectedValue);
    };

    t.show = function() {
        $(".map-subheader-wrapper").addClass("show-volunteer-filters");
    };

})();