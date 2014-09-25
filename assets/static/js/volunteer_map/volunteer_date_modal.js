(function() {
    var t = klp.volunteer_date_modal = {};
    var datepicker;
    t.init = function() {
        var $modal = $('.volunteerDateModal');
        var $datepicker_input = $modal.find('#datepicker-modal-input');

        $datepicker_input.Zebra_DatePicker({
            always_visible: $modal.find('#datepicker-modal-wrapper'),
            first_day_of_week: 0,
            show_clear_date: false,
            show_select_today: false,
            //disabled_dates: ['* * * *'],
            onSelect: onDateSelect,
            onClear: onDateClear,
            format: 'Y-m-d'
        });
        datepicker = $datepicker_input.data('Zebra_DatePicker');
        var $datesXHR = klp.api.do('volunteer_activity_dates');
        $datesXHR.done(function(data) {
            datepicker.update({
                //disabled_dates: ['* * * *'],
                enabled_dates: data.features
            });
        });
    };

    t.open = function() {
        $('.volunteerDateModal').addClass('show');
    };

    t.close = function() {
        $('.volunteerDateModal').removeClass('show');
        $('.modal-overlay').removeClass('show');
    };

    function onDateSelect(date) {
        console.log("date selected", date);
    }

    function onDateClear() {

    }

})();