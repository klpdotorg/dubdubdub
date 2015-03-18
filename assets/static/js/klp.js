/*
    This runs JS required across all pages -
    runs various things inside $(document).ready() and then calls the klp.init()
    method. Each page is responsible to define a klp.init function to run
    page-specific JS.

 */

(function() {

    //can be used by other modules to hold data in memory
    klp.data = {};

    //we will use this in other places to close the currently open modal, etc.
    klp.openModal = null;

    //we need headerHeight in a few places, so we calculate it just once on ready
    var headerHeight;
    $(document).ready(function() {
        headerHeight = $(".main-header").height() + 10;
    });


    $(document).ready(function() {
        //style guide
        $(".style-block").each(function(){  
          $demo = $(this).find('.style-block-demo');
          var code = escapeHtml($demo.html());
          $(this).append("<div class='style-block-code js-toggled'><code><pre>"+ code +  "</pre></code></div>");
        });

        $(".js-toggle").click(function(){
          $(this).parents(".style-block").find(".js-toggled").slideToggle("fast");
        });
        // $(document).on('click', ".btn-modal-close", function(e){
        //     e.preventDefault();

        //     var $modal = $(e.target).closest(".modal").removeClass("show");
        //     $(".modal-overlay").removeClass("show");
        //     if (klp.openModal) {
        //         klp.openModal.close();
        //         klp.openModal = null;
        //     }
        // });

        //dropdown navigation - used for top menu navigation
        $(".js-dropdown li:has(ul)").click(function(event){
            event.stopPropagation();
            var thisNav = $(this).closest(".js-dropdown").find('ul');
            $(".js-dropdown ul").not(thisNav).slideUp().closest('.js-dropdown').children('li:has(ul)').removeClass('clicked');
            if (this == event.target || this == $(event.target).parent()[0]) {
                $(this).toggleClass('clicked').children('ul').slideToggle(200);
                $(this).find('li:has(ul)').removeClass('clicked').find("ul").slideUp();
                $(this).siblings().removeClass('clicked').find("ul").slideUp();
                return false;
            }
        }).addClass('has_ul');

        $('.profile-login-block li:has(ul)').click(function() {
            $('ul.nav').removeClass("nav-open");
        });

        $(".js-dropdown ul li").click(function() {
            $(".js-dropdown li").removeClass("selected");
            $(this).addClass("selected");
        });

        $(window).click(function(){
            //slide up an open menu if user clicks anywhere else on window        
            $(".js-dropdown ul").slideUp(200).closest('.js-dropdown').children('li:has(ul)').removeClass('clicked');
            $('.js-dropdown').removeClass("nav-open");
        });


        //menu on mobile (hamburger menu) navigation    
        $('.js-nav-trigger').click(function(event){
            event.stopPropagation();
            $('.js-dropdown').toggleClass('nav-open');
            $('.profile-login-block ul:visible').hide();
        });

        $('.js-dropdown').click(function(event){
            event.stopPropagation();
        });

        //datepicker
        //FIXME: format issue 
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

            //var headerHeight = $(".main-header").height() + 10;

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


        //initializes the auth and login_modal modules required on all pages   
        klp.auth.init();
        klp.login_modal.init();

        //if this page has defined a klp.init function, call it.
        if (klp.hasOwnProperty('init')) {
            klp.init();
        }
    });
})();