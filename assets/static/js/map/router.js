(function() {
    var klp = window.klp;

    var routes = {
        '/search/:bbox/:zoom/(.*)': doSearch,
        '/test': doTest,
        '': testRoute 
    };

    function doSearch(bbox, zoom, params) {
        console.log("search route called", bbox, zoom, params);
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