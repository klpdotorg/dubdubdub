(function() {
    var klp = window.klp;
    klp.init = function() {

        klp.volunteer_date_filter.init();
        klp.option_items.init();
        klp.map.init();
        klp.place_info.init();
        klp.comparison.init();
        klp.share_story.init();
        klp.volunteer_modal.init();

        $('html').click(function() {
            //Hide the menus if visible
            $('.item_values').removeClass('open');
        });

        $(document).on("click", ".map-tools .tool", function(e) {
            var $tool = $(this);
            $tool.toggleClass("active");
        });

        // $(document).ready(function(){
        // });

        klp._tpl = klp.utils.compile_templates();
        klp.router.init();
    };    

})();