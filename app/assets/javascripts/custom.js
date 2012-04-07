// $.ajax({
//     url: "/tweet",
//     success: function(data, status,j_) {
//         //alert("status is " + status);
//         //alert("data is " + data);
//         if (status === 'success') {
//             if (data === '1') { /*indicate success*/ alert("Thank you for Tweeting! We've given you another contest entry!");}
//             else if (data === '0') { /* indicate failure */ alert("Sorry, it's been less than 24 hours since your last tweet. Please try again later.");}
//             else { /* this should never happen */ }
//             
//             }
//         else {
//           // do nothing? The user is here illegally.
//             }
//         }
//     });
// });

// $(document).ready(function() {
//    	$('#division_form').submit(function(event) {
// 		alert("Test");
// 	});
//  });

// jquery(function() {
// 	$('#division_form').submit(function(event) {
// 		alert('Success');
// 		event.preventDefault();
// 		var f = $(this);
// 		f.find('.ajax_message').html('Saving...');
// 		f.find('input[type="submit"]').attr('disabled', true);
// 		$.ajax({
// 			url: f.attr('action'),
// 			type: f.attr('method'),
// 			dataType: "html",
// 			data: f.serialize(),
// 			complete: function() {
// 				f.find('.ajax_message').html('&nbsp;');
// 				f.find('input[type="submit"]').attr('disabled', false);
// 			},
// 			success: function(data, textStatus, xhr) {
// 				$('#divisions').html(data);
// 				f.find('input[type="text"], textarea').val('');
// 			},
// 			error: function() {
// 				alert('Please enter a division name.');
// 			}
// 		});
// 	});
// });
// $('#divisions').prepend('<%= escape_javascript(render(@division)) %>');
// $('#divisions > li:first').effect('highlight', {}, 3000);
// $('#division_form > form')[0].reset();