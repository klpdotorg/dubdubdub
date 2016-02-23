'use strict';
(function() {
    var klp = window.klp;
    klp.init = function() {
        klp.search_mode = false;

        klp.router.init();
        klp.filters_modal.init();
        //klp.login_modal.init();
        klp.map.init();
        klp.place_info.init();
        klp.comparison.init();
        klp.share_story.init();
        // klp.volunteer_modal.init();
        // klp.volunteer_filters.init();

        $('html').click(function() {
            //Hide the menus if visible
            $('.item_values').removeClass('open');
        });

        $(document).on("click", ".map-tools .tool", function(e) {
            var $tool = $(this);
            $tool.toggleClass("active");
        });
        $(".js-select-multiple").select2({
        });
        // $(document).ready(function(){
        // });

        klp._tpl = klp.utils.compile_templates();
        klp.router.start();
    };

})();
