$('#divisions').prepend('<%= escape_javascript(render(@division)) %>');
$('#divisions > li:first').effect('highlight', {}, 3000);
$('#division_form > form')[0].reset();