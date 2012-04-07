$(document).ready(function() {
	$('#division_form').submit(function(event) {
	    //alert('Success');
		//if event.result == false { return false }
		event.preventDefault();
		var f = $(this);
		//f.find('.ajax_message').html('Saving...');
		//f.find('input[type="submit"]').attr('disabled', true);
		$.ajax({
			url: "division_form",
			type: f.attr('method'),
			dataType: "html",
			data: f.serialize(),
			success: function(data, textStatus, xhr) {
				$('#divisions').append(data);
				f.find('input[type="text"], textarea').val('');
			}
		});
	  
		return false;
		
	});

	$('.delete_link').click(function() {
		alert("Test");
		$(this).closest('li').fadeOut();
	});
	
	// var l = $('.delete_link');
	// 
	// for(i=0; i<l.length; i++) {
	// 	l[i].click(function() {
	// 		alert("clicked");
	// 	});
	// }	// 
		// $('.delete_link').click(function() { 
		// 	alert("clicked"); 
		//     $(this).closest('li').fadeOut();  
		// });

});