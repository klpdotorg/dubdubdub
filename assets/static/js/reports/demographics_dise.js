'use strict';
(function() {
    var utils;
    var klpData;
    var summaryData;
    var categoriesData;
    var boundary_name;
    var acadYear;
    var repType;
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        utils  = klp.reportUtils;
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
                getElectedRepData();
            });
        }
    }

    /*
        Get Elected rep data from DISE application and render the Summary, Categories, Language and Comparison data.
    */
    function getElectedRepData()
    {
        var electedrep = {"id": klpData["electedrep_info"]["dise"], "type": repType}
        klp.dise_api.getElectedRepData(electedrep.id, electedrep.type, acadYear).done(function(diseData) {
            console.log('diseData', diseData);
            getSummaryData(diseData, klpData["electedrep_info"]);
            renderSummary(summaryData);
            getCategoriesData(diseData["properties"]);
            renderCategories(categoriesData);
            var languageData = getLanguageData(diseData["properties"]);
            renderLanguage(languageData);
            //Get Comparison Data
            getNeighbourData();
            getYearData();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }
 
    /*
        Get detail data from DISE application and render the summary, categories, languages and comparison (year and neighbours) data.
    */
    function getDiseData()
    {
        var boundary = {"id": klpData["boundary_info"]["dise"], "type": klpData["boundary_info"]["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
            console.log('diseData', diseData);
            boundary_name = klpData["boundary_info"]["name"];
            getSummaryData(diseData, klpData["boundary_info"]);
            renderSummary(summaryData);
            getCategoriesData(diseData["properties"]);
            renderCategories(categoriesData);
            var languageData = getLanguageData(diseData["properties"]);
            renderLanguage(languageData);
            //Get Comparison Data
            getNeighbourData();
            getYearData();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
    }

    /*
        Fill the summaryData structure.
    */
    function getSummaryData(diseData, baseData)
    {
        var categoryData = getCategoryCount(diseData["properties"]);
        summaryData = {
            "boundary"  : baseData,
            "school_count" : categoryData["schoolcount"],
            "teacher_count" : diseData["properties"]["sum_male_tch"] + diseData["properties"]["sum_female_tch"],
            "gender" : categoryData["gendercount"],
            "student_total": categoryData["gendercount"]["boys"] + categoryData["gendercount"]["girls"]
        };
        if( summaryData["teacher_count"] == 0 )
            summaryData['ptr'] = "NA";
        else
            summaryData['ptr'] = Math.round(summaryData["student_total"]/summaryData["teacher_count"]*100)/100;
        summaryData['girl_perc'] = Math.round(( summaryData["gender"]["girls"]/summaryData["student_total"] )* 100 *100)/100;
        summaryData['boy_perc'] = 100-summaryData['girl_perc'];
    }
 
    /*
        Renders Summary Data
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
        Fills the categoriesData strucuture for rendering Categories

    */
    function getCategoriesData(data)
    {
		categoriesData = {
            "lprimary": {
                "name": "Lower Primary",
                "student_count": 0,
                "school_count": 0
            },
            "uprimary": {
                "name": "Upper Primary",
                "student_count": 0,
                "school_count": 0
            }
        };
		for(var iter in data["school_categories"])
		{
			var type = data["school_categories"][iter];
			if(type["id"] == 1){
				categoriesData["lprimary"]["student_count"] = type["sum_girls"] + type["sum_boys"],
				categoriesData["lprimary"]["school_count"] = type["sum_schools"]["total"]
				categoriesData["lprimary"]["enrolled"] = Math.round(categoriesData["lprimary"]["student_count"]/categoriesData["lprimary"]["school_count"]*100)/100;
			}
			if(_.contains(upperPrimaryCategories,type["id"])){
				categoriesData["uprimary"]["student_count"] += type["sum_girls"] + type["sum_boys"],
				categoriesData["uprimary"]["school_count"] += type["sum_schools"]["total"]
			}
		}
        categoriesData["uprimary"]["enrolled"] = Math.round(categoriesData["uprimary"]["student_count"]/categoriesData["uprimary"]["school_count"]*100)/100;
    }

    /*
        Render the Categories 
    */
    function renderCategories(categories) {
        var school_total = 0;
        for (var cat in categories) {
            
            school_total += categories[cat]["school_count"];
        }
        console.log("school_total:"+school_total);
        for(cat in categories) {
            console.log(cat);
            console.log(categories[cat]["school_count"]/school_total);
            categories[cat]['cat_perc'] = Math.round(categories[cat]["school_count"]/school_total*100);
            categories[cat]['school_total'] = school_total;
        }
        var tplCategory = swig.compile($('#tpl-Category').html());
        var categoryHTML = tplCategory({"cat":categories});
        $('#category-profile').html(categoryHTML);
    }

    /*
        Get medium of instruction data filled
    */
    function getLanguageData(data)
    {
        var lang_lookup = ["KANNADA","TAMIL","TELUGU","URDU","ENGLISH"];
		var languages = {};
        languages["OTHERS"] = {"name":"OTHERS", "school_count": 0, "student_count":0, "moi_perc":0,"mt_perc":0};
        var school_total = 0;
		for( var iter in data["medium_of_instructions"])
		{
			var type = data["medium_of_instructions"][iter];
            if (!_.contains(lang_lookup,type["name"].toUpperCase()))
            {
                languages["OTHERS"]["school_count"] += type["sum_schools"];
                languages["OTHERS"]["student_count"] += type["sum_boys"] + type["sum_girls"];
            } else {
                languages[type["name"]]= {"name" : type["name"]};
                languages[type["name"]]["school_count"] = type["sum_schools"];
                languages[type["name"]]["student_count"] = type["sum_boys"] + type["sum_girls"];
            }
            school_total += type["sum_schools"];
		}

        for (var lang in languages)
        {
            languages[lang]["moi_perc"] = Math.round(languages[lang]["school_count"]*100/school_total*100)/100;
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
        Get Neighbour Data by calling dise api multiple times by passing different boundary
    */
    function getNeighbourData()
    {
        var loopData;
        var passBoundaryData = {"acadYear": acadYear};
        if( repType == "boundary" )
        {
            var type = klpData["boundary_info"]["type"];
            if(type == "district")
                loopData = klpData["neighbours"];
            else
                loopData = klpData["boundary_info"]["parent"];
        }
        else
        {
            loopData = klpData["neighbour_info"];
        }
        getMultipleData(loopData, passBoundaryData, getMultipleNeighbour, renderNeighbours)
    }

    /*
        Get year data by passing different year to the DISE api.
    */
    function getYearData()
    {
        var passYearData;
        var yearData = [];
        var years = acadYear.split("-").map(Number);
        var startyear = years[0];
        var endyear = years[1];
        yearData[(startyear-1).toString()+"-"+(endyear-1).toString()] = "20"+(startyear-1).toString()+"-"+"20"+(endyear-1).toString();
        yearData[(startyear-2).toString()+"-"+(endyear-2).toString()] = "20"+(startyear-2).toString()+"-"+"20"+(endyear-2).toString();
        if( repType == "boundary" )
        {
            passYearData = {"name": klpData["boundary_info"]["name"], "dise": klpData["boundary_info"]["dise"], "type": klpData["boundary_info"]["type"]};
        }
        else
        {
            passYearData = {"name": klpData["electedrep_info"]["name"], "dise": klpData["electedrep_info"]["dise"], "type": klpData["electedrep_info"]["type"]};
        }
        getMultipleData(yearData, passYearData, getMultipleYear, renderYearComparison,"acadYear");
    }

    /*
     * This function is used to call multiple apis before processing a function (exitFunction).
     * The inputData is used for looping through and has the data that needs to be passed.
     * The passData is used for passing the data to the function (getData) which is used for making 
     * the relevant api calls.
     * Once the loop is over the exitFunction is called.
     */
    function getMultipleData(inputData, passData, getData, exitFunction, iteratorName="iter")
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
                passData[iteratorName] = Object.keys(inputData)[index-1];
                passData["value"] = inputData[passData[iteratorName]];
                return passData; // Return the loop number we're on
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
        Fill the data structure and pass to the DISE api call
    */
    function getMultipleNeighbour(loop)
    {
        var data = loop.iteration();
        var type;
        if( repType == "boundary" ) //for district/block/cluster
            type = data["value"]["type"];
        else //for electedrep
            type = repType;
        var boundary = {"id": data["value"]["dise"], "type": type};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not dise data", "for "+data["dise"]);
        });
    }

    /*
        Fill the data structure and pass to DISE api call
    */
    function getMultipleYear(loop)
    {
        var data = loop.iteration();
        var type;
        if( repType == "boundary" ) //for district/block/cluster
            type = data["value"]["type"];
        else //for electedrep
            type = repType;
        var boundary = {"id": data["dise"], "type": type};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, data["acadYear"]).done(function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not dise data", "for "+data["dise"]);
        });
    }

    function renderNeighbours(data){
		var comparisonData = {};
		var total_school_count = 0;
		for( var itercount in data)
		{
			var iter = data[itercount];
            var categoryData = getCategoryCount(iter["properties"]);
			comparisonData[iter["id"]] = {
				"name": iter["properties"]["popup_content"],
				"student_count": categoryData["gendercount"]["boys"] + categoryData["gendercount"]["girls"],
				"school_perc": 0,
                "teacher_count": iter["properties"]["sum_female_tch"] + iter["properties"]["sum_male_tch"],
                "school_count": categoryData["schoolcount"]
			};

            comparisonData[iter["id"]]["enrol_lower"] = 0;
            comparisonData[iter["id"]]["enrol_upper"] = 0;
            var upperschoolcount = 0;
            var upperstudentcount = 0;
			for(var cat in iter["properties"]["school_categories"]){
				var type = iter["properties"]["school_categories"][cat];
				if(type["id"] == 1){
					comparisonData[iter["id"]]["enrol_lower"] = Math.round((type["sum_boys"] + type["sum_girls"])/type["sum_schools"]["total"]*100)/100;
                    total_school_count += type["sum_schools"]["total"];
                }
				else if(_.contains(upperPrimaryCategories,type["id"])){
                    upperstudentcount += type["sum_boys"] + type["sum_girls"];
                    upperschoolcount += type["sum_schools"]["total"];
                    total_school_count += type["sum_schools"]["total"];
                }
			}
            comparisonData[iter["id"]]["enrol_upper"] = Math.round(upperstudentcount/upperschoolcount*100)/100;
            comparisonData[iter["id"]] ["ptr"] = Math.round(comparisonData[iter["id"]]["student_count"]/comparisonData[iter["id"]]["teacher_count"]*100)/100;
		}
        comparisonData[summaryData.boundary.dise] = {"name": summaryData.boundary.name,
				"student_count": summaryData.student_total,
				"school_perc": 0,
                "teacher_count": summaryData.teacher_count,
                "school_count": summaryData.school_count,
                "enrol_lower": categoriesData["lprimary"]["enrolled"],
                "enrol_upper": categoriesData["uprimary"]["enrolled"],
                "ptr": summaryData["ptr"]
		};
        total_school_count += summaryData.school_count;
		for(var neighbour in comparisonData)
		{
			comparisonData[neighbour]["school_perc"] = Math.round(comparisonData[neighbour]["school_count"]/total_school_count * 100)* 100/100;
		}
		console.log('comparisonData', comparisonData);
		var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":comparisonData,"boundary_name":boundary_name});
        $('#comparison-neighbour').html(compareHTML);
    }

    function renderYearComparison(data) {
		var comparisonData = {};
		for( var itercount in data)
		{
			var iter = data[itercount];
            var categoryData = getCategoryCount(iter["properties"]);
			comparisonData[itercount] = {
				"year": "20"+itercount.toString().replace("-","-20"),
				"student_count": categoryData["gendercount"]["boys"] + categoryData["gendercount"]["girls"],
                "teacher_count": iter["properties"]["sum_female_tch"] + iter["properties"]["sum_male_tch"],
                "school_count": categoryData["schoolcount"]
			};
			comparisonData[itercount]["enrol_lower"] = 0;
			comparisonData[itercount]["enrol_upper"] = 0;
            var upperschoolcount = 0;
            var upperstudentcount = 0;
			for(var cat in iter["properties"]["school_categories"]){
				var type = iter["properties"]["school_categories"][cat];
				if(type["id"] == 1)
					comparisonData[itercount]["enrol_lower"] = Math.round((type["sum_boys"] + type["sum_girls"])/type["sum_schools"]["total"]*100)/100;
				else if(_.contains(upperPrimaryCategories,type["id"])){
                    upperstudentcount += type["sum_boys"] + type["sum_girls"];
                    upperschoolcount += type["sum_schools"]["total"];
                }
			}
            comparisonData[itercount]["enrol_upper"] = Math.round(upperstudentcount/upperschoolcount*100)/100;
			comparisonData[itercount]["ptr"] = Math.round(comparisonData[itercount]["student_count"]/comparisonData[itercount]["teacher_count"]*100)/100;
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
        var yrcompareHTML = tplYearComparison({"years":sorted_year,"boundary_name":boundary_name});
        $('#comparison-year').html(yrcompareHTML);
    }

})();
