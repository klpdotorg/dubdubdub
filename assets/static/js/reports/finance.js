'use strict';
(function() {
    var utils;
    var common;
    var klpData;
    var acadYear;
    var summaryData;
    var categoryData;
    var repType;
    var boundary_name;
    var boundary_type;
    var grantData = {};
    var lowerUpperPrimary = [2, 3, 6];
    var onlyUpperPrimary = [4, 5, 7];
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        utils  = klp.reportUtils;
        common = klp.reportCommon;
        fetchReportDetails();
        klp.router.start();
    };

    /*
        Fetch basic dise slug and academic year details from backend
    */
    function fetchReportDetails()
    {
        var id, lang;
        repType = utils.getSlashParameterByName("report_type");
        id = utils.getSlashParameterByName("id");
        lang = utils.getSlashParameterByName("language");
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
        Get Elected rep data from DISE application and render the Summary, 
        Finance  and Comparison data.
    */
    function getElectedRepData()
    {
        var electedrep = {"id": klpData["report_info"]["dise"],
                          "type": repType};
        klp.dise_api.getElectedRepData(electedrep.id, electedrep.type,
                                       acadYear).done(function(diseData) {
            categoryData = common.getCategoryCount(diseData.properties);
            summaryData = common.getSummaryData(diseData,
                                                klpData["report_info"],
                                                categoryData,
                                                repType,
                                                acadYear);
            boundary_name = klpData["report_info"]["name"];
            boundary_type = klpData["report_info"]["type"];
            common.renderSummary(summaryData);
            loadFinanceData(diseData["properties"]);
            //Get Comparison Data
            if (klpData.neighbour_info.length != 0)
                common.getNeighbourData(klpData, renderNeighbours);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }
 

    /*
        Fetch dise data for the specified boundary
    */
    function getDiseData()
    {
        var boundary = {"type": klpData["report_info"]["type"],
                        "id": klpData["report_info"]["dise"] };
        klp.dise_api.getBoundaryData(boundary.id, boundary.type,
                                     acadYear).done(function(diseData) {
            boundary_name = klpData["report_info"]["name"];
            boundary_type = klpData["report_info"]["type"];
            categoryData = common.getCategoryCount(diseData.properties);
            summaryData = common.getSummaryData(diseData,
                                                klpData["report_info"],
                                                categoryData,
                                                repType,
                                                acadYear);
            common.renderSummary(summaryData);
            loadFinanceData(diseData["properties"]);
            common.getNeighbourData(klpData, renderNeighbours);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }

    /*
        Fill the data structure with Expected, Received and Spent grants.
    */
    function loadFinanceData(diseData) {
        //Using category student count for expected calculation
        var sum_students = categoryData["gendercount"]["boys"] +
                           categoryData["gendercount"]["girls"];
        //Using total student count for received and spent
        var total_students = diseData["sum_girls"] + diseData["sum_boys"];
        grantData["expected"] = getExpectedGrant(diseData);
        grantData["expected"]["total_girl"] = categoryData["gendercount"]["girls"];
        grantData["expected"]["total_boy"] = categoryData["gendercount"]["boys"];
        grantData["expected"]["per_stu"] = Math.round(
                    grantData["expected"]["grand_total"]/sum_students*100)/100;
        grantData["received"] = {"grand_total":
                                        diseData["sum_school_dev_grant_recd"] +
                                        diseData["sum_tlm_grant_recd"]};
        grantData["received"]["per_stu"] = Math.round(
                grantData["received"]["grand_total"]/total_students*100)/100;
        grantData["expenditure"] = {"grand_total":
                                        diseData["sum_school_dev_grant_expnd"] +
                                        diseData["sum_tlm_grant_expnd"]};
        grantData["expenditure"]["per_stu"] = Math.round(
                grantData["expenditure"]["grand_total"]/total_students*100)/100;
           
        renderGrants(grantData);
        renderAllocation(grantData["expected"]["categories"],
                         "School Grant Allocation", '#sg-alloc');
        renderMntncAllocation(grantData["expected"]["classrooms"],
                              "School Maintenance Grant Allocation",
                              "#smg-alloc");
    }

    /*
        Calculates and returns expected grant based on categories
    */
    function getExpectedGrant(diseData){
        var expectedGrant = {};
        expectedGrant["categories"] = {
            "lprimary_grant" : {"name": "Lower Primary",
                                "school_count": 0,
                                "student_count":0,
                                "school_grant": {"grant": 0,
                                                 "per_school": 0,
                                                 "per_student": 0},
                                "maintenance_grant":{"grant": 0,
                                                     "per_school": 0,
                                                     "per_student":0},
                                "grand_total": 0},
            "uprimary_grant" : {"name": "Upper Primary (Class 6-8)",
                                "school_count": 0,
                                "student_count":0,
                                "school_grant": {"grant": 0,
                                                 "per_school": 0,
                                                 "per_student": 0},
                                "maintenance_grant":{"grant": 0,
                                                     "per_school": 0,
                                                     "per_student":0},
                                "grand_total":0},
            "l_uprimary_grant" : {"name": "Upper Primary (Class 1-8)",
                                  "school_count": 0,
                                  "student_count":0,
                                  "school_grant": {"grant": 0,
                                                   "per_school": 0,
                                                   "per_student": 0},
                                  "maintenance_grant":{"grant": 0,
                                                       "per_school": 0,
                                                       "per_student":0},
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
                expectedGrant["classrooms"][0]["categories"][0]["schools"] =
                                        type["sum_schools"]["classrooms_leq_3"];
                maintenance_grant = type["sum_schools"]["classrooms_leq_3"] *
                                                                        5000;

                expectedGrant["classrooms"][1]["categories"][0]["schools"] =
                                        type["sum_schools"]["classrooms_eq_4"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] *
                                                                        7500;

                expectedGrant["classrooms"][2]["categories"][0]["schools"] =
                                        type["sum_schools"]["classrooms_eq_5"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] *
                                                                        10000;

                expectedGrant["classrooms"][3]["categories"][0]["schools"] =
                                    type["sum_schools"]["classrooms_mid_67"];
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] *
                                                                        10000;

                expectedGrant["classrooms"][4]["categories"][0]["schools"] =
                                        type["sum_schools"]["classrooms_geq_8"];
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] *
                                                                        10000;
                
                expectedGrant["categories"]["lprimary_grant"]["school_count"] =
                                                type["sum_schools"]["total"];
                expectedGrant.categories.lprimary_grant.school_grant.grant =
                                                                    devgrant;
                expectedGrant.categories.lprimary_grant.school_grant.
                                                        per_school = 5000;
                expectedGrant.categories.lprimary_grant.school_grant.
                                        per_student = Math.round(
                                            devgrant/total_students*100)/100;
                expectedGrant.categories.lprimary_grant.maintenance_grant.
                                                    grant = maintenance_grant;
                expectedGrant.categories.lprimary_grant.maintenance_grant.
                                    per_school = Math.round(maintenance_grant/
                                        type["sum_schools"]["total"]*100)/100;
                expectedGrant.categories.lprimary_grant.maintenance_grant.
                                    per_student = Math.round(maintenance_grant/
                                                        total_students*100)/100;
                expectedGrant.categories.lprimary_grant.grand_total =
                                                devgrant + maintenance_grant;
                expectedGrant.categories.lprimary_grant.school_grant.
                    grant_perc = Math.round(devgrant*100/
                    expectedGrant.categories.lprimary_grant.grand_total*100)/100;
            }
            if(_.contains(lowerUpperPrimary, type["id"]))
            {
                //Primary with upper primary
                devgrant = type["sum_schools"]["total"] * 12000;
                total_students = type["sum_boys"] + type["sum_girls"];

                expectedGrant["classrooms"][0]["categories"][1]["schools"] +=
                                        type["sum_schools"]["classrooms_leq_3"];
                maintenance_grant = type["sum_schools"]["classrooms_leq_3"] *
                                                                        5000;

                expectedGrant["classrooms"][1]["categories"][1]["schools"] +=
                                        type["sum_schools"]["classrooms_eq_4"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] *
                                                                        7500;

                expectedGrant["classrooms"][2]["categories"][1]["schools"] +=
                                        type["sum_schools"]["classrooms_eq_5"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] *
                                                                        10000;

                expectedGrant["classrooms"][3]["categories"][1]["schools"] +=
                                    type["sum_schools"]["classrooms_mid_67"];
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] *
                                                                        15000;

                expectedGrant["classrooms"][4]["categories"][1]["schools"] +=
                                        type["sum_schools"]["classrooms_geq_8"];
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] *
                                                                        20000;

                expectedGrant.categories.l_uprimary_grant.school_count +=
                                                type["sum_schools"]["total"];
                expectedGrant.categories.l_uprimary_grant.student_count +=
                                                                total_students;
                expectedGrant.categories.l_uprimary_grant.school_grant.grant +=
                                                                    devgrant;
                expectedGrant.categories.l_uprimary_grant.school_grant.
                                                            per_school = 12000;
                expectedGrant.categories.l_uprimary_grant.maintenance_grant.
                                                    grant += maintenance_grant;
                expectedGrant.categories.l_uprimary_grant.grand_total +=
                                                devgrant + maintenance_grant;
                
            }
            if(_.contains(onlyUpperPrimary, type["id"]))
            {
                //Upper Primary Only
                devgrant = type["sum_schools"]["total"] * 7000;
                total_students = type["sum_boys"] + type["sum_girls"];
                expectedGrant["classrooms"][0]["categories"][2]["schools"] +=
                                        type["sum_schools"]["classrooms_leq_3"];
                maintenance_grant = type["sum_schools"]["classrooms_leq_3"] *
                                                                        5000;

                expectedGrant["classrooms"][1]["categories"][2]["schools"] +=
                                        type["sum_schools"]["classrooms_eq_4"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] *
                                                                        7500;

                expectedGrant["classrooms"][2]["categories"][2]["schools"] +=
                                        type["sum_schools"]["classrooms_eq_5"];
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] *
                                                                        10000;

                expectedGrant["classrooms"][3]["categories"][2]["schools"] +=
                                    type["sum_schools"]["classrooms_mid_67"];
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] *
                                                                        10000;

                expectedGrant["classrooms"][4]["categories"][2]["schools"] +=
                                        type["sum_schools"]["classrooms_geq_8"];
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] *
                                                                        10000;
                
                expectedGrant.categories.uprimary_grant.school_count +=
                                            type["sum_schools"]["total"];
                expectedGrant.categories.uprimary_grant.student_count +=
                                                                total_students;
                expectedGrant.categories.uprimary_grant.school_grant.grant +=
                                                                    devgrant;
                expectedGrant.categories.uprimary_grant.school_grant.
                                                            per_school = 7000;
                expectedGrant.categories.uprimary_grant.maintenance_grant.
                                                    grant += maintenance_grant;
                expectedGrant.categories.uprimary_grant.grand_total +=
                                                devgrant + maintenance_grant;

            }
        }
        expectedGrant.categories.l_uprimary_grant.school_grant.per_student =
            Math.round(
                expectedGrant.categories.l_uprimary_grant.school_grant.grant/
                expectedGrant.categories.l_uprimary_grant.student_count*100)/100;
        expectedGrant.categories.l_uprimary_grant.maintenance_grant.per_school =
            Math.round(
                expectedGrant.categories.l_uprimary_grant.maintenance_grant.grant/
                expectedGrant.categories.l_uprimary_grant.school_count*100)/100;
        expectedGrant.categories.l_uprimary_grant.maintenance_grant.per_student =
            Math.round(
                expectedGrant.categories.l_uprimary_grant.maintenance_grant.grant/
                expectedGrant.categories.l_uprimary_grant.student_count*100)/100;
        expectedGrant.categories.l_uprimary_grant.school_grant.grant_perc =
            Math.round(
                expectedGrant.categories.l_uprimary_grant.school_grant.grant*
                100/expectedGrant.categories.l_uprimary_grant.grand_total*100)/
                                                                            100;
        expectedGrant.categories.uprimary_grant.school_grant.per_student =
            Math.round(
                expectedGrant.categories.uprimary_grant.school_grant.grant/
                expectedGrant.categories.uprimary_grant.student_count*100)/100;
        expectedGrant.categories.uprimary_grant.maintenance_grant.per_school =
            Math.round(
                expectedGrant.categories.uprimary_grant.maintenance_grant.grant/
                expectedGrant.categories.uprimary_grant.school_count*100)/100;
        expectedGrant.categories.uprimary_grant.maintenance_grant.per_student =
            Math.round(
                expectedGrant.categories.uprimary_grant.maintenance_grant.grant/
                expectedGrant.categories.uprimary_grant.student_count*100)/100;
        expectedGrant.categories.uprimary_grant.school_grant.grant_perc =
            Math.round(
                expectedGrant.categories.uprimary_grant.school_grant.grant*100/
                expectedGrant.categories.uprimary_grant.grand_total*100)/100;

        expectedGrant["grand_total"] = expectedGrant.categories.lprimary_grant.
                        grand_total +
                        expectedGrant.categories.uprimary_grant.grand_total +
                        expectedGrant.categories.l_uprimary_grant.grand_total;

        return expectedGrant;
    }

    /*
        Renders the Grant Summary
    */
    function renderGrants(data){
        var tpl = swig.compile($('#tpl-grantSummary').html());
        var html = tpl({"data":data["expected"]});
        $('#expected').html(html);
        
        data["received"]["total_perc"] = Math.round(
            data.received.grand_total*100/data.expected.grand_total*100)/100;
        data["received"]["perc_label"] = "expected";
        html = tpl({"data":data["received"]});
        $('#received').html(html);

        data["expenditure"]["total_perc"] = Math.round(
            data.expenditure.grand_total*100/data.received.grand_total*100)/100;
        data["expenditure"]["perc_label"] = "received";
        html = tpl({"data":data["expenditure"]});
        $('#expenditure').html(html);
    }

    /*
        Renders the Allocation Summary
    */
    function renderAllocation(data, heading, element_id) {
        var tplalloc = swig.compile($('#tpl-allocSummary').html());
        var html = tplalloc({"data":data,"heading":heading});
        $(element_id).html(html);
    }

    /*
        Renders the Maintainance Summary
    */
    function renderMntncAllocation(data, heading, element_id) {
        var tplalloc = swig.compile($('#tpl-allocMntncSummary').html());
        var html = tplalloc({"data":data,"heading":heading});
        $(element_id).html(html);
    }

    /*
        Get the total grant that is expected
    */
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
                maintenance_grant += type["sum_schools"]["classrooms_leq_3"] *
                                                                        5000;
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] *
                                                                        7500;
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] *
                                                                        10000;
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] *
                                                                        10000;
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] *
                                                                        10000;
                expectedGrant += devgrant + maintenance_grant;
            }
            if(_.contains(lowerUpperPrimary, type["id"]))
            {
                devgrant = type["sum_schools"]["total"] * 12000;
                maintenance_grant += type["sum_schools"]["classrooms_leq_3"] *
                                                                        5000;
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] *
                                                                        7500;
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] *
                                                                        10000;
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] *
                                                                        15000;
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] *
                                                                        20000;
                expectedGrant += devgrant + maintenance_grant;
            }
            if(_.contains(onlyUpperPrimary, type["id"]))
            {
                devgrant = type["sum_schools"]["total"] * 7000;
                maintenance_grant += type["sum_schools"]["classrooms_leq_3"] *
                                                                        5000;
                maintenance_grant += type["sum_schools"]["classrooms_eq_4"] *
                                                                        7500;
                maintenance_grant += type["sum_schools"]["classrooms_eq_5"] *
                                                                        10000;
                maintenance_grant += type["sum_schools"]["classrooms_mid_67"] *
                                                                        10000;
                maintenance_grant += type["sum_schools"]["classrooms_geq_8"] *
                                                                        10000;
                expectedGrant += devgrant + maintenance_grant;
            }
        }
        return expectedGrant;
    }
    
    /*
        Render Neighbours
    */
    function renderNeighbours(data) {
        var comparisonData = {};
        var total_schools = 0;
        for (var each in data) {
            var categoryData = common.getCategoryCount(data[each].properties);
            comparisonData[data[each]["id"]] = {
                "name": data[each].properties.popup_content,
                "type": data[each].properties.entity_type,
                "expected": getTotalExpectedGrant(data[each]["properties"]),
                "received": data[each].properties.sum_school_dev_grant_recd +
                                data[each].properties.sum_tlm_grant_recd,
                "expenditure": data[each].properties.sum_school_dev_grant_expnd +
                                data[each].properties.sum_tlm_grant_expnd,
                "total": categoryData["schoolcount"]
            };
            total_schools += categoryData["schoolcount"];
        }
        comparisonData[summaryData.boundary.dise] = {
                                "expected": grantData.expected.grand_total,
                                "received": grantData.received.grand_total,
                                "expenditure": grantData.expenditure.grand_total,
                                "total": summaryData.school_count
                                };
        if( repType == 'boundary' )
        {
            comparisonData[summaryData.boundary.dise]["name"] =
                summaryData.boundary.name;
            comparisonData[summaryData.boundary.dise]["type"] =
                summaryData.boundary.type;
        } else {
            comparisonData[summaryData.boundary.dise]["name"] =
                summaryData.boundary.name;
            comparisonData[summaryData.boundary.dise]["type"] = repType;
        }
        total_schools += summaryData.school_count;
        for( var iter in comparisonData){
            comparisonData[iter]["total_perc"] = Math.round(
                    comparisonData[iter]["total"]*100/total_schools*100)/100;
        }
        var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":comparisonData,
                                            "boundary_name":boundary_name,
                                            "boundary_type":boundary_type});
        $('#comparison-neighbour').html(compareHTML);
    }
})();
