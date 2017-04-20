'use strict';
(function() {
    var utils;
    var common;
    var repUtils;
    var acadYear;
    var summaryData;
    var boundary_name;
    var boundary_type;
    var klpData;
    var diseData;
    var repType;
    klp.init = function() {
        utils = klp.boundaryUtils;
        common = klp.reportCommon;
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
        var id,lang;
        repType = repUtils.getSlashParameterByName("report_type");
        id = repUtils.getSlashParameterByName("id");
        lang = repUtils.getSlashParameterByName("language");

        if( repType == 'boundary' )
        {
            var url = "reports/dise/"+repType+"/?language="+lang+"&id="+id;
            var $xhr = klp.api.do(url);
            $xhr.done(function(data) {
                klpData = data;
                acadYear = data["academic_year"].replace(/20/g, '');
                getDiseData();
            });
        }
        else
        {
            var url = "reports/electedrep/?language="+lang+"&id="+id;
            var $xhr = klp.api.do(url);
            $xhr.done(function(data) {
                klpData = data;
                repType = common.getElectedRepType(data.report_info.type);
                acadYear = data["academic_year"].replace(/20/g, '');
                getElectedRepData();
            });
        }
    }

    /*
        Fetch dise data for the specified boundary
    */
    function getDiseData()
    {
        var boundary = {"id": klpData["report_info"]["dise"],
                        "type": klpData["report_info"]["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type,
                                     acadYear).done(function(data) {
            diseData = data;
            boundary_name = klpData["report_info"]["name"];
            boundary_type = klpData["report_info"]["type"];
            var categoryCount = common.getCategoryCount(diseData.properties);
            summaryData = common.getSummaryData(diseData,
                klpData["report_info"], categoryCount, repType, acadYear);
            common.renderSummary(summaryData);
            common.getNeighbourData(klpData, renderNeighbours);
            common.getYearData(klpData, renderYearComparison);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }

     /*
        Get Elected rep data from DISE application and render the Summary, Finance  and Comparison data.
    */
    function getElectedRepData()
    {
        var electedrep = {"id": klpData["report_info"]["dise"],
                          "type": repType};
        klp.dise_api.getElectedRepData(electedrep.id, electedrep.type,
                                       acadYear).done(function(data) {
            diseData = data;
            var categoryCount = common.getCategoryCount(diseData.properties);
            summaryData = common.getSummaryData(diseData,
                klpData["report_info"], categoryCount, repType, acadYear);
            boundary_name = klpData["report_info"]["name"];
            boundary_type = klpData["report_info"]["type"];
            common.renderSummary(summaryData);
            //Get Comparison Data
            if (klpData.neighbour_info.length != 0)
                common.getNeighbourData(klpData, renderNeighbours);
            common.getYearData(klpData, renderYearComparison);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }
 

    /*
        Render the year data.
    */
    function renderYearComparison(data) {
        data[acadYear] = diseData;
        var transpose = transposeYears(data);
        console.log(transpose);
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
        diseData["properties"]["popup_content"] = boundary_name;
        data[data.length] = diseData;
        var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"transpose":transposeNeighbors(data),"boundary_name":boundary_name, "boundary_type":boundary_type});
        $('#comparison-neighbour').html(compareHTML);
    }


    /*
        Function for showing data vertical for years
    */
    function transposeNeighbors(data) {
        var hash = schoolInfraHash;
        var transpose = {
            "boundary": [],
            "type": {},
            "school_count" : {},
            "Basic Infrastructure" : { "name":"Basic Infrastructure"},
            "Learning Environment" : { "name":"Learning Environment"},
            "Nutrition and Hygiene" : { "name":"Nutrition and Hygiene"},
            "Toilets" : { "name":"Toilets"}
        };

        var basic_infra = ["sum_has_boundary_wall",
                           "sum_has_playground",
                           "sum_has_electricity",
                           "sum_has_classrooms_in_good_condition"];
        var learning_env = ["sum_has_blackboard","sum_has_computer",
                            "sum_has_library"];
        var nut_hyg = ["sum_has_mdm","sum_has_drinking_water"];
        var toilets = ["sum_has_toilet","sum_has_toilet_girls"];

        for (var each in data) {
            transpose["boundary"].push(data[each]["properties"]["popup_content"]);
            transpose["school_count"][data[each]["properties"]["popup_content"]] =
                                data[each]["properties"]["sum_schools"];
            transpose["type"][data[each]["properties"]["popup_content"]] =
                                data[each]["properties"]["entity_type"];
            var infraData = data[each]["properties"];
            for (var key in infraData) {
                var iconTag = "";
                if(key != "boundary" && key != "school_count" && key in hash)
                {
                    for(var i in hash[key]['icon']){
                        iconTag += "<span class='" + hash[key]['icon'][i] +
                                                                "'></span>   ";
                    }
                }
                if ($.inArray(key,basic_infra) != -1 ) {
                    if(!transpose["Basic Infrastructure"][key])
                        transpose["Basic Infrastructure"][key] = {
                                                "name":hash[key]['display'],
                                                "icon":iconTag};
                    transpose["Basic Infrastructure"][key][data[each]["properties"]["popup_content"]] = (
                                infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,learning_env) != -1) {
                    if(!transpose["Learning Environment"][key])
                        transpose["Learning Environment"][key] = {
                                                "name":hash[key]['display'],
                                                "icon":iconTag};
                    transpose["Learning Environment"][key][data[each]["properties"]["popup_content"]] = (
                                infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,nut_hyg) != -1) {
                    if(!transpose["Nutrition and Hygiene"][key])
                        transpose["Nutrition and Hygiene"][key] = {
                                                    "name":hash[key]['display'],
                                                    "icon":iconTag};
                    transpose["Nutrition and Hygiene"][key][data[each]["properties"]["popup_content"]] = (
                                infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,toilets) != -1) {
                    if(!transpose["Toilets"][key])
                        transpose["Toilets"][key] = {
                                                    "name":hash[key]['display'],
                                                    "icon":iconTag};
                    transpose["Toilets"][key][data[each]["properties"]["popup_content"]] = (
                                infraData[key]/infraData["sum_schools"]*100);
                }
            }
        }
        transpose["boundary"].sort();
        return transpose;
    }
    
    /*
        Function for showing data vertical for years
    */
    function transposeYears(data) {
        var hash = schoolInfraHash;
        var transpose = {
            "year": [],
            "school_count" : {},
            "Basic Infrastructure" : { "name":"Basic Infrastructure"},
            "Learning Environment" : { "name":"Learning Environment"},
            "Nutrition and Hygiene" : { "name":"Nutrition and Hygiene"},
            "Toilets" : { "name":"Toilets"}
        };

        var basic_infra = ["sum_has_boundary_wall",
                           "sum_has_playground",
                           "sum_has_electricity",
                           "sum_has_classrooms_in_good_condition"];
        var learning_env = ["sum_has_blackboard","sum_has_computer",
                            "sum_has_library"];
        var nut_hyg = ["sum_has_mdm","sum_has_drinking_water"];
        var toilets = ["sum_has_toilet","sum_has_toilet_girls"];

        for (var truncyear in data) {
            var year = "20"+truncyear.replace("-","-20");
            transpose["year"].push(year);
            transpose["school_count"][year] =
                                data[truncyear]["properties"]["sum_schools"];
            var infraData = data[truncyear]["properties"];
            for (var key in infraData) {
                var iconTag = "";
                if(key != "year" && key != "school_count" && key in hash)
                {
                    for(var i in hash[key]['icon']){
                        iconTag += "<span class='" + hash[key]['icon'][i] +
                                                                "'></span>   ";
                    }
                }
                if ($.inArray(key,basic_infra) != -1 ) {
                    if(!transpose["Basic Infrastructure"][key])
                        transpose["Basic Infrastructure"][key] = {
                                                "name":hash[key]['display'],
                                                "icon":iconTag};
                    transpose["Basic Infrastructure"][key][year] = (
                                infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,learning_env) != -1) {
                    if(!transpose["Learning Environment"][key])
                        transpose["Learning Environment"][key] = {
                                                "name":hash[key]['display'],
                                                "icon":iconTag};
                    transpose["Learning Environment"][key][year] = (
                                infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,nut_hyg) != -1) {
                    if(!transpose["Nutrition and Hygiene"][key])
                        transpose["Nutrition and Hygiene"][key] = {
                                                    "name":hash[key]['display'],
                                                    "icon":iconTag};
                    transpose["Nutrition and Hygiene"][key][year] = (
                                infraData[key]/infraData["sum_schools"]*100);
                } else if ($.inArray(key,toilets) != -1) {
                    if(!transpose["Toilets"][key])
                        transpose["Toilets"][key] = {
                                                    "name":hash[key]['display'],
                                                    "icon":iconTag};
                    transpose["Toilets"][key][year] = (
                                infraData[key]/infraData["sum_schools"]*100);
                }
            }
        }
        transpose["year"].sort();
        return transpose;
    }
    
})();
