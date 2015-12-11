'use strict';
(function() {
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
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
            "gender" : {
                "boys": 23118,
                "girls": 24027
            }
        }
        renderSummary(summaryJSON,"Schools");
        loadData(null, null);
    }

    function loadData(schoolType, params) {

        /*var dataURL = "reports/finances/xxx";
        var $dataXHR = klp.api.do(detailURL, params);
        $datadetailXHR.done(function(data) {*/
            var grantdata = { 
                "received": {
                    "sg_perc": 25,
                    "sg_amt": 3500,
                    "smg_perc": 65,
                    "smg_amt": 5500,
                    "tlm_perc": 10,
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
            renderGrants(grantdata);
            var allocdata = {
                "sg":{
                    "upper_primary" : { 
                        "name":"Upper Primary",
                        "school_count":200,
                        "alloc_amt":"10,00,000",
                        "alloc_perc":46.5,
                        "per_school":"7,000",
                        "per_student":"1.00"
                    },
                    "lower_primary" : { 
                        "name":"Lower Primary",
                        "school_count":114,
                        "alloc_amt":"15,00,000",
                        "alloc_perc":53.5,
                        "per_school":"5,000",
                        "per_student":"0.75"
                    }
                },
                "smg":{
                   "more_than_3_cr" : { 
                        "name":"With > 3 classrooms",
                        "school_count":200,
                        "alloc_amt":"10,00,000",
                        "alloc_perc":46.5,
                        "per_school":"7,000",
                        "per_student":"1.00"
                    },
                    "less_than_3_cr" :{ 
                        "name":"With < 3 classrooms",
                        "school_count":114,
                        "alloc_amt":"15,00,000",
                        "alloc_perc":53.5,
                        "per_school":"5,000",
                        "per_student":"0.75"
                    }
                },
                "per":{
                    "total_girl": "45,00,000",
                    "per_girl" : 4.50,
                    "total_boy": "55,00,000",
                    "per_boy" : 5.50,
                    "total_teacher": "5,00,000",
                    "per_teacher" : 500,
                }
            }
            renderAllocation(allocdata["sg"],'#sg-alloc');
            renderAllocation(allocdata["smg"],"#smg-alloc");
            renderPerChild(allocdata["per"],"#per-alloc");
            
            var comparisonJson = {
                "year-wise": {
                    "2013":{"year":"2013","per_student":4.5,"tlm":"5,00,000","sg_perc":45,"sg_amt":"20,00,000","smg_perc":35,"smg_amt":"30,00,000"},
                    "2014":{"year":"2014","per_student":5,"tlm":"5,00,000","sg_perc":30,"sg_amt":"18,00,000","smg_perc":45,"smg_amt":"35,00,000"},
                    "2015":{"year":"2015","per_student":5.5,"tlm":"5,00,000","sg_perc":50,"sg_amt":"23,00,000","smg_perc":55,"smg_amt":"40,00,000"}
                }, /* maybe entrolment can be calculated with student and school count 
                    Percentage could be percentage of schools in district */
                "neighbours" : {
                    "Bangalore Central":{"name":"Bangalore Central","per_student":4.5,"tlm":"5,00,000","sg_amt":"10,00,000","smg_amt":"32,00,000","total":"55,00,000","total_perc":45},
                    "Bangalore North":{"name":"Bangalore North","per_student":5,"tlm":"4,00,000","sg_amt":"15,00,000","smg_amt":"34,00,000","total":"25,00,000","total_perc":55},
                    "Bangalore South":{"name":"Bangalore South","per_student":4,"tlm":"3,00,000","sg_amt":"18,00,000","smg_amt":"35,00,000","total":"35,00,000","total_perc":65},
                    "Bangalore Rural":{"name":"Bangalore Rural","per_student":3.5,"tlm":"5,00,000","sg_amt":"20,00,000","smg_amt":"36,00,000","total":"45,00,000","total_perc":35},
                    "Chikkabalapur":{"name":"Chikkabalapur","per_student":4.6,"tlm":"4,00,000","sg_amt":"25,00,000","smg_amt":"37,00,000","total":"56,00,000","total_perc":25}

                }
            }
            renderComparison(comparisonJson);
        //});
    }


    function renderSummary(data, schoolType) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html()); 
        var tplReportDate = swig.compile($('#tpl-reportDate').html()); 
        
        var now = new Date();
        var today = {'date' : moment(now).format("MMMM D, YYYY")};
        var dateHTML = tplReportDate({"today":today});
        $('#report-date').html(dateHTML);

        data['student_total'] = data["gender"]["boys"] + data["gender"]["girls"]; 
        data['ptr'] = Math.round(data["student_total"]/data["teacher_count"]);
        data['girl_perc'] = Math.round(( data["gender"]["girls"]/data["student_total"] )* 100);
        data['boy_perc'] = 100-data['girl_perc'];
        
        var topSummaryHTML = tplTopSummary({"data":data});
        $('#top-summary').html(topSummaryHTML);

    }

function renderGrants(data){
        drawStackedBar([ [data["expenditure"]["sg_perc"]],
                         [data["expenditure"]["smg_perc"]],
                         [data["expenditure"]["tlm_perc"]]
                       ],"#chart-expenditure");
        drawStackedBar([ [data["received"]["sg_perc"]],
                         [data["received"]["smg_perc"]],
                         [data["received"]["tlm_perc"]]
                       ],"#chart-received");

        var tpl = swig.compile($('#tpl-grants').html());
        var html = tpl({"grants":data["expenditure"]});
        $('#dise-expenditure').html(html); 
        html = tpl({"grants":data["received"]});
        $('#dise-received').html(html);   
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

    function renderAllocation(data,element_id) {
        var tplalloc = swig.compile($('#tpl-allocSummary').html());
        var html = tplalloc({"data":data});
        $(element_id).html(html);     
    }
    function renderPerChild(data,element_id) {
        var tplalloc = swig.compile($('#tpl-perChild').html());
        var html = tplalloc({"data":data});
        $(element_id).html(html); 
    }
    function renderComparison(data) {
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html()); 
        var yrcompareHTML = tplYearComparison({"years":data["year-wise"]});
        $('#comparison-year').html(yrcompareHTML);
        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":data["neighbours"]});
        $('#comparison-neighbour').html(compareHTML);
    
    }

})();

