// Round values to nearest integer
swig.setFilter('round', function (input) {
    return Math.round(input);
});

// Return length of array or string
swig.setFilter('length', function (input) {
    if (input instanceof Array || (typeof input === 'string' || input instanceof String)) {
		return input.length;
	}
});

// convert newlines to <br>
swig.setFilter('nl2br', function (input) {
    return input.replace(/\n/g, '<br/>');
});

// convert urls in text to links
swig.setFilter('autolink', function (input) {
    return Autolinker.link(input);
});