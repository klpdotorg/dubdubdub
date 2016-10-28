'use strict';
(function() {
    var utils;
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    var lowerUpperPrimary = [2, 3, 6];
    var onlyUpperPrimary = [4, 5, 7];
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        utils  = klp.reportUtils;
        fetchReportDetails();
        klp.router.start();
    };

    function fetchReportDetails()
    {
        var repType,bid,lang;
        repType = utils.getSlashParameterByName("report_type");
        bid = utils.getSlashParameterByName("id");
        lang = utils.getSlashParameterByName("language");
        var url = "reports/dise/"+repType+"/?language="+lang+"&id="+bid;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            fetchDiseData(data);
        });
    }

    function getCategoryCount(data)
    {
        var categorycount = {"schoolcount": 0,
                             "gendercount":  {"boys": 0, "girls": 0}
                            }

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

    function getSummaryData(data, diseData){
        var categoryData = getCategoryCount(diseData["properties"]);
        var summaryJSON = {
            "boundary"  : data["boundary_info"],
            "school_count" : categoryData["schoolcount"],
            "teacher_count" : diseData["properties"]["sum_male_tch"] + diseData["properties"]["sum_female_tch"],
            "gender" : categoryData["gendercount"],
        };
        return summaryJSON;
    }

    function fetchDiseData(data)
    {
        var acadYear = data["academic_year"].replace(/20/g, '');
        var boundary = {"type": data["boundary_info"]["type"], "id": data["boundary_info"]["dise"] };
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
            console.log('diseData', diseData);
            var summaryJSON = getSummaryData(data,diseData);
            renderSummary(summaryJSON,"Schools");
            loadFinanceData(diseData["properties"]);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
        getNeighbourData(data, acadYear);
    }

    function getNeighbourData(data, acadYear)
    {
        var type = data["boundary_info"]["type"];
        if(type == "district")
        {
            klp.dise_api.getMultipleBoundaryData(null, null, type, acadYear).done(function(diseData) {
                console.log('neighbours diseData', diseData);
                renderNeighbours(diseData["results"]["features"]);
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
            });
        }
        else
        {
            var boundary = {"type": data["boundary_info"]["parent"]["type"], "id":data["boundary_info"]["parent"]["dise"]};
            klp.dise_api.getMultipleBoundaryData(boundary.id, boundary.type, type, acadYear).done(function(diseData) {
                console.log('neighbours diseData', diseData);
                renderNeighbours(diseData["results"]["features"]);
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
            });
        }
    }

    function getTotalExpectedGrant(diseData){
        var expectedGrant = 0;
        for( var index in diseData["school_categories"])
        {
            var type = diseData["school_categories"][index];
            var devgrant = 0;
            var maintenance_grant = 0;
            if( type["id"] == 1)
            {
                devgrant = type["sum_schools"]["total"] * 5000;
                maintenance_grant += type["sum_schools"]["classrooms_leq_3"] * 5000;
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] * 7500;
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] * 10000;
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] * 10000;
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] * 10000;
                expectedGrant += devgrant + maintenance_grant;
            }
            if(_.contains(lowerUpperPrimary, type["id"]))
            {
                devgrant = type["sum_schools"]["total"] * 12000;
                maintenance_grant += type["sum_schools"]["classrooms_leq_3"] * 5000;
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] * 7500;
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] * 10000;
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] * 15000;
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] * 20000;
                expectedGrant += devgrant + maintenance_grant;
            }
            if(_.contains(onlyUpperPrimary, type["id"]))
            {
                devgrant = type["sum_schools"]["total"] * 7000;
                maintenance_grant += type["sum_schools"]["classrooms_leq_3"] * 5000;
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] * 7500;
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] * 10000;
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] * 10000;
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] * 10000;
                expectedGrant += devgrant + maintenance_grant;
            }
        }
        return expectedGrant;
    }

    function getExpectedGrant(diseData){
        var expectedGrant = {};
        expectedGrant["categories"] = {
            "lprimary_grant" : {"name": "Lower Primary", "school_count": 0, "student_count":0,
                                "school_grant": {"grant": 0, "per_school": 0, "per_student": 0},
                                "maintenance_grant":{"grant": 0, "per_school": 0, "per_student":0},
                                "grand_total": 0},
            "uprimary_grant" : {"name": "Upper Primary (Class 6-8)", "school_count": 0, "student_count":0,
                                "school_grant": {"grant": 0, "per_school": 0, "per_student": 0},
                                "maintenance_grant":{"grant": 0, "per_school": 0, "per_student":0},
                                "grand_total":0},
            "l_uprimary_grant" : {"name": "Upper Primary (Class 1-8)", "school_count": 0, "student_count":0,
                                  "school_grant": {"grant": 0, "per_school": 0, "per_student": 0},
                                  "maintenance_grant":{"grant": 0, "per_school": 0, "per_student":0},
                                  "grand_total":0}
        };
        expectedGrant["classrooms"] = [
            {
                "type":"With <= 3 Classrooms",
                "categories": [
                    { 
                        "name": "Lower Primary",
                        "schools" : 0,
                        "grant_amount" : 5000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 1-8)",
                        "schools" : 0,
                        "grant_amount" : 5000,
                        "students" : 0
                    },
                    {
                        "name": "Upper Primary (Class 6-8)",
                        "schools" : 0,
                        "grant_amount" : 5000,
                        "students" : 0
                    }
                ]
            },
            {
                "type":"With 4 Classrooms",
                "categories": [
                    { 
                        "name": "Lower Primary",
                        "schools" : 0,
                        "grant_amount" : 7500,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 1-8)",
                        "schools" : 0,
                        "grant_amount" : 7500,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 6-8)",
                        "schools" : 0,
                        "grant_amount" : 7500,
                        "students" : 0
                    }
                ]
            },
            {
                "type": "With 5 Classrooms",
                "categories": [
                    { 
                        "name": "Lower Primary",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 1-8)",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 6-8)",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    }
                ]
            },
            {   "type": "With 6-7 Classrooms",
                "categories" : [
                    { 
                        "name": "Lower Primary",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 1-8)",
                        "schools" : 0,
                        "grant_amount" : 15000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 6-8)",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    }
                ]
            },
            {   
                "type": "With >= 8 Classrooms",
                "categories" : [
                    { 
                        "name": "Lower Primary",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 1-8)",
                        "schools" : 0,
                        "grant_amount" : 20000,
                        "students" : 0
                    },
                    { 
                        "name": "Upper Primary (Class 6-8)",
                        "schools" : 0,
                        "grant_amount" : 10000,
                        "students" : 0
                    }
                ]
            }
        ];

        for( var index in diseData["school_categories"])
        {
            var type = diseData["school_categories"][index];
            var devgrant = 0;
            var total_students = 0;
            var maintenance_grant = 0;
            if( type["id"] == 1)
            {
                //Lower Primary
                devgrant = type["sum_schools"]["total"] * 5000;
                total_students = type["sum_boys"] + type["sum_girls"];
                expectedGrant["classrooms"][0]["categories"][0]["schools"] = type["sum_schools"]["classrooms_leq_3"];
                maintenance_grant = type["sum_schools"]["classrooms_leq_3"] * 5000;

                expectedGrant["classrooms"][1]["categories"][0]["schools"] = type["sum_schools"]["classrooms_eq_4"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] * 7500;

                expectedGrant["classrooms"][2]["categories"][0]["schools"] = type["sum_schools"]["classrooms_eq_5"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] * 10000;

                expectedGrant["classrooms"][3]["categories"][0]["schools"] = type["sum_schools"]["classrooms_mid_67"];
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] * 10000;

                expectedGrant["classrooms"][4]["categories"][0]["schools"] = type["sum_schools"]["classrooms_geq_8"];
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] * 10000;
                
                expectedGrant["categories"]["lprimary_grant"]["school_count"] = type["sum_schools"]["total"];
                expectedGrant["categories"]["lprimary_grant"]["school_grant"]["grant"] = devgrant;
                expectedGrant["categories"]["lprimary_grant"]["school_grant"]["per_school"] = 5000;
                expectedGrant["categories"]["lprimary_grant"]["school_grant"]["per_student"] = Math.round(devgrant/total_students*100)/100;
                expectedGrant["categories"]["lprimary_grant"]["maintenance_grant"]["grant"] = maintenance_grant;
                expectedGrant["categories"]["lprimary_grant"]["maintenance_grant"]["per_school"] = Math.round(maintenance_grant/type["sum_schools"]["total"]*100)/100;
                expectedGrant["categories"]["lprimary_grant"]["maintenance_grant"]["per_student"] = Math.round(maintenance_grant/total_students*100)/100;
                expectedGrant["categories"]["lprimary_grant"]["grand_total"] = devgrant + maintenance_grant;
                expectedGrant["categories"]["lprimary_grant"]["school_grant"]["grant_perc"] = Math.round(devgrant*100/expectedGrant["categories"]["lprimary_grant"]["grand_total"]*100)/100;
            }
            if(_.contains(lowerUpperPrimary, type["id"]))
            {
                //Primary with upper primary
                devgrant = type["sum_schools"]["total"] * 12000;
                total_students = type["sum_boys"] + type["sum_girls"];

                expectedGrant["classrooms"][0]["categories"][1]["schools"] += type["sum_schools"]["classrooms_leq_3"];
                maintenance_grant = type["sum_schools"]["classrooms_leq_3"] * 5000;

                expectedGrant["classrooms"][1]["categories"][1]["schools"] += type["sum_schools"]["classrooms_eq_4"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] * 7500;

                expectedGrant["classrooms"][2]["categories"][1]["schools"] += type["sum_schools"]["classrooms_eq_5"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] * 10000;

                expectedGrant["classrooms"][3]["categories"][1]["schools"] += type["sum_schools"]["classrooms_mid_67"];
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] * 15000;

                expectedGrant["classrooms"][4]["categories"][1]["schools"] += type["sum_schools"]["classrooms_geq_8"];
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] * 20000;

                expectedGrant["categories"]["l_uprimary_grant"]["school_count"] += type["sum_schools"]["total"];
                expectedGrant["categories"]["l_uprimary_grant"]["student_count"] += total_students;
                expectedGrant["categories"]["l_uprimary_grant"]["school_grant"]["grant"] += devgrant;
                expectedGrant["categories"]["l_uprimary_grant"]["school_grant"]["per_school"] = 12000;
                expectedGrant["categories"]["l_uprimary_grant"]["maintenance_grant"]["grant"] += maintenance_grant;
                expectedGrant["categories"]["l_uprimary_grant"]["grand_total"] += devgrant + maintenance_grant;
                
            }
            if(_.contains(onlyUpperPrimary, type["id"]))
            {
                //Upper Primary Only
                devgrant = type["sum_schools"]["total"] * 7000;
                total_students = type["sum_boys"] + type["sum_girls"];
                expectedGrant["classrooms"][0]["categories"][2]["schools"] += type["sum_schools"]["classrooms_leq_3"];
                maintenance_grant = type["sum_schools"]["classrooms_leq_3"] * 5000;

                expectedGrant["classrooms"][1]["categories"][2]["schools"] += type["sum_schools"]["classrooms_eq_4"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] * 7500;

                expectedGrant["classrooms"][2]["categories"][2]["schools"] += type["sum_schools"]["classrooms_eq_5"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] * 10000;

                expectedGrant["classrooms"][3]["categories"][2]["schools"] += type["sum_schools"]["classrooms_mid_67"];
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] * 10000;

                expectedGrant["classrooms"][4]["categories"][2]["schools"] += type["sum_schools"]["classrooms_geq_8"];
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] * 10000;
                
                expectedGrant["categories"]["uprimary_grant"]["school_count"] += type["sum_schools"]["total"];
                expectedGrant["categories"]["uprimary_grant"]["student_count"] += total_students; 
                expectedGrant["categories"]["uprimary_grant"]["school_grant"]["grant"] += devgrant;
                expectedGrant["categories"]["uprimary_grant"]["school_grant"]["per_school"] = 7000;
                expectedGrant["categories"]["uprimary_grant"]["maintenance_grant"]["grant"] += maintenance_grant;
                expectedGrant["categories"]["uprimary_grant"]["grand_total"] += devgrant + maintenance_grant;

            }
        }
        expectedGrant["categories"]["l_uprimary_grant"]["school_grant"]["per_student"] = Math.round(expectedGrant["categories"]["l_uprimary_grant"]["school_grant"]["grant"]/expectedGrant["categories"]["l_uprimary_grant"]["student_count"]*100)/100;
        expectedGrant["categories"]["l_uprimary_grant"]["maintenance_grant"]["per_school"] = Math.round(expectedGrant["categories"]["l_uprimary_grant"]["maintenance_grant"]["grant"]/expectedGrant["categories"]["l_uprimary_grant"]["school_count"]*100)/100;
        expectedGrant["categories"]["l_uprimary_grant"]["maintenance_grant"]["per_student"] = Math.round(expectedGrant["categories"]["l_uprimary_grant"]["maintenance_grant"]["grant"]/expectedGrant["categories"]["l_uprimary_grant"]["student_count"]*100)/100;
        expectedGrant["categories"]["l_uprimary_grant"]["school_grant"]["grant_perc"] = Math.round(expectedGrant["categories"]["l_uprimary_grant"]["school_grant"]["grant"]*100/expectedGrant["categories"]["l_uprimary_grant"]["grand_total"]*100)/100;

        expectedGrant["categories"]["uprimary_grant"]["school_grant"]["per_student"] = Math.round(expectedGrant["categories"]["uprimary_grant"]["school_grant"]["grant"]/expectedGrant["categories"]["uprimary_grant"]["student_count"]*100)/100;
        expectedGrant["categories"]["uprimary_grant"]["maintenance_grant"]["per_school"] = Math.round(expectedGrant["categories"]["uprimary_grant"]["maintenance_grant"]["grant"]/expectedGrant["categories"]["uprimary_grant"]["school_count"]*100)/100;
        expectedGrant["categories"]["uprimary_grant"]["maintenance_grant"]["per_student"] = Math.round(expectedGrant["categories"]["uprimary_grant"]["maintenance_grant"]["grant"]/expectedGrant["categories"]["uprimary_grant"]["student_count"]*100)/100;
        expectedGrant["categories"]["uprimary_grant"]["school_grant"]["grant_perc"] = Math.round(expectedGrant["categories"]["uprimary_grant"]["school_grant"]["grant"]*100/expectedGrant["categories"]["uprimary_grant"]["grand_total"]*100)/100;

        expectedGrant["grand_total"] = expectedGrant["categories"]["lprimary_grant"]["grand_total"] + expectedGrant["categories"]["uprimary_grant"]["grand_total"] + expectedGrant["categories"]["l_uprimary_grant"]["grand_total"];

        return expectedGrant;
    }

    function loadFinanceData(diseData) {
        var grantdata = {};
        var categoryData = getCategoryCount(diseData);
        var sum_students = categoryData["gendercount"]["boys"] + categoryData["gendercount"]["girls"];
        var total_students = diseData["sum_girls"] + diseData["sum_boys"];
        grantdata["expected"] = getExpectedGrant(diseData);
        grantdata["expected"]["total_girl"] = categoryData["gendercount"]["girls"];
        grantdata["expected"]["total_boy"] = categoryData["gendercount"]["boys"];
        grantdata["expected"]["per_stu"] = Math.round(grantdata["expected"]["grand_total"]/sum_students*100)/100;
        grantdata["received"] = {"grand_total": diseData["sum_school_dev_grant_recd"] + diseData["sum_tlm_grant_recd"]};
        grantdata["received"]["per_stu"] = Math.round(grantdata["received"]["grand_total"]/total_students*100)/100;
        grantdata["expenditure"] = {"grand_total": diseData["sum_school_dev_grant_expnd"] + diseData["sum_tlm_grant_expnd"]};
        grantdata["expenditure"]["per_stu"] = Math.round(grantdata["expenditure"]["grand_total"]/total_students*100)/100;
           
        renderGrants(grantdata);
        renderAllocation(grantdata["expected"]["categories"], "School Grant Allocation", '#sg-alloc');
        renderMntncAllocation(grantdata["expected"]["classrooms"], "School Maintenance Grant Allocation", "#smg-alloc");
    }
    
    function renderSummary(data, schoolType) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplReportDate = swig.compile($('#tpl-reportDate').html());
        var now = new Date();
        var today = {'date' : moment(now).format("MMMM D, YYYY")};
        var dateHTML = tplReportDate({"today":today});
        $('#report-date').html(dateHTML);

        data['student_total'] = data["gender"]["boys"] + data["gender"]["girls"];
        data['ptr'] = Math.round(data["student_total"]/data["teacher_count"]*100)/100;
        data['girl_perc'] = Math.round(( data["gender"]["girls"]/data["student_total"] )* 100*100)/100;
        data['boy_perc'] = 100-data['girl_perc'];
        
        var topSummaryHTML = tplTopSummary({"data":data});
        $('#top-summary').html(topSummaryHTML);
    }

    function renderGrants(data){
        var tpl = swig.compile($('#tpl-grantSummary').html());
        var html = tpl({"data":data["expected"]});
        $('#expected').html(html);
        
        data["received"]["total_perc"] = Math.round(data.received.grand_total*100/data.expected.grand_total *100)/100;
        data["received"]["perc_label"] = "received";
        html = tpl({"data":data["received"]});
        $('#received').html(html);

        data["expenditure"]["total_perc"] = Math.round(data.expenditure.grand_total*100/data.received.grand_total * 100)/100;
        data["expenditure"]["perc_label"] = "spend";
        html = tpl({"data":data["expenditure"]});
        $('#expenditure').html(html);
    }

    function renderAllocation(data, heading, element_id) {
        var tplalloc = swig.compile($('#tpl-allocSummary').html());
        var html = tplalloc({"data":data,"heading":heading});
        $(element_id).html(html);
    }

    function renderMntncAllocation(data, heading, element_id) {
        var tplalloc = swig.compile($('#tpl-allocMntncSummary').html());
        var html = tplalloc({"data":data,"heading":heading});
        $(element_id).html(html);
    }

    function renderNeighbours(data) {
        var comparisonData = {};
        var total_schools = 0;
        for (var each in data) {
            var categoryData = getCategoryCount(data[each]["properties"]);
            comparisonData[data[each]["id"]] = {
                "name": data[each]["properties"]["popup_content"],
                "expected": getTotalExpectedGrant(data[each]["properties"]),
                "received": data[each]["properties"]["sum_school_dev_grant_recd"] + data[each]["properties"]["sum_tlm_grant_recd"],
                "expenditure": data[each]["properties"]["sum_school_dev_grant_expnd"] + data[each]["properties"]["sum_tlm_grant_expnd"],
                "total": categoryData["schoolcount"]
            };
            total_schools += categoryData["schoolcount"]
        }
        for( var iter in comparisonData){
            comparisonData[iter]["total_perc"] = Math.round(comparisonData[iter]["total"]*100/total_schools*100)/100;
        }
        console.log('comparisonData', comparisonData);
        var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":comparisonData});
        $('#comparison-neighbour').html(compareHTML);
    }
})();
