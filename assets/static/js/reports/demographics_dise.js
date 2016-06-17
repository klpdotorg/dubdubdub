'use strict';
(function() {
    var utils;
    var summaryData;
    var detailsData;
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
		var url = "reports/demographics/dise/"+repType+"/?language="+lang+"&id="+bid;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            var summaryJSON= getSummaryData(data);
            renderSummary(summaryJSON,"Schools");
            getDetailsData(data);
			//getComparisonData(data);
        });
    }

    function getSummaryData(data)
    {
        var summaryJSON = {
            "boundary"  : data["boundary_info"],
            "school_count" : data["summary_data"]["num_schools"],
            "teacher_count" : data["summary_data"]["teacher_count"],
            "gender" : data["summary_data"]["gender"],
            "student_total": data["summary_data"]["num_students"]
        };

        return summaryJSON;
    }

    function renderSummary(data, schoolType) {
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
		klp.dise_api.queryBoundaryName(data["boundary_info"]["name"], data["boundary_info"]["type"],acadYear).done(function(diseData) {
			if( diseData.length != 0 )
            {
                var boundary = diseData[0].children[0];
                klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(function(diseData) {
                    console.log('diseData', diseData);
                    var categoriesData = getCategoriesData(diseData["properties"]);
					renderCategories(categoriesData);
					var languageData = getLanguageData(diseData["properties"]);
					renderLanguage(languageData);
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
        
        var yearData = []; 
        yearData[acadYear] = data["academic_year"];
        var years = acadYear.split("-").map(Number);
        yearData[(years[0]-1).toString()+"-"+(years[1]-1).toString()] = "20"+(years[0]-1).toString()+"-"+"20"+(years[1]-1).toString();
        yearData[(years[0]-2).toString()+"-"+(years[1]-2).toString()] = "20"+(years[0]-2).toString()+"-"+"20"+(years[1]-2).toString();
        var passYearData = {"name": data["boundary_info"]["name"], "type": data["boundary_info"]["type"]};
        getMultipleData(yearData, passYearData, getLoopData, renderComparison,"acadYear");
  
    }


    function getCategoriesData(data)
    {
		var categories = {};
		for(var iter in data["school_categories"])
		{
			var type = data["school_categories"][iter];
			if(type["id"] == 1){
				categories["lprimary"] = {"name": "Lower Primary",
												"student_count": type["sum_girls"] + type["sum_boys"],
												"school_count": type["sum_schools"]
										};
				categories["lprimary"]["enrolled"] = Math.round(categories["lprimary"]["student_count"]/categories["lprimary"]["school_count"]*100)/100;
			}
			if(type["id"] == 2){
				categories["l_uprimary"] = {"name": "Lower and Upper Primary",
											"student_count": type["sum_girls"] + type["sum_boys"],
											"school_count": type["sum_schools"]};
				categories["l_uprimary"]["enrolled"] = Math.round(categories["l_uprimary"]["student_count"]/categories["l_uprimary"]["school_count"]*100)/100;
			}
			if(type["id"] == 4){
				categories["uprimary"] = {"name": "Upper Primary",
											"student_count": type["sum_girls"] + type["sum_boys"],
											"school_count": type["sum_schools"]};
				categories["uprimary"]["enrolled"] = Math.round(categories["uprimary"]["student_count"]/categories["uprimary"]["school_count"]*100)/100;
			}
		}
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

    function getComparisonData(bid, lang, repType)
    {
        var url = "reports/demographics/"+repType+"/comparison/?id="+bid+"&language="+lang;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            data["comparison"]["year-wise"][0] = {
                            "year": detailsData["report_info"]["year"],
                             "enrol_upper": detailsData["enrolment"]["Class 5-8"]["student_count"],
                             "enrol_lower": detailsData["enrolment"]["Class 1-4"]["student_count"],
                             "student_count": summaryData["student_count"],
                             "school_count": summaryData["school_count"],
                             "school_perc": summaryData["school_perc"],
                             "teacher_count": summaryData["teacher_count"],
                             "ptr": summaryData["ptr"]
            };
            renderComparison(data["comparison"]);
        });
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
                klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
            });
        }
        else
        {
            klp.dise_api.queryBoundaryName(data["boundary_info"]["parent"]["name"], data["boundary_info"]["parent"]["type"],acadYear).done(function(diseData) {
                var boundary = diseData[0].children[0];
                klp.dise_api.getMultipleBoundaryData(boundary.id, boundary.type, type, acadYear).done(function(diseData) {
                    console.log('neighbours diseData', diseData);
                    renderNeighbours(diseData["results"]["features"]);
                })
                .fail(function(err) {
                    klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
                });
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
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
        klp.dise_api.queryBoundaryName(data["name"], data["type"], data["acadYear"]).done(function(diseNameData) {
            if( diseNameData.length == 0)
            {
                loop.next();
                return;
            }
            var boundary = diseNameData[0].children[0];
            klp.dise_api.getBoundaryData(boundary.id, boundary.type, data["acadYear"]).done(function(diseData) {
                console.log('diseData', diseData);
                loop.addData(diseData);
                loop.next();
            })
            .fail(function(err) {
                klp.utils.alertMessage("Sorry, could not fetch programmes data", "for neighbour"+neighbour);
            });
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch name data", "error");
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
            categories[cat]['cat_perc'] = Math.round(categories[cat]["school_count"]/school_total*100*100)/100;
            categories[cat]['school_total'] = school_total;
        }
        var tplCategory = swig.compile($('#tpl-Category').html());
        var categoryHTML = tplCategory({"cat":categories});
        $('#category-profile').html(categoryHTML);
    }

    function renderLanguage(languages) {
        var new_lang = {};
        var lang_lookup = ["KANNADA","TAMIL","TELUGU","URDU","OTHERS"];
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
        var tplLanguage = swig.compile($('#tpl-Language').html());
        var languageHTML = tplLanguage({"lang":new_lang});
        $('#language-profile').html(languageHTML);
        
    }


    function renderNeighbours(data){
		var comparisonData = {};
		var total_school_count = 0;
		for( var itercount in data)
		{
			var iter = data[itercount];
			comparisonData[iter["id"]] = {
				"name": iter["id"],
				"student_count": iter["properties"]["sum_girls"] + iter["properties"]["sum_boys"],
				"school_perc": 0,
                "teacher_count": iter["properties"]["sum_female_tch"] + iter["properties"]["sum_male_tch"],
                "school_count": iter["properties"]["sum_schools"],
			};
			for(var cat in iter["properties"]["school_categories"]){
				var type = iter["properties"]["school_categories"][cat];
				if(type["id"] == 1)
					comparisonData[iter["id"]]["enrol_lower"] = Math.round((type["sum_boys"] + type["sum_girls"])/comparisonData[iter["id"]]["school_count"]*100)/100;
				else if(type["id"] == 2)
					comparisonData[iter["id"]]["enrol_l_u"] = Math.round((type["sum_boys"] + type["sum_girls"])/comparisonData[iter["id"]]["school_count"]*100)/100;
				else if(type["id"] == 4)
					comparisonData[iter["id"]]["enrol_upper"] = Math.round((type["sum_boys"] + type["sum_girls"])/comparisonData[iter["id"]]["school_count"]*100)/100;
			}
			total_school_count += iter["properties"]["sum_schools"];
			comparisonData[iter["id"]] ["ptr"] = Math.round(comparisonData[iter["id"]]["student_count"]/comparisonData[iter["id"]]["teacher_count"]*100)/100;
		}
		for(var neighbour in comparisonData)
		{
			comparisonData[neighbour]["school_perc"] = Math.round(comparisonData[neighbour]["school_count"]/total_school_count * 100)* 100/100;
		}
		console.log('comparisonData', comparisonData);
		var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":comparisonData});
        $('#comparison-neighbour').html(compareHTML);
    }

    function renderComparison(data) {
		var comparisonData = {};
		for( var itercount in data)
		{
			var iter = data[itercount];
			comparisonData[itercount] = {
				"year": "20"+itercount.toString().replace("-","-20"),
				"student_count": iter["properties"]["sum_girls"] + iter["properties"]["sum_boys"],
                "teacher_count": iter["properties"]["sum_female_tch"] + iter["properties"]["sum_male_tch"],
                "school_count": iter["properties"]["sum_schools"],
			};
			for(var cat in iter["properties"]["school_categories"]){
				var type = iter["properties"]["school_categories"][cat];
				if(type["id"] == 1)
					comparisonData[itercount]["enrol_lower"] = Math.round((type["sum_boys"] + type["sum_girls"])/comparisonData[itercount]["school_count"]*100)/100;
				else if(type["id"] == 2)
					comparisonData[itercount]["enrol_l_u"] = Math.round((type["sum_boys"] + type["sum_girls"])/comparisonData[itercount]["school_count"]*100)/100;
				else if(type["id"] == 4)
					comparisonData[itercount]["enrol_upper"] = Math.round((type["sum_boys"] + type["sum_girls"])/comparisonData[itercount]["school_count"]*100)/100;
			}
			comparisonData[itercount]["ptr"] = Math.round(comparisonData[itercount]["student_count"]/comparisonData[itercount]["teacher_count"]*100)/100;
		}
		
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html());
        var yrcompareHTML = tplYearComparison({"years":comparisonData});
        $('#comparison-year').html(yrcompareHTML);
    }

})();


