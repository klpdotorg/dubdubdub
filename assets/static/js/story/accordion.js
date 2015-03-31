//JS For light-weight accordion without JQuery UI
$(document).ready(function(){
	$('#improved .head').click(function(e){
		e.preventDefault();
		$(this).closest('li').find('.content').not(':animated').slideToggle();
		//Update the chartist charts in this accordian section
		$(this).closest('li').find('.ct-chart').each(function(i, e) {
      		e.__chartist__.update();
    	});
	});
});
