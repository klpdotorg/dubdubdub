'use strict';
var BOUNDARY_TYPE="boundary";
var KLP_ID="8877";
var LANGUAGE="kannada";

(function() {
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        fetchReportDetails();
        klp.router.start();
    };

    function fetchReportDetails()
    {
        var params = klp.router.getHash().queryParams;
        var url = "reports/finance/"+BOUNDARY_TYPE+"/comparison/?language="+LANGUAGE+"&id="+KLP_ID;
        var $xhr = klp.api.do(url, params);
        $xhr.done(function(data) {
            var summaryJSON= getSummaryData(data);
            renderSummary(summaryJSON,"Schools");
            fetchSchoolData(data);
        });

    }

    function getSummaryData(data){
        var summaryJSON = {
            "boundary": data["boundary_info"],
            "school_count" : data["school_count"],
            "teacher_count" : data["teacher_count"],
            "gender" : data["gender"]
        };
        return summaryJSON;
    }

    function fetchSchoolData(data)
    {
        var acadYear = data["boundary_info"]["academic_year"].replace(/20/g, '');
        klp.dise_api.queryBoundaryName(data["boundary_info"]["name"], data["boundary_info"]["type"],acadYear).done(function(diseData) {
            if( diseData.length != 0 )
            {
                var boundary = diseData[0].children[0];
                klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
                    console.log('diseData', diseData);
                    renderGrantSummary(diseData);
                })
                .fail(function(err) {
                    klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
                });
            }
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
        });
        
        getNeighbourData(data, acadYear);
        
        var passYearData = {"name": data["boundary_info"]["name"], "type": data["boundary_info"]["type"]};
        getMultipleData(data["comparison"]["year-wise"], passYearData, getLoopData, renderComparison,"acadYear");
        
    }

    function loadData(schoolType, params) {

        /*var dataURL = "reports/finances/xxx";
        var $dataXHR = klp.api.do(detailURL, params);
        $datadetailXHR.done(function(data) {*/
            var grantdata = { 
                "expected": {
                    "grand_total": 5000000,
                    "gender":{"per_girl":5, "total_girl":2000000, "per_boy":6, "total_boy": 3000000},
                },
                "received": {
                    "grand_total": 4500000, 
                    "per_stu":6.5 
                },
                "expenditure": {
                    "grand_total": 4000000, 
                    "per_stu":7.5  
                }
            };
            renderGrants(grantdata);
            var allocdata = {
                "sg":{
                    "lower_primary" : { 
                        "name":"Lower Primary",
                        "school_count":114,
                        "alloc_amt":"15,00,000",
                        "alloc_perc":53.5,
                        "per_school":"5,000",
                        "per_student":"0.75"
                    },
                    "upper_primary" : { 
                        "name":"Upper Primary",
                        "school_count":200,
                        "alloc_amt":"10,00,000",
                        "alloc_perc":46.5,
                        "per_school":"7,000",
                        "per_student":"1.00"
                    }
                },
                "smg":{
                    "upto_3_cr" :{ 
                        "name":"With <= 3 classrooms",
                        "school_count":114,
                        "alloc_amt":"15,00,000",
                        "alloc_perc":53.5,
                        "per_school":"5,000",
                        "per_student":"0.75"
                    },
                   "4_cr" : { 
                        "name":"With 4 classrooms",
                        "school_count":200,
                        "alloc_amt":"10,00,000",
                        "alloc_perc":46.5,
                        "per_school":"7,500",
                        "per_student":"1.00"
                    },
                    "5_cr" : { 
                        "name":"With 5 classrooms",
                        "school_count":50,
                        "alloc_amt":"2,50,000",
                        "alloc_perc":15.5,
                        "per_school":"10,000",
                        "per_student":"1.00"
                    }, //These below are in combination with category.
                    "6_cr" : { 
                        "name":"With 6-7 classrooms",
                        "school_count":50,
                        "alloc_amt":"2,50,000",
                        "alloc_perc":15.5,
                        "per_school":"15,000",
                        "per_student":"1.00"
                    },
                    "8_cr" : { 
                        "name":"With 8 classrooms",
                        "school_count":20,
                        "alloc_amt":"1,50,000",
                        "alloc_perc":10.5,
                        "per_school":"20,000",
                        "per_student":"1.00"
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
            renderAllocation(allocdata["sg"], "School Grant Allocation", '#sg-alloc');
            renderAllocation(allocdata["smg"], "School Maintenance Allocation", "#smg-alloc");
            
            var comparisonJson = {
                "neighbours" : {
                    "Bangalore Central":{"name":"Bangalore Central","expected":"25,00,000","received":"20,00,000","expenditure":"18,00,000","total_perc":45},
                    "Bangalore North":{"name":"Bangalore North","expected":"25,00,000","received":"21,00,000","expenditure":"19,00,000","total_perc":55},
                    "Bangalore South":{"name":"Bangalore South","expected":"25,00,000","received":"20,00,000","expenditure":"19,00,000","total_perc":65},
                    "Bangalore Rural":{"name":"Bangalore Rural","expected":"25,00,000","received":"19,00,000","expenditure":"18,00,000","total_perc":35},
                    "Chikkabalapur":{"name":"Chikkabalapur","expected":"25,00,000","received":"18,00,000","expenditure":"20,00,000","total_perc":25}

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
        var tpl = swig.compile($('#tpl-grantSummary').html());
        var html = tpl({"data":data["expected"]});
        $('#expected').html(html); 
        
        data["received"]["total_perc"] = Math.round(data.received.grand_total/data.expected.grand_total * 100);
        data["received"]["perc_label"] = "expected";
        html = tpl({"data":data["received"]});
        $('#received').html(html); 

        data["expenditure"]["total_perc"] = Math.round(data.expenditure.grand_total/data.received.grand_total * 100);
        data["expenditure"]["perc_label"] = "received";
        var html = tpl({"data":data["expenditure"]});
        $('#expenditure').html(html);
        
    }

    function renderAllocation(data, heading, element_id) {
        var tplalloc = swig.compile($('#tpl-allocSummary').html());
        var html = tplalloc({"data":data,"heading":heading});
        $(element_id).html(html);     
    }
    function renderComparison(data) {
        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":data["neighbours"]});
        $('#comparison-neighbour').html(compareHTML);
    
    }

})();

