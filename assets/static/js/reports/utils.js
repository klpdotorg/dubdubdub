'use strict';
(function() {
  var t = klp.reportUtils = {};

 t.getParameterByName  = function (name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  };

  t.getSlashParameterByName  = function (name, url) {
		if (!url) url = window.location.href;
		//get rid of the trailing / before doing a simple split on /
		var url_parts = url.replace(/\/\s*$/,'').split('/');
		//since we do not need example.com
		var temp = url_parts.slice(Math.max(url_parts.length - 3, 1));
		var params = {
			"report_type":temp[0],
			"language":temp[1],
			"id":temp[2]
		};
		return params[name];
	};
  
})();
