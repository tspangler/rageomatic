$(document).ready(function() {
	$('#name_form').submit(function(e) {
		e.preventDefault();
		
		$.getJSON('/check?username=' + $('#username').val(), function(data) { report_data(data) });
	});
});


function report_data(data) {
	$('#results h2').html('It looks like ' + data.name + ' is ' + data.score + '% angry!');
	$('#results div p').html(data.text)
}