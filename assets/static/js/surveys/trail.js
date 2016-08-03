'use strict';
(function() {

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
        var dataURL = "stories?source=mobile";
        loadData(dataURL);
    }

    $(document).on('click',".next",function () {        
        var url = $(this).data('id');
        var rest_url = url.split('api/v1/')[1];
        console.log(rest_url);
        loadData(rest_url);
    });

    $(document).on('click',".prev",function () {        
        var url = $(this).data('id');
        var rest_url = url.split('api/v1/')[1];
        console.log(rest_url);
        loadData(rest_url);
    });

    function loadData(dataURL) {
        var params = {};
        var $dataXHR = klp.api.do(dataURL, params);
        $dataXHR.done(function(data) {
            renderSummary(data);
        });
        // $.get( "http://dev.klp.org.in/api/v1/stories/?source=mobile", function( data ) {
        //     renderSummary(data);
        //     alert( "Load was performed." );
        // });
    }
    
    function renderSummary(data) {
        console.log(data);
        var tplCountSummary = swig.compile($('#tpl-countSummary').html());
        var tplResponseTable = swig.compile($('#tpl-responseTable').html());
        var countHTML = tplCountSummary({'data':data});
        var tableHTML = tplResponseTable({'data':data});
        $('#count_response').html(countHTML);
        $('#response_summary').html(tableHTML);
    }   

})();