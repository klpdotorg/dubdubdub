//JS For light-weight accordion without JQuery UI
$(document).ready(function(){
	$('#improved .head').click(function(e){
		e.preventDefault();
		$(this).closest('li').find('.content').not(':animated').slideToggle();
		klp.updateChart();
	});
});
