'use strict';
(function() {
    var utils;
    var summaryData;
    var detailsData;
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
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
            getDetailsData(data);
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
        return summaryJSON;
    }

    function renderSummary(data) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplReportDate = swig.compile($('#tpl-reportDate').html());
        
        var now = new Date();
        var today = {'date' : moment(now).format("MMMM D, YYYY")};
        var dateHTML = tplReportDate({"today":today});
        $('#report-date').html(dateHTML);

        if( data["teacher_count"] == 0 )
            data['ptr'] = "NA";
        else
            data['ptr'] = Math.round(data["student_total"]/data["teacher_count"]*100)/100;
        data['girl_perc'] = Math.round(( data["gender"]["girls"]/data["student_total"] )* 100 *100)/100;
        data['boy_perc'] = 100-data['girl_perc'];
        
        var topSummaryHTML = tplTopSummary({"data":data});
        $('#top-summary').html(topSummaryHTML);
    }

    function getDetailsData(data)
    {
		var acadYear = data["academic_year"].replace(/20/g, '');
		var boundary = {"id": data["boundary_info"]["dise"], "type": data["boundary_info"]["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
            console.log('diseData', diseData);
            var summaryJSON= getSummaryData(data, diseData);
            renderSummary(summaryJSON);
            var categoriesData = getCategoriesData(diseData["properties"]);
			renderCategories(categoriesData);
			var languageData = getLanguageData(diseData["properties"]);
			renderLanguage(languageData);
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
        });
        
        getNeighbourData(data, acadYear);
        var yearData = [];
        yearData[acadYear] = data["academic_year"];
        var years = acadYear.split("-").map(Number);
        var startyear = years[0];
        var endyear = years[1];
        yearData[(startyear-1).toString()+"-"+(endyear-1).toString()] = "20"+(startyear-1).toString()+"-"+"20"+(endyear-1).toString();
        yearData[(startyear-2).toString()+"-"+(endyear-2).toString()] = "20"+(startyear-2).toString()+"-"+"20"+(endyear-2).toString();
        var passYearData = {"name": data["boundary_info"]["name"], "dise": data["boundary_info"]["dise"], "type": data["boundary_info"]["type"]};
        getMultipleData(yearData, passYearData, getLoopData, renderComparison,"acadYear");
    }

    function getCategoriesData(data)
    {
		var categories = {
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
				categories["lprimary"]["student_count"] = type["sum_girls"] + type["sum_boys"],
				categories["lprimary"]["school_count"] = type["sum_schools"]["total"]
				categories["lprimary"]["enrolled"] = Math.round(categories["lprimary"]["student_count"]/categories["lprimary"]["school_count"]*100)/100;
			}
			if(_.contains(upperPrimaryCategories,type["id"])){
				categories["uprimary"]["student_count"] += type["sum_girls"] + type["sum_boys"],
				categories["uprimary"]["school_count"] += type["sum_schools"]["total"]
			}
		}
		categories["uprimary"]["enrolled"] = Math.round(categories["uprimary"]["student_count"]/categories["uprimary"]["school_count"]*100)/100;
		return categories;
    }

    function getLanguageData(data)
    {
		var languages = {};
		for( var iter in data["medium_of_instructions"])
		{
			var type = data["medium_of_instructions"][iter];
			languages[type["name"]] = {"student_count": type["sum_boys"] + type["sum_girls"],
										"school_count": type["sum_schools"]};
		}
		return languages;
    }

    function getNeighbourData(data, acadYear)
    {
        var type = data["boundary_info"]["type"];
        if(type == "district")
        {
            klp.dise_api.getMultipleBoundaryData(null, null, type, acadYear).done(function(diseData) {
                console.log('neighbours diseData', diseData);
                renderNeighbours(diseData["results"]["features"], data["boundary_info"]["name"]);
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
            });
        }
        else
        {
            var boundary = {"type": data["boundary_info"]["parent"]["type"], "id": data["boundary_info"]["parent"]["dise"]};
            klp.dise_api.getMultipleBoundaryData(boundary.id, boundary.type, type, acadYear).done(function(diseData) {
                    console.log('neighbours diseData', diseData);
                    renderNeighbours(diseData["results"]["features"], data["boundary_info"]["name"]);
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch dise data", "error");
            });
        }
    }

    function getMultipleData(inputData, passedData, getData, exit,iteratorName)
    {
        var numberOfIterations = Object.keys(inputData).length;
        var outputData= {};
        var index = 0,
            done = false,
            shouldExit = false;
        var loop = {
            next:function(){
                if(done){
                    if(shouldExit && exit){
                        return exit(outputData); // Exit if we're done
                    }
                }
                if(index <  numberOfIterations){
                    index++; // Increment our index
                    getData(loop); // Run our process, pass in the loop
                }
                else {
                    done = true; // Make sure we say we're done
                    if(exit)
                        exit(outputData); // Call the callback on exit
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

    function getLoopData(loop)
    {
        var data = loop.iteration();
        var boundary = {"id": data["dise"], "type": data["type"]};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, data["acadYear"]).done(function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not dise data", "for "+data["dise"]);
        });
    }

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

    function renderLanguage(languages) {
        var new_lang = {};
        var lang_lookup = ["KANNADA","TAMIL","TELUGU","URDU"];
        var moi_school_total = 0;
        var mt_student_total = 0;
                
		for (var lang in languages) {
			moi_school_total += languages[lang]["school_count"];
        }

        new_lang["OTHERS"] = {"name":"OTHERS", "school_count": 0, "student_count":0, "moi_perc":0,"mt_perc":0};
        for (var each in languages) {
            if (!_.contains(lang_lookup,each.toUpperCase()))
            {
                new_lang["OTHERS"]["school_count"] += languages[each]["school_count"];
                delete languages[each];
            } else {
                new_lang[each]= {"name" : each};
                new_lang[each]["school_count"] = languages[each]["school_count"];
                new_lang[each]["moi_perc"] = Math.round(languages[each]["school_count"]*100/moi_school_total*100)/100;
            }
        }

        new_lang["OTHERS"]["moi_perc"] = Math.round(new_lang["OTHERS"]["school_count"]*100/moi_school_total*100)/100;
        var sorted_lang = _.sortBy(new_lang, 'school_count').reverse();        
        var tplLanguage = swig.compile($('#tpl-Language').html());
        var languageHTML = tplLanguage({"lang":sorted_lang});
        $('#language-profile').html(languageHTML);
        
    }


    function renderNeighbours(data,boundary_name){
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
		for(var neighbour in comparisonData)
		{
			comparisonData[neighbour]["school_perc"] = Math.round(comparisonData[neighbour]["school_count"]/total_school_count * 100)* 100/100;
		}
		console.log('comparisonData', comparisonData);
		var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":comparisonData,"boundary_name":boundary_name});
        $('#comparison-neighbour').html(compareHTML);
    }

    function renderComparison(data, boundary_name) {
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
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html());
        var yrcompareHTML = tplYearComparison({"years":comparisonData,"boundary_name":boundary_name});
        $('#comparison-year').html(yrcompareHTML);
    }

})();
