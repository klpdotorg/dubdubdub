(function() {
    var klp = window.klp;

    var routes = {
        '/search/:bbox/:zoom/\?:query_params': doSearch,
        '/test': doTest,
        '': testRoute 
    };

    function doSearch(bbox, zoom) {
        console.log("search route called", bbox, zoom, query_params);
        //console.log("location hash", window.location.hash);
    }

    function doTest() {
        console.log("this", this);
        console.log("/test route called");
    }

    function testRoute() {
        console.log("empty test route called");
    }

    klp.router = Router(routes);

})();