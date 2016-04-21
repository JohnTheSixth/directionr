$(document).ready(function() {
	var currentUrl = location.pathname.split('/');

	if (currentUrl[currentUrl.length - 1] === 'login') {
	  $('li#login').addClass('active');
	} else if (currentUrl[currentUrl.length - 2] === 'users' && currentUrl[currentUrl.length - 1] === 'new') {
		$('li#createAccount').addClass('active');
	}
});