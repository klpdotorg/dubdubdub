'use strict';
(function() {

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
        var dataURL = "schools/meeting-reports/";
        loadData(dataURL);
    }

    function loadData(dataURL) {
        var params = {};
        var $dataXHR = klp.api.do(dataURL, params);
        $dataXHR.done(function(data) {
            renderSummary(data);
        });
    }
    
    function transformData(meetingreports) {
        var schoolMap = {};
        for (var i in meetingreports) {
            var report = meetingreports[i]
            if (_.keys(schoolMap).indexOf(report.school.id.toString())==-1) {
                schoolMap[report.school.id.toString()] = {
                                "pdfs":{}, 
                                "name": report.school.name,
                                "id": report.school.id //data.name,
                                // "admin3": data.admin3.name,
                                // "admin2": data.admin2.name,
                                // "admin1": data.admin1.name
                            };
            }
            schoolMap[report.school.id.toString()]["pdfs"][report.id.toString()] = {
                "path":report.pdf, 
                "lang":report.language, 
                "is_archived": (report.generated_at == null)? true : false,
                "year": (report.generated_at != null)? moment(report.generated_at, "YYYY-MM-DD").format("YYYY") : null,
                "month": (report.generated_at != null)? moment(report.generated_at, "YYYY-MM-DD").format("MMMM") : null
            };
        }
        return schoolMap;
    }

    function renderSummary(data) {
        var transformed = transformData(data['features'])
        // console.log(transformed);
        var tplResponseTable = swig.compile($('#tpl-responseTable').html());
        var tableHTML = tplResponseTable({'data':transformed});
        $('#response_summary').html(tableHTML);
    }   

})();