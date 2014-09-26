(function() {

    klp.init = function() {
        klp.router = new KLPRouter({});
        klp.router.init();
        klp.volunteer_map.init();
        klp.volunteer_here.init();
        klp.volunteer_date_modal.init();
        init_volunteer_date_filter();
        $(document).on("click", ".js-toggle-vol-mobile-filters", function(){
            //console.log("here 2");
            $(".volunteer-filters-wrapper").toggleClass("show-mobile");
        });
        klp.volunteer_date_modal.open();
        klp.router.start();
    };

    function init_volunteer_date_filter(){
        console.log("initting date filter");
        var $date_input = $("#vol-date-input");
        var $calender_wrapper = $('.js-volunteer-cal');
        var $datepicker_wrapper = $calender_wrapper.find("#vol-datepicker-wrapper");

        $date_input.Zebra_DatePicker({
            always_visible: $datepicker_wrapper,
            format: 'Y-m-d',
            first_day_of_week: 0,
            show_clear_date: false,
            show_select_today: false,
            //disabled_dates: ['1,3,4,5,12,13,14,22,24'],
            onSelect: onDateSelect,
            onClear: onDateClear
        });
     // var datepicker = $datepicker_input.data('Zebra_DatePicker');

        function onDateSelect(date){
            $date_input.val(date);
            $calender_wrapper.removeClass("show");
            klp.volunteer_map.applyFilters();
         // $btn_next_step_cal.show();
        }

        function onDateClear(){
            $date_input.val("");
            $btn_next_step_cal.hide();
        }


        $(document).on("click", ".js-volunter-date-input-wrapper", function(){
            $(".js-volunteer-cal").toggleClass("show");
        });

    }


})();