(function() {
    var t = klp.volunteer_date_modal = {};
    var datepicker;
    var $datepicker_input;
    t.init = function() {
        var $modal = $('.jsVolunteerDateModal');
        $datepicker_input = $modal.find('#datepicker-modal-input');
        var $datesXHR = klp.api.do('volunteer_activity_dates');
        $datesXHR.done(function(data) {
            $datepicker_input.Zebra_DatePicker({
                always_visible: $modal.find('#datepicker-modal-wrapper'),
                format: 'Y-m-d',
                first_day_of_week: 0,
                show_clear_date: false,
                direction: [true, 92],
                disabled_dates: getDisableDates(data.features),
                show_select_today: false,
                onSelect: onDateSelect,
                onClear: onDateClear,
            });
            datepicker = $datepicker_input.data('Zebra_DatePicker');
        });
    };

    t.open = function() {
        $('.jsVolunteerDateModal').addClass('show');
        klp.openModal = t;
    };

    t.close = function() {
        $('.jsVolunteerDateModal').removeClass('show').remove(); //FIXME
        //^ we remove this from the DOM because otherwise there's some 
        //weirdo visible child that remains clickable
        //ideally, fix this properly.
        
        $('.modal-overlay').removeClass('show');
    };

    function onDateSelect(date) {
        t.close();
        $('#vol-date-input').val(date);
        klp.volunteer_map.applyFilters();
    }

    function onDateClear() {

    }

    function getDisableDates(currentDates) {
        var today = moment().format('YYYY-MM-DD');
        var threeMonths = [];
        for (var i=1; i<92; i++) {
            threeMonths.push(moment().add(i, 'days').format('YYYY-MM-DD'));
        }
        var disabledDates = _.difference(threeMonths, currentDates);
        var disabledDatesFormatted = [];
        disabledDates.forEach(function (element) {
            disabledDatesFormatted.push(moment(element).format('D M YYYY'));
        });
        return disabledDatesFormatted;
    }
})();