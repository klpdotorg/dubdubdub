(function() {
    var klp = window.klp;

    var routes = {
        '/search/(\\w+)/([\\.\\,\\d]+)/(\\d+)': doSearch
    };

    function doSearch(url_params, query_params) {
        var bbox = url_params[0];
        var zoom = url_params[1];
        // console.log("search route called", bbox, zoom, query_params);
        //console.log("location hash", window.location.hash);
    }

    klp.router = new KLPRouter(routes);

})();
