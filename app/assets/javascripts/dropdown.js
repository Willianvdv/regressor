$(document).ready(function() {
	$('.filter-button').click(function(e) {
		elem = $(e.target);
		elem.parent().find('.filter-dropdown').slideToggle();
	});
});
