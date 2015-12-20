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

        /*var dataURL = "reports/infrastructure/xxx";
        var $dataXHR = klp.api.do(detailURL, params);
        $datadetailXHR.done(function(data) {*/
            var grantdata = { 
                "received": {
                    "sg_perc": 25,
                    "sg_amt": 350000,
                    "smg_perc": 65,
                    "smg_amt": 550000,
                    "tlm_perc": 10,
                    "tlm_amt": 60000   
                },
                "teacher_count": 120,
                "student_total":48000
            };
            renderGrantSummary(grantdata);

            var comparisonJson = {
            "2013": {
                        "year":"2013",
                        "school_count" : 1500,
                        "basic_infra":{
                            "sum_has_boundary_wall": 1000, 
                            "sum_has_playground": 900,
                            "sum_has_electricity": 1300,
                            "sum_classrooms_in_good_condition": 900
                        },
                        "learning_env":{
                            "sum_has_blackboard": 1200,
                            "sum_has_computer": 300,
                            "sum_has_library": 200
                        },
                        "nutrition":{
                            "sum_has_mdm": 1200,
                            "sum_has_drinking_water": 1300
                        },
                        "toilets":{
                            "sum_has_toilet": 1200,
                            "sum_toilet_girls": 1200
                        }
                    }
            "2014": {
                        "year":"2014",
                        "school_count" : 1400,
                        "basic_infra":{
                            "sum_has_boundary_wall": 1000, 
                            "sum_has_playground": 900,
                            "sum_has_electricity": 1300,
                            "sum_classrooms_in_good_condition": 900
                        },
                        "learning_env":{
                            "sum_has_blackboard": 1200,
                            "sum_has_computer": 300,
                            "sum_has_library": 200
                        },
                        "nutrition":{
                            "sum_has_mdm": 1200,
                            "sum_has_drinking_water": 1300
                        },
                        "toilets":{
                            "sum_has_toilet": 1200,
                            "sum_toilet_girls": 1200
                        }
                    }    
            "2015": {
                        "year":"2015",
                        "school_count" : 1600,
                        "basic_infra":{
                            "sum_has_boundary_wall": 1000, 
                            "sum_has_playground": 900,
                            "sum_has_electricity": 1300,
                            "sum_classrooms_in_good_condition": 900
                        },
                        "learning_env":{
                            "sum_has_blackboard": 1200,
                            "sum_has_computer": 300,
                            "sum_has_library": 200
                        },
                        "nutrition":{
                            "sum_has_mdm": 1200,
                            "sum_has_drinking_water": 1300
                        },
                        "toilets":{
                            "sum_has_toilet": 1200,
                            "sum_toilet_girls": 1200
                        }
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

function renderGrantSummary(data){
        var tpl = swig.compile($('#tpl-grantSummary').html());
        var total = data["received"]["sg_amt"] + data["received"]["smg_amt"] + data["received"]["tlm_amt"]
        var received = {
                        "sg":data["received"]["sg_amt"], 
                        "smg": data["received"]["smg_amt"],
                        "tlm": data["received"]["tlm_amt"],
                        "total": total,
                        "per_student": total/data["student_total"],
                        "per_teacher": data["received"]["tlm_amt"]/data["teacher_count"]
        }
        console.log(received);
        var html = tpl({"received":received});
        $('#grant-summary').html(html);  
    }

    function renderComparison(data) {
        transposeData(data);
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html()); 
        var yrcompareHTML = tplYearComparison({"years":data["year-wise"]});
        $('#comparison-year').html(yrcompareHTML);
        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":data["neighbours"]});
        $('#comparison-neighbour').html(compareHTML);
    }

    function transposeData(data) {
        var transpose = {}
        for (var year in data) {
            for (var header in data[year]){
                for (var key in year[header]){
                    if (header in _keys(transpose))
                        transpose[header] = data[year][header][key];
                    else
                        transpose = { header: { year: data[year][header][key] }}
                }
            }
        }
    }

})();

