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

    var infraHash = {
        'sum_has_playground': {
            'icon': ['fa fa-futbol-o'],
            'display': 'Playground' 
        },
        'sum_has_drinking_water': {
            'icon': ['fa fa-tint'],
            'display': 'Drinking Water',       
        },
        'sum_has_toilet': {
            'icon': ['fa fa-male', 'fa fa-female'],
            'display': 'Toilets'      
        },
        'sum_has_library': {
            'icon': ['fa fa-book'],
            'display': 'Library'
        },
        'sum_has_boundary_wall': {
            'icon': ['fa fa-circle-o-notch'],
            'display': 'Secure Boundary Wall'
        },
        'sum_has_electricity': {
            'icon': ['fa fa-plug'],
            'display': 'Electricity'
        },
        'sum_has_computer': {
            'icon': ['fa fa-laptop'],
            'display': 'Computers'
        },
        'sum_has_mdm': {
            'icon': ['fa fa-spoon'],
            'display': 'Mid-Day Meal'
        }, 
        'sum_toilet_girls': {
            'icon': ['fa fa-female'],
            'display': 'Separate Girls\' Toilets'
        },
        'sum_classrooms_in_good_condition': {
            'icon': ['fa fa-users'],
            'display': 'Good Classrooms'
        },
        'sum_has_blackboard': {
            'icon': ['fa fa-square'],
            'display': 'Blackboards'
        }
    };

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
                        "sum_has_boundary_wall": 1000, 
                        "sum_has_playground": 900,
                        "sum_has_electricity": 1300,
                        "sum_classrooms_in_good_condition": 900,
                        "sum_has_blackboard": 1200,
                        "sum_has_computer": 300,
                        "sum_has_library": 200,
                        "sum_has_mdm": 1200,
                        "sum_has_drinking_water": 1300,
                        "sum_has_toilet": 1200,
                        "sum_toilet_girls": 1200
                    },
            "2014": {
                        "year":"2014",
                        "school_count" : 1400,
                        "sum_has_boundary_wall": 1000, 
                        "sum_has_playground": 900,
                        "sum_has_electricity": 1300,
                        "sum_classrooms_in_good_condition": 900,
                        "sum_has_blackboard": 1200,
                        "sum_has_computer": 300,
                        "sum_has_library": 200,
                        "sum_has_mdm": 1200,
                        "sum_has_drinking_water": 1300,
                        "sum_has_toilet": 1200,
                        "sum_toilet_girls": 1200
                        
                    },    
            "2015": {
                        "year":"2015",
                        "school_count" : 1600,
                        "sum_has_boundary_wall": 1000, 
                        "sum_has_playground": 900,
                        "sum_has_electricity": 1300,
                        "sum_classrooms_in_good_condition": 900,
                        "sum_has_blackboard": 1200,
                        "sum_has_computer": 300,
                        "sum_has_library": 200,
                        "sum_has_mdm": 1200,
                        "sum_has_drinking_water": 1300,
                        "sum_has_toilet": 1200,
                        "sum_toilet_girls": 1200
                    }                
            }
            renderComparison(comparisonJson);
            var neighboursJson = {
                "Bangalore Central": {
                    "name": "Bangalore Central",
                    "school_count" : 1500,
                    "sum_has_boundary_wall": 1200, 
                    "sum_has_playground": 900,
                    "sum_has_electricity": 1100,
                    "sum_classrooms_in_good_condition": 800,
                    "sum_has_blackboard": 1200,
                    "sum_has_computer": 300,
                    "sum_has_library": 200,
                    "sum_has_mdm": 1500,
                    "sum_has_drinking_water": 1300,
                    "sum_has_toilet": 1500,
                    "sum_toilet_girls": 1200
                },
                "Bangalore North": {
                    "name": "Bangalore North",
                    "school_count" : 1600,
                    "sum_has_boundary_wall": 1000, 
                    "sum_has_playground": 900,
                    "sum_has_electricity": 1300,
                    "sum_classrooms_in_good_condition": 900,
                    "sum_has_blackboard": 1200,
                    "sum_has_computer": 300,
                    "sum_has_library": 200,
                    "sum_has_mdm": 1200,
                    "sum_has_drinking_water": 1300,
                    "sum_has_toilet": 1200,
                    "sum_toilet_girls": 1200
                },
                "Bangalore South": {
                    "name": "Bangalore South",
                    "school_count" : 1700,
                    "sum_has_boundary_wall": 1500, 
                    "sum_has_playground": 1000,
                    "sum_has_electricity": 1200,
                    "sum_classrooms_in_good_condition": 1400,
                    "sum_has_blackboard": 1100,
                    "sum_has_computer": 500,
                    "sum_has_library": 800,
                    "sum_has_mdm": 1200,
                    "sum_has_drinking_water": 1400,
                    "sum_has_toilet": 1600,
                    "sum_toilet_girls": 1600
                },
                "Chikkabalapur": {
                    "name": "Chikkabalapur",
                    "school_count" : 1600,
                    "sum_has_boundary_wall": 1000, 
                    "sum_has_playground": 900,
                    "sum_has_electricity": 1300,
                    "sum_classrooms_in_good_condition": 900,
                    "sum_has_blackboard": 1200,
                    "sum_has_computer": 300,
                    "sum_has_library": 200,
                    "sum_has_mdm": 1200,
                    "sum_has_drinking_water": 1300,
                    "sum_has_toilet": 1200,
                    "sum_toilet_girls": 1200
                },
                "Bangalore Rural": {
                    "name": "Bangalore Rural",
                    "school_count" : 1500,
                    "sum_has_boundary_wall": 1200, 
                    "sum_has_playground": 800,
                    "sum_has_electricity": 1200,
                    "sum_classrooms_in_good_condition": 1000,
                    "sum_has_blackboard": 1200,
                    "sum_has_computer": 800,
                    "sum_has_library": 400,
                    "sum_has_mdm": 900,
                    "sum_has_drinking_water": 1000,
                    "sum_has_toilet": 1300,
                    "sum_toilet_girls": 1400
                } 
            }
            renderNeighbours(neighboursJson);
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
        var transpose = transposeData(data);
        console.log(transpose);
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html()); 
        var yrcompareHTML = tplYearComparison({"transpose":transpose});
        $('#comparison-year').html(yrcompareHTML);
    }

    function renderNeighbours(data) {
        var percData = {};
        
        for (var each in data) {
            for (var key in data[each]) {
                var iconTag = "";
                if(key != "name" && key != "school_count") {
                    for(var i in infraHash[key]['icon']){
                        iconTag += "<span class='" + infraHash[key]['icon'][i] + "'></span>   ";
                    }
                    if(!percData[key]) 
                        percData[key] = {"icon":iconTag,"name":infraHash[key]['display']};
                    if(!percData[key][each])
                        percData[key][each] = {};
                    percData[key][each]["name"] = each;
                    percData[key][each]["perc"] = (data[each][key]/data[each]["school_count"]) * 100;
                }
            }
        }

        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":percData});
        $('#comparison-neighbour').html(compareHTML);
    }

    function transposeData(data) {
        var transpose = {
            "school_count" : { "name":"school_count" },
            "Basic Infrastructure" : { "name":"Basic Infrastructure"},
            "Learning Environment" : { "name":"Learning Environment"},
            "Nutrition and Hygiene" : { "name":"Nutrition and Hygiene"},
            "Toilets" : { "name":"Toilets"}
        }

        
        
        var basic_infra = ["sum_has_boundary_wall","sum_has_playground","sum_has_electricity","sum_classrooms_in_good_condition"];
        var learning_env = ["sum_has_blackboard","sum_has_computer","sum_has_library"];
        var nut_hyg = ["sum_has_mdm","sum_has_drinking_water"];
        var toilets = ["sum_has_toilet","sum_toilet_girls"];

        for (var year in data) {
            transpose["school_count"]["yr"+year] = data[year]["school_count"];
            for (var key in data[year]) {
                var iconTag = "";
                if($.inArray(key,["year","school_count"])==-1)
                {
                    for(var i in infraHash[key]['icon']){
                        iconTag += "<span class='" + infraHash[key]['icon'][i] + "'></span>   ";
                    }
                }
                if ($.inArray(key,basic_infra) != -1 ) {
                    if(!transpose["Basic Infrastructure"][key])
                        transpose["Basic Infrastructure"][key] = {"name":infraHash[key]['display'],"icon":iconTag};
                    transpose["Basic Infrastructure"][key]["yr"+year] = (data[year][key]/data[year]["school_count"])*100;

                    
                } else if ($.inArray(key,learning_env) != -1) {
                    if(!transpose["Learning Environment"][key])
                        transpose["Learning Environment"][key] = {"name":infraHash[key]['display'],"icon":iconTag};
                    transpose["Learning Environment"][key]["yr"+year] = (data[year][key]/data[year]["school_count"])*100;
                } else if ($.inArray(key,nut_hyg) != -1) {
                    if(!transpose["Nutrition and Hygiene"][key])
                        transpose["Nutrition and Hygiene"][key] = {"name":infraHash[key]['display'],"icon":iconTag}; 
                    transpose["Nutrition and Hygiene"][key]["yr"+year] = (data[year][key]/data[year]["school_count"])*100;    
                } else if ($.inArray(key,toilets) != -1) {
                    if(!transpose["Toilets"][key])
                        transpose["Toilets"][key] = {"name":infraHash[key]['display'],"icon":iconTag}; 
                    transpose["Toilets"][key]["yr"+year] = (data[year][key]/data[year]["school_count"])*100;    
                } else {}
            }
        }
        return transpose;
    }



})();

