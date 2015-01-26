(function() {
    klp = klp || {};
    var template;

    klp.init  = function() {
        template = swig.compile($('#tpl-donateRequestItem').html());
        var $xhr = klp.api.do("donation_requirements", SEARCH_PARAMS);
        var $container = $('.container');
        $xhr.done(function(data) {
            console.log("data", data);
            _(data.results).each(function(d) {
                var html = template(d);
                $container.append(html);
            });
        });
    };

})();