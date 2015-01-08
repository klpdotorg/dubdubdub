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


        //top navigation    
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

        //Activates "tipsy" plugin for tooltips
        $('.qtip').tipsy({live: true});

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

        $("#page_sticky_nav").stickOnScroll({
            topOffset: 0,
            setParentOnStick:   true,
            setWidthOnStick:    true
        });


        
        klp.auth.init();
        klp.login_modal.init();
        if (klp.hasOwnProperty('init')) {
            klp.init();
        }
    });
})();