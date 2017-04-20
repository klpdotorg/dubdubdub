// Round values to nearest integer
swig.setFilter('round', function (input) {
    return Math.round(input);
});

// Return length of array or string
swig.setFilter('length', function (input) {
    if (input instanceof Array || (typeof input === 'string' || input instanceof String)) {
		return input.length;
	} else if (input instanceof Object) {
		return Object.keys(input).length
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

//Convert to int (strip decimal places)
swig.setFilter('int', function (input) {
    return parseInt(input).toString();
});

//parseint and increment
swig.setFilter('increment', function (input) {
    return (parseInt(input)+1).toString();
});

//parseint and decrement
swig.setFilter('decrement', function (input) {
    return (parseInt(input)-1).toString();
});

//check empty values
swig.setFilter('checkempty', function (input) {
	var checked;
	(input != undefined)?checked=input:checked="No data";
	return checked; 
});

//check zero values
swig.setFilter('checkzero', function (input) {
	var checked;
	(input != undefined && input!= 0 && input!= NaN && input!="NA")?checked=input:checked="No data";
	return checked; 
});

//format INR number
swig.setFilter('inrformat', function (input) {
	if (input && input !=0) {
		var x=input.toString();
		var afterPoint = '';
		if(x.indexOf('.') > 0)
	   		afterPoint = x.substring(x.indexOf('.'),x.length);
		x = Math.floor(x);
		x=x.toString();
		var lastThree = x.substring(x.length-3);
		var otherNumbers = x.substring(0,x.length-3);
		if(otherNumbers != '')
	    	lastThree = ',' + lastThree;
		var res = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree + afterPoint;
		return  ' \u20B9 ' + res;
	} else {
		return 'No Data';
	}
})