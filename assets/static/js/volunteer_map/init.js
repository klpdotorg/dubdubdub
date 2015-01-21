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

        $date_input.pickadate({
            format: 'yyyy-mm-dd',
            formatSubmit: 'yyyy-mm-dd',
            onSet: function(thingSet) {
                klp.volunteer_map.applyFilters();
            }
        });


    }


})();
