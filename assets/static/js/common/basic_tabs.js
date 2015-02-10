/*
    Handles JS for non-ajax tabs
 */
(function() {
    var t = klp.basic_tabs = {};
    t.init = function() {
        $('.js-tabs-link').each(function() {
            var $this = $(this);
            var $clone = $this.clone();
            var tabName = $this.attr("data-tab");
            $('.js-tab-content[data-tab=' + tabName + ']').before($clone);
        });

        $(document).on("click", ".js-tabs-link", function(e){
            var $wrapper = $(".js-tab-wrap");
            var $trigger = $(this).closest(".js-tabs-link");
            var tab_id = $trigger.attr('data-tab');

            $(".tab-heading-active").removeClass('tab-heading-active');
            $('.tab-heading[data-tab=' + tab_id + ']').addClass('tab-heading-active');

            $wrapper.find(".js-tab-content.tab-active").removeClass('tab-active');
            $wrapper.find('.js-tab-content[data-tab="'+ tab_id +'"]').addClass('tab-active');

            //on mobile, scroll to top of accordion
            var $accordionTrigger = $('.tab-each .tab-heading-active');
            if ($accordionTrigger.is(":visible")) {
                var headerHeight = $('.main-header').outerHeight();
                var offsetTop = $accordionTrigger.offset().top - headerHeight;
                $('html, body').animate({
                    scrollTop: offsetTop
                });
            }
        });
    };

})();