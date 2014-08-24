(function() {
    klp.init = function() {
        klp.router = new KLPRouter({});
        klp.router.init();
        klp.tabs.init();
        var $infoXHR = klp.api.do("schools/school/" + SCHOOL_ID, {geometry: 'yes'});
        $infoXHR.done(function(data) {
            console.log("info", data);
            var tpl = swig.compile($('#tpl-school-info').html());
            //var html = swig.render($('#tpl-school-info').html(), {locals: data});
            var html = tpl(data.properties);
            console.log(html);
            $('#school-info-wrapper').html(html);
        });
        klp.router.start();
    };

})();