(function() {

    klp.init = function() {
        klp.router = new KLPRouter({});
        klp.router.init();
        klp.volunteer_map.init();
        klp.volunteer_here.init();
        //klp.volunteer_date_modal.init();
        init_volunteer_date_filter();
        $(document).on("click", ".js-toggle-filters", function(){
            //console.log("here 2");
            $(".js-volunteer-filters-wrapper").toggleClass("filter-toggle");
        });
        //klp.volunteer_date_modal.open();
        klp.router.start();
        klp.volunteer_map.applyFilters();
    };

    function init_volunteer_date_filter(){
        //console.log("initting date filter");
        var $date_input = $("#vol-date-input");


        var $datesXHR = klp.api.do('volunteer_activity_dates');
        $datesXHR.done(function(data) {
            //FIXME: this code fetches valid dates and sets disabled dates on datepicker
            //but its ugly as all hell and needs some love.
            var dates = data.features;
            var enabledArray = _.map(dates, function(dateString) {
                var dateArray = dateString.split("-");
                var dateArrayInts = _.map(dateArray, function(d) {
                    return parseInt(d);
                });

                //months in js are 0-indexed, so minus one from month
                dateArrayInts[1] = dateArrayInts[1] - 1;
                return dateArrayInts;
            });
            var optsArray = [true];

            _.each(enabledArray, function(dateArray) {
                var dateObj = new Date(dateArray[0], dateArray[1], dateArray[2]);
                optsArray.push(dateObj);
            });
            $date_input.pickadate({
                //format: 'yyyy-mm-dd',
                formatSubmit: 'yyyy-mm-dd',
                hiddenName: true,
                onSet: function(thingSet) {
                    klp.volunteer_map.applyFilters();
                },
                disable: optsArray
            });
        });

    }


})();
