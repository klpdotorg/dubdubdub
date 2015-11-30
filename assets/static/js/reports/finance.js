'use strict';
(function() {

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
    }

    var summaryJSON = {
        "boundary"  : {
            "name"  : "Bangalore Central",
            "type"  : "MP Constituency",
            "id"    : 1234,
            "code"  : 25,
            "elected_rep" : "PC Mohan",
            "elected_party" : "INC"
        },
        "school_count" : 314,
        "teacher_count" : 2000,
        "gender_breakup" : {
            "boys": 23118
            "girls": 24027
        }
    }
    renderSummary(summaryJSON,"Schools");
    function loadData(schoolType, params) {
        /*var dataURL = "reports/demographics/xxx";
        var $dataXHR = klp.api.do(detailURL, params);
        $datadetailXHR.done(function(data) {*/
            renderCategories(data["categories"]);
            renderLanguage(data["languages"]);
            renderYearComparison(data["year-wise"])
        //});
    }

    function renderSummary(data, schoolType) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());        
        var topSummaryHTML = tplTopSummary(summaryData);
        $('#top-summary').html(topSummaryHTML);
    }

    function drawStackedBar(data, element_id) {
        new Chartist.Bar(element_id, {
                labels: [''],
                series: data
            }, {
            stackBars: true,
            horizontalBars: true,
            axisX: {
                showGrid: false
            },
            axisY: {
                showGrid: false,
                labelInterpolationFnc: function(value) {
                return'';
            }
        }
        }).on('draw', function(data) {
            if(data.type === 'bar') {
                data.element.attr({
                    style: 'stroke-width: 20px'
                });
            }
        });
    }

    function renderGrants(){
        var data = { 
            "received": {
                "sg_perc": 25,
                "sg_amt": 3500,
                "smg_perc": 70,
                "smg_amt": 5500,
                "tlm_perc": 5,
                "tlm_amt": 1000   
            },
            "expenditure": {
                "sg_perc": 35,
                "sg_amt": 3500,
                "smg_perc": 55,
                "smg_amt": 5500,
                "tlm_perc": 10,
                "tlm_amt": 1000 
            }
        };
        drawStackedBar([ [data["expenditure"]["sg_perc"]],
                         [data["expenditure"]["smg_perc"]],
                         [data["expenditure"]["tlm_perc"]]
                       ],"#chart-expenditure");
        drawStackedBar([ [data["received"]["sg_perc"]],
                         [data["received"]["smg_perc"]],
                         [data["received"]["tlm_perc"]]
                       ],"#chart-received");
    }



})();

