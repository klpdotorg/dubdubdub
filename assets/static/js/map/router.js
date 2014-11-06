(function() {
    var klp = window.klp;

    var routes = {
        '/search/(\\w+)/([\\.\\,\\d]+)/(\\d+)': doSearch,
        '/test': doTest,
        '^$': testRoute
    };

    function doSearch(url_params, query_params) {
        var bbox = url_params[0];
        var zoom = url_params[1];
        // console.log("search route called", bbox, zoom, query_params);
        //console.log("location hash", window.location.hash);
    }

    function doTest() {
        console.log("this", this);
        console.log("/test route called");
    }

    function testRoute() {
        console.log("empty test route called");
    }

    klp.router = new KLPRouter(routes);

})();
