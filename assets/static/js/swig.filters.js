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