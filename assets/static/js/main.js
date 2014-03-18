$(document).ready(function(){

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

	// Re-display top navigation if it gets hidden.
	$(window).resize(function() {
		if($(window).width() >=980){
			$("#navigation").show();
		} else {
			$("#navigation").hide();
		}
	});

	// Top navigation show dropdown on hover
	$(".top-nav ul li" ).hover(
	  function() {
	  	$( this ).find('ul').show();
	  }, function() {
	    $( this ).find('ul').hide();
	  }
	);

	$("#page_sticky_nav").stickOnScroll({
        topOffset: 0,
        setParentOnStick:   true,
        setWidthOnStick:    true
    });

});

function toggle_mobile_nav(){
	$("#navigation").slideToggle();
}

