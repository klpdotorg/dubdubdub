(function() {
    klp = klp || {};

    klp.init = function() {
        console.log("initting app");
        renderData();
    };

    function renderData() {
        //TODO: collect all form params
        var params = {
            'source': 'ivrs'
        };
        var url = "stories/meta";
        var $xhr = klp.api.do(url, params);
        $xhr.done(function(data) {
            //TODO: Render data from back-end onto template
            console.log(data);
        });
    }
})();