'use strict';
(function() {
    var utils;
    var common;
    var klpData;
    var summaryData;
    var categoriesData;
    var boundary_name;
    var boundary_type;
    var acadYear;
    var repType;
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        utils  = klp.reportUtils;
        common = klp.reportCommon;
        fetchReportDetails();
        klp.router.start();
    };

    /*
    Fetch basic details from backend
    */
    function fetchReportDetails()
    {
        var id,lang;
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
                acadYear = data["academic_year"].replace(/20/g, '');
                repType = common.getElectedRepType(data.report_info.type);
                getElectedRepData();
            });
        }
    }

    /*
        Get Elected rep data from DISE application and render the Summary, 
        Categories, Language and Comparison data.
    */
    function getElectedRepData()
    {
        var electedrep = {"id": klpData["report_info"]["dise"],
                          "type": repType}
        klp.dise_api.getElectedRepData(electedrep.id, electedrep.type,
                                       acadYear).done(function(diseData) {
            var categoryCount = common.getCategoryCount(diseData.properties);
            summaryData = common.getSummaryData(diseData, 
                                                klpData["report_info"],
                                                categoryCount, 
                                                repType, 
                                                acadYear);
            boundary_name = klpData["report_info"]["name"];
            boundary_type = klpData["report_info"]["type"];
            common.renderSummary(summaryData);
            getCategoriesData(diseData["properties"]);
            renderCategories(categoriesData);
            var languageData = getLanguageData(diseData["properties"]);
            renderLanguage(languageData);
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
        Get detail data from DISE application and render the summary, categories, 
        languages and comparison (year and neighbours) data.
    */
    function getDiseData()
    {
        var boundary = {"id": klpData["report_info"]["dise"],
                        "type": klpData["report_info"]["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type,
                                     acadYear).done(function(diseData) {
            boundary_name = klpData["report_info"]["name"];
            boundary_type = klpData["report_info"]["type"];
            
            var categoryCount = common.getCategoryCount(diseData.properties);
            summaryData = common.getSummaryData(diseData,
                                                klpData["report_info"],
                                                categoryCount,
                                                repType,
                                                acadYear);
            common.renderSummary(summaryData);
            getCategoriesData(diseData["properties"]);
            renderCategories(categoriesData);
            var languageData = getLanguageData(diseData["properties"]);
            renderLanguage(languageData);
            //Get Comparison Data
            common.getNeighbourData(klpData, renderNeighbours);
            common.getYearData(klpData, renderYearComparison);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }


    /*
        Fills the categoriesData strucuture for rendering Categories

    */
    function getCategoriesData(data)
    {
		categoriesData = {
            "lprimary": {
                "name": "Lower Primary",
                "text": "Class 1 to 4",
                "student_count": 0,
                "school_count": 0
            },
            "uprimary": {
                "name": "Upper Primary",
                "text": "Class 1 to 8",
                "student_count": 0,
                "school_count": 0
            }
        };
		for(var iter in data["school_categories"])
		{
			var type = data["school_categories"][iter];
			if(type["id"] == 1){
				categoriesData["lprimary"]["student_count"] =
                                        type["sum_girls"] + type["sum_boys"];
				categoriesData["lprimary"]["school_count"] =
                                                type["sum_schools"]["total"];
				categoriesData["lprimary"]["enrolled"] = Math.round(
                    categoriesData["lprimary"]["student_count"]/
                    categoriesData["lprimary"]["school_count"]*100)/100;
			}
			if(_.contains(upperPrimaryCategories,type["id"])){
				categoriesData["uprimary"]["student_count"] +=
                                        type["sum_girls"] + type["sum_boys"];
				categoriesData["uprimary"]["school_count"] +=
                                                type["sum_schools"]["total"];
			}
		}
        categoriesData["uprimary"]["enrolled"] = Math.round(
                            categoriesData["uprimary"]["student_count"]/
                            categoriesData["uprimary"]["school_count"]*100)/100;
    }

    /*
        Render the Categories 
    */
    function renderCategories(categories) {
        var school_total = 0;
        for (var cat in categories) {
            
            school_total += categories[cat]["school_count"];
        }
        for(cat in categories) {
            categories[cat]['cat_perc'] = Math.round(
                            categories[cat]["school_count"]/school_total*100);
            categories[cat]['school_total'] = school_total;
        }
        var tplCategory = swig.compile($('#tpl-Category').html());
        var categoryHTML = tplCategory({"cat":categories,"enrol":categories});
        $('#category-profile').html(categoryHTML);
    }

    /*
        Get medium of instruction data filled
    */
    function getLanguageData(data)
    {
        var lang_lookup = ["KANNADA","TAMIL","TELUGU","URDU","ENGLISH"];
		var languages = {};
        languages["OTHERS"] = {"name":"OTHERS", "school_count": 0,
                               "student_count":0, "moi_perc":0,"mt_perc":0};
        var school_total = 0;
		for( var iter in data["medium_of_instructions"])
		{
			var type = data["medium_of_instructions"][iter];
            if (!_.contains(lang_lookup,type["name"].toUpperCase()))
            {
                languages["OTHERS"]["school_count"] += type["sum_schools"];
                languages["OTHERS"]["student_count"] += type["sum_boys"] +
                                                            type["sum_girls"];
            } else {
                languages[type["name"]]= {"name" : type["name"]};
                languages[type["name"]]["school_count"] = type["sum_schools"];
                languages[type["name"]]["student_count"] = type["sum_boys"] +
                                                            type["sum_girls"];
            }
            school_total += type["sum_schools"];
		}

        for (var lang in languages)
        {
            languages[lang]["moi_perc"] = Math.round(
                    languages[lang]["school_count"]*100/school_total*100)/100;
        }
        
		return languages;
    }

    /*
        Render Languages
    */
    function renderLanguage(languages) {
        var sorted_lang = _.sortBy(languages, 'school_count').reverse();
        var tplLanguage = swig.compile($('#tpl-Language').html());
        var languageHTML = tplLanguage({"lang":sorted_lang});
        $('#language-profile').html(languageHTML);
        
    }

    /*
     * Renders Neighbours
     */
    function renderNeighbours(data){
        var comparisonData = {};
		var total_school_count = 0;
		for( var itercount in data)
		{
			var iter = data[itercount];
            var categoryData = common.getCategoryCount(iter["properties"]);
			comparisonData[iter["id"]] = {
                "name": iter["properties"]["popup_content"],
                "type": iter["properties"]["entity_type"],
				"student_count": categoryData["gendercount"]["boys"] +
                                        categoryData["gendercount"]["girls"],
				"school_perc": 0,
                "teacher_count": iter["properties"]["sum_female_tch"] +
                                        iter["properties"]["sum_male_tch"],
                "school_count": categoryData["schoolcount"]
			};

            comparisonData[iter["id"]]["enrol_lower"] = 0;
            comparisonData[iter["id"]]["enrol_upper"] = 0;
            var upperschoolcount = 0;
            var upperstudentcount = 0;
			for(var cat in iter["properties"]["school_categories"]){
				var type = iter["properties"]["school_categories"][cat];
				if(type["id"] == 1){
					comparisonData[iter["id"]]["enrol_lower"] = Math.round(
                                (type["sum_boys"] + type["sum_girls"])/
                                    type["sum_schools"]["total"]*100)/100;
                    total_school_count += type["sum_schools"]["total"];
                }
				else if(_.contains(upperPrimaryCategories,type["id"])){
                    upperstudentcount += type["sum_boys"] + type["sum_girls"];
                    upperschoolcount += type["sum_schools"]["total"];
                    total_school_count += type["sum_schools"]["total"];
                }
			}
            comparisonData[iter["id"]]["enrol_upper"] = Math.round(
                                    upperstudentcount/upperschoolcount*100)/100;
            comparisonData[iter["id"]] ["ptr"] = Math.round(
                        comparisonData[iter["id"]]["student_count"]/
                        comparisonData[iter["id"]]["teacher_count"]*100)/100;
		}
        comparisonData[summaryData.boundary.dise] = {
				"student_count": summaryData.student_total,
				"school_perc": 0,
                "teacher_count": summaryData.teacher_count,
                "school_count": summaryData.school_count,
                "enrol_lower": categoriesData["lprimary"]["enrolled"],
                "enrol_upper": categoriesData["uprimary"]["enrolled"],
                "ptr": summaryData["ptr"]
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
        total_school_count += summaryData.school_count;
		for(var neighbour in comparisonData)
		{
			comparisonData[neighbour]["school_perc"] = Math.round(
                            comparisonData[neighbour]["school_count"]/
                                total_school_count * 100)* 100/100;
		}
		var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":comparisonData,
                                         "boundary_name":boundary_name,
                                         "boundary_type":boundary_type});
        $('#comparison-neighbour').html(compareHTML);
    }

    /*
     * Renders Year Comparison
     */
    function renderYearComparison(data) {
		var comparisonData = {};
		for( var itercount in data)
		{
			var iter = data[itercount];
            var categoryData = common.getCategoryCount(iter["properties"]);
			comparisonData[itercount] = {
				"year": "20"+itercount.toString().replace("-","-20"),
				"student_count": categoryData["gendercount"]["boys"] +
                                        categoryData["gendercount"]["girls"],
                "teacher_count": iter["properties"]["sum_female_tch"] +
                                        iter["properties"]["sum_male_tch"],
                "school_count": categoryData["schoolcount"]
			};
			comparisonData[itercount]["enrol_lower"] = 0;
			comparisonData[itercount]["enrol_upper"] = 0;
            var upperschoolcount = 0;
            var upperstudentcount = 0;
			for(var cat in iter["properties"]["school_categories"]){
				var type = iter["properties"]["school_categories"][cat];
				if(type["id"] == 1)
					comparisonData[itercount]["enrol_lower"] = Math.round(
                            (type["sum_boys"] + type["sum_girls"])/
                        type["sum_schools"]["total"]*100)/100;
				else if(_.contains(upperPrimaryCategories,type["id"])){
                    upperstudentcount += type["sum_boys"] + type["sum_girls"];
                    upperschoolcount += type["sum_schools"]["total"];
                }
			}
            comparisonData[itercount]["enrol_upper"] = Math.round(
                upperstudentcount/upperschoolcount*100)/100;
			comparisonData[itercount]["ptr"] = Math.round(
                comparisonData[itercount]["student_count"]/
                    comparisonData[itercount]["teacher_count"]*100)/100;
		}
        comparisonData[acadYear]={
            "year": klpData["academic_year"],
            "student_count": summaryData["student_total"],
            "teacher_count": summaryData.teacher_count,
            "school_count": summaryData.school_count,
            "enrol_lower": categoriesData["lprimary"]["enrolled"],
            "enrol_upper": categoriesData["uprimary"]["enrolled"],
            "ptr": summaryData["ptr"]
        };
        
        var sorted_year = _.sortBy(comparisonData,"year").reverse();
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html());
        var yrcompareHTML = tplYearComparison({"years":sorted_year,
                                               "boundary_name":boundary_name});
        $('#comparison-year').html(yrcompareHTML);
    }

})();
