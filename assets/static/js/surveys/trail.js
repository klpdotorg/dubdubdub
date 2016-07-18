'use strict';
(function() {

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
        loadData();
    }

    function loadData() {
        // var params = {};
        // var dataURL = "/stories/?source=mobile";
        // var $dataXHR = klp.api.do(dataURL, params);
        // $dataXHR.done(function(data) {
        //     renderSummary(data);
        // });
        $.get( "http://dev.klp.org.in/api/v1/stories/?source=mobile", function( data ) {
            renderSummary(data);
            alert( "Load was performed." );
        });
    }
    
    function renderSummary(data) {
        var tplCountSummary = swig.compile($('#tpl-countSummary').html());
        var tplresponseTable = swig.compile($('#tpl-responseTable').html());
        var countHTML = tplTopSummary(data);
        var tableHTML = tplIvrsSummary(data);
        $('#count_response').html(countHTML);
        $('#response_dummary').html(tableHTML);
    }   

})();