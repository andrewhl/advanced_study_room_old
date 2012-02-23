jquery(function() {
	$('#division_form').submit(function(event) {
		alert('Success');
		event.preventDefault();
		var f = $(this);
		f.find('.ajax_message').html('Saving...');
		f.find('input[type="submit"]').attr('disabled', true);
		$.ajax({
			url: f.attr('action'),
			type: f.attr('method'),
			dataType: "html",
			data: f.serialize(),
			complete: function() {
				f.find('.ajax_message').html('&nbsp;');
				f.find('input[type="submit"]').attr('disabled', false);
			},
			success: function(data, textStatus, xhr) {
				$('#divisions').html(data);
				f.find('input[type="text"], textarea').val('');
			},
			error: function() {
				alert('Please enter a division name.');
			}
		});
	});
});
// $('#divisions').prepend('<%= escape_javascript(render(@division)) %>');
// $('#divisions > li:first').effect('highlight', {}, 3000);
// $('#division_form > form')[0].reset();