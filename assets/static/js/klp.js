(function() {
    klp.data = {};
    klp.openModal = null;
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
            var thisNav = $(this).closest(".js-nav").find('ul');
            $(".js-dropdown ul").not(thisNav).slideUp().closest('.js-nav').children('li:has(ul)').removeClass('clicked');
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
            $('.js-nav').toggleClass('nav-open');
        });

        $('.js-nav').click(function(event){
            event.stopPropagation();
        });

        $(window).click(function(){
            $('.js-nav').removeClass("nav-open");
        });


        //datepicker 
        $(".js-input-date").pickadate({
            format: 'yyyy-mm-dd',
            formatSubmit: 'yyyy-mm-dd'
        });

        //iframe videos: responsive
        
        $(".video-iframe-responsive").fitVids();

        // Adds easing scrolling to # targets
        $('a[href*=#]:not([href=#])').click(function() {
            if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
                || location.hostname == this.hostname) {

              var target = $(this.hash);
              target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
              if (target.length) {
                $('html,body').animate({
                  scrollTop: target.offset().top-100
                }, 300);
                return false;
              }
            }
        });

       /* $("#page_sticky_nav").stickOnScroll({
            topOffset: 0,
            setParentOnStick:   true,
            setWidthOnStick:    true
        });*/


        
        klp.auth.init();
        klp.login_modal.init();
        if (klp.hasOwnProperty('init')) {
            klp.init();
        }
    });
})();