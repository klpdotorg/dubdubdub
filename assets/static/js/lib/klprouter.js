var KLPRouter = function(routes) {
    this.routes = routes || {};
    var that = this;

    this.hashChanged = function() {
        var hash = window.location.hash.substr(1, window.location.hash.length-1);
        var query_params = {};
        var hash_split = hash.split("?");

        if (hash_split.length > 1) {
            hash = hash_split[0];
            var query_params_string = hash_split[1];
            var query_params_split = query_params_string.split("&");

            for (var i = 0; i < query_params_split.length; i++) {
                var temp = query_params_split[i].split("=");
                if (temp.length == 2){
                    query_params[temp[0]] = temp[1];
                }
            };
        }

        for (pattern in routes) {
            var regex = new RegExp(pattern, "i");
            var matches = regex.exec(hash);

            if (matches !== null && matches.length > 0) {
                this.routes[pattern](matches, query_params);
            }
        }
    };

    this.init = function() {
        window.addEventListener("hashchange", this.hashChanged, false);

        if (window.location.hash !== "") {
            this.hashChanged();
        }
    };
};
