'use strict';
var BOUNDARY_TYPE="boundary";
var KLP_ID="8877";
var LANGUAGE="kannada";
var utils;

(function() {
    klp.init = function() {
        utils = klp.boundaryUtils;
        klp.router = new KLPRouter();
        klp.router.init();
        fetchReportDetails();
        klp.router.start();
    }

    var preschoolInfraHash = {
        'ang-drinking-water': {
            display: 'Drinking Water',
            icon: ['fa  fa-tint']      
        },
        'ang-toilet-for-use': {
            display:'Toilets', 
            icon: ['fa fa-male', 'fa fa-female']
        },
        'ang-bvs-present': {
            display: 'Functional Bal Vikas Samithis',
            icon: ['fa fa-users']
        },
        'ang-separate-handwash': {
            display: 'Separate Hand-Wash',
            icon: ['fa fa-hand-o-up']
        }, 
        'ang-activities-use-tlm': {
            display: 'Uses Learning Material', 
            icon: ['fa fa-cubes']
        },
        'ang-in-spacious-room': {
            display: 'Spacious Room', 
            icon: ['fa fa-arrows-alt']
        }
    }

    var schoolInfraHash = {
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

    function fetchReportDetails()
    {
        var params = klp.router.getHash().queryParams;
        var url = "reports/?report_name=infrastructure&report_type=" +BOUNDARY_TYPE+"&id="+KLP_ID+"&language="+LANGUAGE ;
        var $xhr = klp.api.do(url, params);
        $xhr.done(function(data) {
            console.log('data', data);
            var schooltype = "Schools"
            var summaryJson = getSummaryData(data);
            renderSummary(summaryJson, schooltype);
            if ( data["btype"] == 2 ){
                schooltype = "PreSchool"
                var comparisonJSON = data["comparison"]["year-wise"];
                renderComparison(comparisonJSON, preschoolInfraHash);
                var neighboursJSON = data["comparison"]["neighbours"];
                renderNeighbours(neighboursJSON, preschoolInfraHash);
            }
            else
            {
                console.log("getting school data",data);
                fetchSchoolData(data);
            }
        })
    }

    function fetchSchoolData(data)
    {
        var acadYear = data["boundary_info"]["academic_year"].replace(/20/g, '')
        klp.dise_api.queryBoundaryName(data["boundary_info"]["name"], data["boundary_info"]["type"],acadYear).done(function(diseData) {
            var boundary = diseData[0].children[0]
            console.log('boundary', boundary);
            klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
                console.log('summary diseData', diseData);
                //var neighboursJSON = data["comparison"]["neighbours"];
                //renderNeighbours(neighboursJSON, schoolInfraHash);
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
            })
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
        });
        /*
        var passNeighbourData = {"type": data["boundary_info"]["type"], "acadYear": acadYear};
        getMultipleData(data["comparison"]["neighbours"], passNeighbourData, getLoopData, renderNeighbours,"name");
        */
        var passYearData = {"name": data["boundary_info"]["name"], "type": data["boundary_info"]["type"]};
        getMultipleData(data["comparison"]["year-wise"], passYearData, getLoopData, renderComparison,"acadYear");
        
    }

    function getMultipleData(inputData, passedData, getData, exit,iteratorName)
    {
        var numberOfIterations = Object.keys(inputData).length;
        console.log("in getMultipleData", inputData, numberOfIterations);
        var outputData= {};
        var index = 0,
            done = false,
            shouldExit = false;
        var loop = {
            next:function(){
                console.log("in loop next");
                if(done){ 
                    console.log( "DONE");
                    if(shouldExit && exit){ 
                        console.log("in done");
                        return exit(outputData,schoolInfraHash); // Exit if we're done
                    }
                }
                if(index <  numberOfIterations){
                    console.log("in loop next, if loop"); 
                    index++; // Increment our index
                    getData(loop); // Run our process, pass in the loop
                    console.log("got the neighbour data");
                }
                else {
                    console.log("in loop next else loop");
                    done = true; // Make sure we say we're done
                    if(exit) 
                        console.log("in exit")
                        exit(outputData,schoolInfraHash); // Call the callback on exit
                }
            },
            iteration:function(){
                passedData[iteratorName] = Object.keys(inputData)[index-1];
                passedData["value"] = inputData[passedData[iteratorName]];
                return passedData; // Return the loop number we're on
            },
            addData:function(diseData){
                outputData[Object.keys(inputData)[index-1]] = diseData;
            },
            break:function(end){
                console.log("in break");
                done = true; // End the loop
                shouldExit = end; // Passing end as true means we still call the exit callback
            }
        };
        loop.next();
        return loop;
    }

    function getLoopData(loop)
    {
        var data = loop.iteration();
        console.log("In getLoopData",data);
        klp.dise_api.queryBoundaryName(data["name"], data["type"], data["acadYear"]).done(function(diseNameData) {
            if( diseNameData.length == 0)
            {
                console.log("Sorry, could not get name for data for neighbours ",data["neighbour"]);
                loop.next();
                return;
            }    
            var boundary = diseNameData[0].children[0]
            klp.dise_api.getBoundaryData(boundary.id, boundary.type, data["acadYear"]).done(function(diseData) {
                console.log('diseData', diseData);
                for(var key in data["value"] )
                {
                    diseData[key] = data["value"][key]
                }

                loop.addData(diseData);
                loop.next();
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch programmes data", "for neighbour"+neighbour);
            })
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch name data", "error");
        });
    }


    function getSummaryData(data)
    {
        var summaryJSON = {
            "boundary"  : data["boundary_info"],
            "school_count" : data["school_count"], 
            "teacher_count" : data["teacher_count"],
            "gender" : data["gender"]
        }

        return summaryJSON;
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

    function renderComparison(data, hash) {
        var transpose = transposeData(data, hash);
        console.log(transpose);
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html()); 
        var yrcompareHTML = tplYearComparison({"transpose":transpose});
        $('#comparison-year').html(yrcompareHTML);
    }

    function renderNeighbours(data,hash) {
        var percData = {};
        
        for (var each in data) {
            for (var key in data[each]["properties"]) {
                var iconTag = "";
                if(key != "name" && key != "school_count" && key in hash) {
                    console.log("a hash match");
                    for(var i in hash[key]['icon']){
                        iconTag += "<span class='" + hash[key]['icon'][i] + "'></span>   ";
                    }
                    if(!percData[key]) 
                        percData[key] = {"icon":iconTag,"name":hash[key]['display']};
                    if(!percData[key][each])
                        percData[key][each] = {};
                    percData[key][each]["name"] = each;
                    percData[key][each]["perc"] = (data[each]["properties"][key]/data[each]["properties"]["sum_schools"]) * 100;
                }
            }
        }

        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":percData});
        $('#comparison-neighbour').html(compareHTML);
    }

    function transposeData(data,hash) {
        console.log("transposeData", data);
        var transpose = {
            "year":[],
            "school_count" : {"name": "school_count"},
            "Basic Infrastructure" : { "name":"Basic Infrastructure"},
            "Learning Environment" : { "name":"Learning Environment"},
            "Nutrition and Hygiene" : { "name":"Nutrition and Hygiene"},
            "Toilets" : { "name":"Toilets"}
        }

        var basic_infra = ["sum_has_boundary_wall","sum_has_playground","sum_has_electricity","sum_classrooms_in_good_condition"];
        var learning_env = ["sum_has_blackboard","sum_has_computer","sum_has_library"];
        var nut_hyg = ["sum_has_mdm","sum_has_drinking_water"];
        var toilets = ["sum_has_toilet","sum_toilet_girls"];

        for (var truncyear in data) {
            var year = data[truncyear]["year"];
            transpose["year"].push(year);
            transpose["school_count"][year] = data[truncyear]["properties"]["sum_govt_schools"];
            var infraData = data[truncyear]["properties"];
            for (var key in infraData) {
                var iconTag = "";
                if(key != "year" && key != "school_count" && key in hash)
                {
                    for(var i in hash[key]['icon']){
                        iconTag += "<span class='" + hash[key]['icon'][i] + "'></span>   ";
                    }
                }
                if ($.inArray(key,basic_infra) != -1 ) {
                    if(!transpose["Basic Infrastructure"][key])
                        transpose["Basic Infrastructure"][key] = {"name":hash[key]['display'],"icon":iconTag};
                    transpose["Basic Infrastructure"][key]["yr"+year] = (infraData[key]/infraData["sum_govt_schools"]);

                    
                } else if ($.inArray(key,learning_env) != -1) {
                    if(!transpose["Learning Environment"][key])
                        transpose["Learning Environment"][key] = {"name":hash[key]['display'],"icon":iconTag};
                    transpose["Learning Environment"][key]["yr"+year] = (infraData[key]/infraData["sum_govt_schools"]);
                } else if ($.inArray(key,nut_hyg) != -1) {
                    if(!transpose["Nutrition and Hygiene"][key])
                        transpose["Nutrition and Hygiene"][key] = {"name":hash[key]['display'],"icon":iconTag}; 
                    transpose["Nutrition and Hygiene"][key]["yr"+year] = (infraData[key]/infraData["sum_govt_schools"]);    
                } else if ($.inArray(key,toilets) != -1) {
                    if(!transpose["Toilets"][key])
                        transpose["Toilets"][key] = {"name":hash[key]['display'],"icon":iconTag}; 
                    transpose["Toilets"][key]["yr"+year] = (infraData[key]/infraData["sum_govt_schools"]);    
                } else {}
            }
        }
        transpose["year"].sort()
        return transpose;
    }



})();

