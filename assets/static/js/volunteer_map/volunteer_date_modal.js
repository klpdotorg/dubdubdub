(function() {
    var t = klp.volunteer_date_modal = {};

    t.init = function() {
        var $modal = $('.volunteerDateModal');
        var $datepicker_input = $modal.find('#datepicker-modal-input');

        $datepicker_input.Zebra_DatePicker({
            always_visible: $modal.find('#datepicker-modal-wrapper'),
            first_day_of_week: 0,
            show_clear_date: false,
            show_select_today: false,
            disabled_dates: ['1,3,4,5,12,13,14,22,24'],
            onSelect: onDateSelect,
            onClear: onDateClear
        });
        var datepicker = $datepicker_input.data('Zebra_DatePicker');
    };

    t.open = function() {
        $('.volunteerDateModal').addClass('show');
    };

    t.close = function() {
        $('.volunteerDateModal').removeClass('show');
    };

    function onDateSelect() {

    }

    function onDateClear() {

    }

})();