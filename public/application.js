$(document).ready(function() {
	$('#name_form').submit(function(e) {
		$('#username').attr('disabled', true);
		
		var username = $('#username').val();
		
		$('#results').hide();
		
		$('#loading h3').text('Checking @' + username + '\'s anger level...');
		$('#loading').show();
		$('#loading img').show();
		e.preventDefault();
		
		$.getJSON('/check?username=' + username, function(data) { report_data(data) });
	});
});

function report_data(data) {
	$('#username').attr('disabled', false);
	
	if(data.score == 0 && data.text == 'NF') {
		$('#loading img').hide();
		$('#loading h3').text('Couldn\'t load tweets for @' + data.name + '. Is the account locked?');
	} else {
		$('#loading').hide();
	
		$('#results').show();
		$('#results h2').html('@' + data.name + ' is ' + data.score + '% angry!');
		$('#results div p').html('<strong>Angriest tweet: </strong><br/>&ldquo;' + data.text + '&rdquo;');
	
		setup_twitter_link(data.username, data.score);
	}
}

function setup_twitter_link(username, percentage) {
	var twitter_link = $('#results a');
	
	if(twitter_link.length) {	
		var api_link = 'http://twitter.com/share?url=http://rageomatic.com&text=My+tweets+are+' + percentage + '%25+rageful.'
		
		twitter_link.attr('href', api_link);
	}
}