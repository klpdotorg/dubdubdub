/*
    Small jQuery plugin to handle the year-month widget we are using
    for date filters that require only month and year.

    Is tied to KLP markup and use-case, if someone wants to make it more
    generalized, please go ahead :)

    Is passed a "command" and options (no options actually exist currently).
    
    Depends on moment.js

    Valid commands are:
        init
            init initializes the selects with the months and valid years
        getDate
            getDate returns a string in YYYY-MM-DD format of last day
            of month selected

    Example usage:
        $('#startDateContainer').yearMonthSelect("init");
        var date = $('#startDateContainer').yearMonthSelect("getDate");
 */

(function($) {
    var MONTHS = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ];

    //TODO: move to settings or at least generate last year dynamically
    var VALID_YEARS = [
        "2011",
        "2012",
        "2013",
        "2014",
        "2015"
    ];

    $.fn.yearMonthSelect = function(cmd, options) {
        var funcs = {
            'init': init,
            'getDate': getDate,
            'setDate': setDate
        };
        return funcs[cmd].call(this, options);
    };

    function init(options) {
        var monthSelect = this.find("select.month");
        _(MONTHS).each(function(month, index) {
            var $option = $('<option />')
                              .text(month)
                              .prop("value", index);
            monthSelect.append($option);
        });
        var yearSelect = this.find("select.year");
        _(VALID_YEARS).each(function(year, index) {
            var $option = $('<option />')
                              .text(year)
                              .prop("value", year);
            yearSelect.append($option);
        });
        return true;
    }

    function getDate(options) {
        var monthVal = parseInt(this.find("select.month").val());
        var yearVal = parseInt(this.find("select.year").val());

        //http://stackoverflow.com/questions/222309/calculate-last-day-of-month-in-javascript
        if (monthVal === 11) {
            yearVal++;
            monthVal = 0;
        }
        var date = new Date(yearVal, monthVal + 1, 0);
        return moment(date).format("YYYY-MM-DD");
    }

    function setDate(date) {
        var year = date.year();
        var month = date.month();
        this.find("select.year").val(year);
        this.find("select.month").val(month);
        return this;
    }

})(jQuery);