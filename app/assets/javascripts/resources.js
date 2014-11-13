jQuery(document).ready(function(){
	var ql_current = $('.resources-all');

	$('.b-all').click(function(){
		ql_current.css("display", "none");
		ql_current = $('.resources-all');
		ql_current.css('display', "block");
	});

	$('.b-manhattan').click(function(){
		ql_current.css("display", "none");
		ql_current = $('.resources-manhattan');
		ql_current.css("display", "block");
	});

	$('.b-bronx').click(function(){
		ql_current.css("display", "none");
		ql_current = $('.resources-bronx');
		ql_current.css("display", "block");
	});

	$('.b-brooklyn').click(function(){
		ql_current.css("display", "none");
		ql_current = $('.resources-brooklyn');
		ql_current.css("display", "block");
	});

	$('.b-queens').click(function(){
		ql_current.css("display", "none");
		ql_current = $('.resources-queens');
		ql_current.css("display", "block");
	});

	$('.b-staten').click(function(){
		ql_current.css("display", "none");
		ql_current = $('.resources-staten');
		ql_current.css("display", "block");
	});



});