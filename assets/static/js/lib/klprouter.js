var KLPRouter = function(routes) {
    this.routes = routes || {};
    var that = this;
    var getQueryParams = function(hash) {
        var queryParams = {};
        var hashSplit = hash.split("?");

        if (hashSplit.length > 1) {
            hash = hashSplit[0];
            var queryParamsString = hashSplit[1];
            var queryParamsSplit = queryParamsString.split("&");

            for (var i = 0; i < queryParamsSplit.length; i++) {
                var temp = queryParamsSplit[i].split("=");
                if (temp.length == 2){
                    queryParams[temp[0]] = temp[1];
                }
            };
        }
        return queryParams;
    };

    var getURL = function(hash) {
        if (hash.indexOf("?") === -1) {
            return hash;
        } else {
            return hash.split("?")[0];
        }
    };

    var getQueryString = function(queryObj) {
        var paramsArray = [];
        for (var param in queryObj) {
            if (queryObj.hasOwnProperty(param) && queryObj[param]) {
                var s = param + '=' + queryObj[param];
                paramsArray.push(s);
            }
        }
        return paramsArray.join('&');
    };

    this.hashChanged = function(e) {
        var previousURL, previousQueryParams;
        if (e && e.oldURL) {
            var oldFullURL = e.oldURL;
            if (oldFullURL.indexOf("#") !== -1) {
                var oldHash = oldFullURL.split('#')[1];
            } else {
                var oldHash = '';
            }
            previousQueryParams = getQueryParams(oldHash);
            previousURL = getURL(oldHash);
            // console.log('previous params', previousURL, previousQueryParams);
            //var previousURL = oldFullURL.
        } else {
            previousQueryParams = {};
            previousURL = '';
        }
        var hash = window.location.hash.substr(1, window.location.hash.length-1);
        var queryParams = getQueryParams(hash);
        for (pattern in routes) {
            var regex = new RegExp(pattern, "i");
            var matches = regex.exec(hash);

            if (matches !== null && matches.length > 0) {
                routes[pattern](matches, queryParams);
            }
        }
        var newURL = hash.split("?")[0];
        var changed = {};
        _(_(queryParams).keys()).each(function(key) {
            if (key in previousQueryParams) {
                if (queryParams[key] === previousQueryParams[key]) {
                    return;
                } else {
                    var oldVal = previousQueryParams[key];
                }
            } else {
                var oldVal = null;
            }
            changed[key] = {
                'oldVal': oldVal,
                'newVal': queryParams[key]
            };
        });

        _(_(previousQueryParams).keys()).each(function(key) {
            if (!(key in queryParams)) {
                changed[key] = {
                    'oldVal': previousQueryParams[key],
                    'newVal': null
                }
            }
        });
        var paramsObj = {
            'url': hash.split("?")[0],
            'queryParams': queryParams,
            'oldURL': previousURL,
            'changed': changed

        };
        that.events.trigger("hashchange", [paramsObj]);
        _(_(changed).keys()).each(function(key) {
            // console.log("triggering hashchange:" + key, paramsObj);
            that.events.trigger("hashchange:" + key, [paramsObj]);
        });
    };

    this.getHash = function() {
        var hash = window.location.hash.substr(1, window.location.hash.length-1);
        return {
            'url': hash.split("?")[0],
            'queryParams': getQueryParams(hash)
        }
    };

    this.setHash = function(url, queryParams, options) {
        /*
            url <string>: new url base fragment
            queryParams <obj>: object of query params to change
            options: obj
                - trigger <boolean> whether to trigger hashchange event
                - replace <boolean> whether to 'replace' URL without
                        creating event in history
                replace can be set to true only if trigger is false.
         */
        // console.log("set hash called", url, queryParams, options);
        var defaults = {
            'trigger': true,
            'replace': false
        };
        var opts = $.extend(defaults, options);
        var hash = window.location.hash.substr(1, window.location.hash.length-1);
        var hashSplit = hash.split("?");
        if (!url) {
            url = hashSplit[0];
        }
        var currentParams = getQueryParams(hash);
        var newParams = $.extend(currentParams, queryParams);
        var queryString = getQueryString(newParams);
        if (queryString !== '') {
            var newHash = url + '?' + queryString;
        } else {
            var newHash = url;
        }

        //if URL has not changed, don't create a new state
        if (newHash === hash) {
            return;
        }
        if (opts.trigger) {
            location.hash = newHash;
        } else if (!opts.replace) {
            history.pushState(null, null, '#' + newHash);
        } else {
            history.replaceState(null, null, '#' + newHash);
        }

    };

    this.start = function() {
        this.hashChanged();
    };

    this.init = function() {
        window.addEventListener("hashchange", this.hashChanged, false);
        that.events = $('<div />');
    };
};
