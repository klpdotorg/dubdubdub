(function() {
    klp.data = {};
    klp.openModal = null;

    // tabs function
    function init_tabs(){
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
        });
    }

    $(document).ready(function() {
        $(document).on('click', ".btn-modal-close", function(e){
            e.preventDefault();

            var $modal = $(e.target).closest(".modal").removeClass("show");
            $(".modal-overlay").removeClass("show");
            if (klp.openModal) {
                klp.openModal.close();
                klp.openModal = null;
            }
        });

        //dropdown navigation
        $(".js-dropdown li:has(ul)").click(function(event){
            event.stopPropagation();
            var thisNav = $(this).closest(".js-dropdown").find('ul');
            $(".js-dropdown ul").not(thisNav).slideUp().closest('.js-dropdown').children('li:has(ul)').removeClass('clicked');
            if (this == event.target || this == $(event.target).parent()[0]) {
                $(this).toggleClass('clicked').children('ul').slideToggle(300);
                $(this).find('li:has(ul)').removeClass('clicked').find("ul").slideUp();
                $(this).siblings().removeClass('clicked').find("ul").slideUp();
                return false;
            }
        }).addClass('has_ul');
    
        $(window).click(function(){        
           $(".js-dropdown ul").slideUp(200).closest('.js-dropdown').children('li:has(ul)').removeClass('clicked');
        });


        //menu on mobile navigation    
        $('.js-nav-trigger').click(function(event){
            event.stopPropagation();
            $('.js-dropdown').toggleClass('nav-open');
        });

        $('.js-dropdown').click(function(event){
            event.stopPropagation();
        });

        $(window).click(function(){
            $('.js-dropdown').removeClass("nav-open");
        });


        //tabs
        init_tabs();

        //datepicker 
        $(".js-input-date").pickadate({
            format: 'yyyy-mm-dd',
            formatSubmit: 'yyyy-mm-dd'
        });

        //iframe videos: responsive        
        $(".video-iframe-responsive").fitVids();


        // Adds easing scrolling to # targets
        $('.js-scroll-smooth-link').click(function(e) {
            e.preventDefault();
            var hash = this.hash;
            var $scrollToElem = $(hash);
            $('html, body').animate({
                scrollTop: $scrollToElem.offset().top - 100
            }, 700);
        });


        //Sticky Scroll 

        //only run if this selector exists on the page
        if($(".js-scroll-smooth-block").length > 0) {
            var stickySelector = $('.js-scroll-smooth-block');

            var headerHeight = $(".main-header").height() + 10;

            var stickyNavTop = stickySelector.offset().top;
            var stickyNav = function(){
                var scrollTop = $(window).scrollTop();
                     
                if ((scrollTop + headerHeight) > stickyNavTop) { 
                    stickySelector.addClass('scroll-smooth-sticky');
                } else {
                    stickySelector.removeClass('scroll-smooth-sticky'); 
                }
            };

            stickyNav();

            $(window).scroll(function() {
                stickyNav();
            });
        }


        
        klp.auth.init();
        klp.login_modal.init();
        if (klp.hasOwnProperty('init')) {
            klp.init();
        }
    });
})();