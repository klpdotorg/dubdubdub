'use strict';
(function() {
    var utils;
    var repUtils;
    var acadYear;
    var boundaryData;
    var boundary_name;
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    klp.init = function() {
        utils = klp.boundaryUtils;
        repUtils = klp.reportUtils;
        klp.router = new KLPRouter();
        klp.router.init();
        fetchReportDetails();
        klp.router.start();
    };

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
        'sum_has_toilet_girls': {
            'icon': ['fa fa-female'],
            'display': 'Separate Girls\' Toilets'
        },
        'sum_has_classrooms_in_good_condition': {
            'icon': ['fa fa-users'],
            'display': 'Good Classrooms'
        },
        'sum_has_blackboard': {
            'icon': ['fa fa-square'],
            'display': 'Blackboards'
        }
    };

    /*
        Fetch basic details (dise slug and academic year details) from backend
    */
    function fetchReportDetails()
    {
        var repType,bid,lang;
        repType = repUtils.getSlashParameterByName("report_type");
        bid = repUtils.getSlashParameterByName("id");
        lang = repUtils.getSlashParameterByName("language");

        var url = "reports/dise/"+repType+"/?language="+lang+"&id="+bid;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            console.log('data', data);
            fetchDiseData(data);
        });
    }

    /*
        Fetch dise data for the specified boundary
    */
    function fetchDiseData(data)
    {
        acadYear = data["academic_year"].replace(/20/g, '');
        var boundary = {"id": data["boundary_info"]["dise"], "type": data["boundary_info"]["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
            console.log('summary diseData', diseData);
            boundaryData = diseData;
            var summaryJson = getSummaryData(data, diseData);
            renderSummary(summaryJson);
            getNeighbourData(data);
            getYearData(data);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }

    /*
        Fill the summary data structure
    */
    function getSummaryData(data, diseData)
    {
        var categoryData = getCategoryCount(diseData["properties"]);
        var summaryJSON = {
            "boundary"  : data["boundary_info"],
            "school_count" : categoryData["schoolcount"],
            "teacher_count" : diseData["properties"]["sum_male_tch"] + diseData["properties"]["sum_female_tch"],
            "gender" : categoryData["gendercount"],
            "student_total": categoryData["gendercount"]["boys"] + categoryData["gendercount"]["girls"]
        };
        boundary_name = data["boundary_info"]["name"];
        if (summaryJSON["teacher_count"] == 0)
            summaryJSON['ptr'] = "NA";
        else
            summaryJSON['ptr'] = Math.round(summaryJSON["student_total"]/summaryJSON["teacher_count"]);
        summaryJSON['girl_perc'] = Math.round(( summaryJSON["gender"]["girls"]/summaryJSON["student_total"] )* 100);
        summaryJSON['boy_perc'] = 100-summaryJSON['girl_perc'];
        return summaryJSON;
    }

    /*
        Gets school count and gender count for schools that are of type lower primary or upper primary only.
    */
    function getCategoryCount(data)
    {
        var categorycount = {"schoolcount": 0,
                             "gendercount":  {"boys": 0, "girls": 0}
                            };
        for(var iter in data["school_categories"])
        {
            var type = data["school_categories"][iter];
            if(type["id"] == 1 || _.contains(upperPrimaryCategories, type["id"])){
                categorycount["schoolcount"] += type["sum_schools"]["total"];
                categorycount["gendercount"]["boys"] += type["sum_boys"];
                categorycount["gendercount"]["girls"] += type["sum_girls"];
            }
        }
        return categorycount;
    }

    /*
        Render summary data
    */
    function renderSummary(data) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplReportDate = swig.compile($('#tpl-reportDate').html());
        var now = new Date();
        var today = {'date' : moment(now).format("MMMM D, YYYY")};
        var dateHTML = tplReportDate({"today":today});
        $('#report-date').html(dateHTML);
        var topSummaryHTML = tplTopSummary({"data":data});
        $('#top-summary').html(topSummaryHTML);
    }

    /*
        Get the Neighouur information for comparison
    */
    function getNeighbourData(data)
    {
        var type = data["boundary_info"]["type"];
        var passboundarydata = {"acadYear": acadYear};
        var passeddata;
        if(type == "district")
            passeddata = data["neighbours"];
        else
            passeddata = data["boundary_info"]["parent"];
        getMultipleData(passeddata, passboundarydata, getMultipleNeighbour, renderNeighbours);
    }

    /*
        Get previous year data for comparison
    */
    function getYearData(data)
    {
        var yearData = [];
        var years = acadYear.split("-").map(Number);
        yearData[(years[0]-1).toString()+"-"+(years[1]-1).toString()] = "20"+(years[0]-1).toString()+"-"+"20"+(years[1]-1).toString();
        yearData[(years[0]-2).toString()+"-"+(years[1]-2).toString()] = "20"+(years[0]-2).toString()+"-"+"20"+(years[1]-2).toString();
        var passYearData = {"name": data["boundary_info"]["name"], "type": data["boundary_info"]["type"],"dise": data["boundary_info"]["dise"]};
        getMultipleData(yearData, passYearData, getMultipleYear, renderYearComparison,"acadYear");
    }

    /*
     * This function is used to call multiple apis before processing a function (exitFunction).
     * The inputData is used for looping through and has the data that needs to be passed.
     * The passedData is used for passing the data to the function (getData) which is used for making 
     * the relevant api calls.
     * Once the loop is over the exitFunction is called.
     */
    function getMultipleData(inputData, passedData, getData, exitFunction, iteratorName="iter")
    {
        var numberOfIterations = Object.keys(inputData).length;
        var outputData= [];
        var index = 0,
            done = false,
            shouldExit = false;
        var loop = {
            next:function(){
                if(done){
                    if(shouldExit && exitFunction){
                        return exitFunction(outputData); // Exit if we're done
                    }
                }
                if(index <  numberOfIterations){
                    index++; // Increment our index
                    getData(loop); // Run our process, pass in the loop
                }
                else {
                    done = true; // Make sure we say we're done
                    if(exitFunction)
                        exitFunction(outputData); // Call the callback on exit
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
                done = true; // End the loop
                shouldExit = end; // Passing end as true means we still call the exit callback
            }
        };
        loop.next();
        return loop;
    }

    /*
        Call DISE API with information of neighbours.
    */
    function getMultipleNeighbour(loop)
    {
        var data = loop.iteration();
        var boundary = {"id": data["value"]["dise"], "type": data["value"]["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, data["acadYear"]).done(function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not dise data", "for "+data["dise"]);
        });
    }

    /*
        Call DISE API for same boundary for different years.
    */
    function getMultipleYear(loop)
    {
        var data = loop.iteration();
        var boundary = {"type": data["type"], "id": data["dise"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, data["acadYear"]).done(function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "for neighbour"+neighbour);
        });
    }

    /*
        Render the year data.
    */
    function renderYearComparison(data) {
        data[acadYear] = boundaryData;
        var transpose = transposeData(data);
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html());
        var yrcompareHTML = tplYearComparison({"transpose":transpose});
        $('#comparison-year').html(yrcompareHTML);
    }

    /*
        Render Neighbour data.
    */
    function renderNeighbours(data) {
        var hash = schoolInfraHash;
        var percData = {"keys":{}};
        data[data.length] = boundaryData;

        for (var each in data) {
            for (var key in data[each]["properties"]) {
                var iconTag = "";
                if(key != "name" && key != "school_count" && key in hash) {
                    for(var i in hash[key]['icon']){
                        iconTag += "<span class='" + hash[key]['icon'][i] + "'></span>   ";
                    }
                    if (!percData["keys"][key])
                        percData["keys"][key] = {"icon":iconTag,"name":hash[key]['display']};
                    if(!percData[data[each]["id"]])
                        percData[data[each]["id"]] = {"name": data[each]["properties"]["popup_content"]};
                    percData[data[each]["id"]][hash[key]['display']]= {"perc": (data[each]["properties"][key]/data[each]["properties"]["sum_schools"]) * 100};
                }
            }
        }
        var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":percData,"boundary_name":boundary_name});
        $('#comparison-neighbour').html(compareHTML);
    }

    /*
        Function for showing data vertical for years
    */
    function transposeData(data) {
        var hash = schoolInfraHash;
        var transpose = {
            "year": [],
            "school_count" : {},
            "Basic Infrastructure" : { "name":"Basic Infrastructure"},
            "Learning Environment" : { "name":"Learning Environment"},
            "Nutrition and Hygiene" : { "name":"Nutrition and Hygiene"},
            "Toilets" : { "name":"Toilets"}
        };

        var basic_infra = ["sum_has_boundary_wall","sum_has_playground","sum_has_electricity","sum_has_classrooms_in_good_condition"];
        var learning_env = ["sum_has_blackboard","sum_has_computer","sum_has_library"];
        var nut_hyg = ["sum_has_mdm","sum_has_drinking_water"];
        var toilets = ["sum_has_toilet","sum_has_toilet_girls"];

        for (var truncyear in data) {
            var year = "20"+truncyear.replace("-","-20");
            transpose["year"].push(year);
            transpose["school_count"][year] = data[truncyear]["properties"]["sum_schools"];
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
                    transpose["Basic Infrastructure"][key][year] = (infraData[key]/infraData["sum_schools"]*100);

                    
                } else if ($.inArray(key,learning_env) != -1) {
                    if(!transpose["Learning Environment"][key])
                        transpose["Learning Environment"][key] = {"name":hash[key]['display'],"icon":iconTag};
                    transpose["Learning Environment"][key][year] = (infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,nut_hyg) != -1) {
                    if(!transpose["Nutrition and Hygiene"][key])
                        transpose["Nutrition and Hygiene"][key] = {"name":hash[key]['display'],"icon":iconTag};
                    transpose["Nutrition and Hygiene"][key][year] = (infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,toilets) != -1) {
                    if(!transpose["Toilets"][key])
                        transpose["Toilets"][key] = {"name":hash[key]['display'],"icon":iconTag};
                    transpose["Toilets"][key][year] = (infraData[key]/infraData["sum_schools"]*100);
                } else {}
            }
        }
        transpose["year"].sort();
        return transpose;
    }
    
})();
