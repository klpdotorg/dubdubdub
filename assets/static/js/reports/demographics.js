'use strict';
var BOUNDARY_TYPE="parliament";
var KLP_ID="264";
var LANGUAGE="kannada";

(function() {
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        fetchReportDetails();
        klp.router.start();
    }

    function fetchReportDetails()
    {
        var params = klp.router.getHash().queryParams;
        var url = "reports/?report_type=demographics&boundary=" +BOUNDARY_TYPE+"&id="+KLP_ID+"&language="+LANGUAGE ;
        var $xhr = klp.api.do(url, params);
        $xhr.done(function(data) {
            var summaryJSON= getSummaryData(data.features[0]);
            renderSummary(summaryJSON,"Schools");
            var detailsJSON= getDetailsData(data);
            renderCategories(detailsJSON);
            renderLanguage(detailsJSON);
            var comparisonJSON=getComparisonData(data);
            renderComparison(comparisonJSON);
        });

    }

    function getSummaryData(data)
    {
        var summaryJSON = {
            "boundary"  : data["boundary_info"],
            "school_count" : data["schoolcount"], 
            "teacher_count" : data["teacher_count"],
            "gender" : data["gender"]
        }

        return summaryJSON;
    }

    function getDetailsData(data)
    { 
        var detailsJson = {
                "categories" : [
                    {"categories": "Upper Primary", "num_schools" : 168, "num_students" : 25000}
                    {"categories": "Lower Primary", "num_schools" : 146, "num_studnets" : 22145}
                ],
                //"categories" : {
                  //  "Upper Primary": {"school_count" : 168, "student_count" : 25000},
                    //"Lower Primary": {"school_count" : 146, "student_count" : 22145}
                //},
                "enrolment" : {
                    "Class 1-4": {"text":"Class 1 to 4","student_count":30000},
                    "Class 5-8": {"text":"Class 5 to 8","student_count":17145}
                },
                "languages" : {
                    "moi" : { 
                        "KANNADA" : {"school_count":180},
                        "TAMIL"   : {"school_count":50},
                        "URDU"    : {"school_count":70},
                        "TELUGU"  : {"school_count":12},
                        "MARATHI" : {"school_count":2},
                        "ENGLISH" : {"school_count":2}
                    },
                    "mt" : {
                        "KANNADA" : {"student_count":30000},
                        "TAMIL"   : {"student_count":5000},
                        "URDU"    : {"student_count":8000},
                        "TELUGU"  : {"student_count":3000},
                        "MARATHI" : {"student_count":200},
                        "NEPALI" : {"student_count":4},
                        "BENGALI" : {"student_count":2}
                    }
                },

            };
     
        return detailsJson;
    }

    function getComparisonData(data)
    {
        var comparisonJson = {
            "year-wise": {
                "2013":{"year":"2013","enrol_upper":120,"enrol_lower":75,"ptr":25,"school_count":200,"school_perc":40},
                "2014":{"year":"2014","enrol_upper":140,"enrol_lower":65,"ptr":24,"school_count":240,"school_perc":50},
                "2015":{"year":"2015","enrol_upper":145,"enrol_lower":85,"ptr":20,"school_count":314,"school_perc":40}
            }, /* maybe entrolment can be calculated with student and school count 
                    Percentage could be percentage of schools in district */
            "neighbours" : {
                "Bangalore Central":{"name":"Bangalore Central","enrol_upper":120,"enrol_lower":75,"ptr":25,"school_count":200,"school_perc":40},
                "Bangalore North":{"name":"Bangalore North","enrol_upper":140,"enrol_lower":65,"ptr":24,"school_count":240,"school_perc":50},
                "Bangalore South":{"name":"Bangalore South","enrol_upper":120,"enrol_lower":75,"ptr":25,"school_count":200,"school_perc":40},
                "Bangalore Rural":{"name":"Bangalore Rural","enrol_upper":140,"enrol_lower":65,"ptr":24,"school_count":240,"school_perc":50},
                "Chikkabalapur":{"name":"Chikkabalapur","enrol_upper":145,"enrol_lower":85,"ptr":20,"school_count":314,"school_perc":40}
            }
        }
        return comparisonJson;
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

    function renderCategories(data) {
        var categories = data ["categories"];
        var school_total = 0;
        for (var cat in categories) {
            categories[cat]["name"] = cat;
            categories[cat]['enrolled'] = Math.round(categories[cat]["student_count"]/categories[cat]["school_count"]);
            school_total += categories[cat]["school_count"];
        }
        console.log("school_total:"+school_total)
        for(cat in categories) {
            console.log(cat);
            console.log(categories[cat]["school_count"]/school_total);   
            categories[cat]['cat_perc'] = Math.round(categories[cat]["school_count"]/school_total*100);
            categories[cat]['school_total'] = school_total; 
        }
        var tplCategory = swig.compile($('#tpl-Category').html()); 
        var categoryHTML = tplCategory({"cat":categories,"enrol":data["enrolment"]});
        $('#category-profile').html(categoryHTML);   
    }

    function renderLanguage(data) {
        var languages = data["languages"];
        var new_lang = {};
        var lang_lookup = ["KANNADA","TAMIL","TELUGU","URDU","OTHERS"];
        var moi_school_total = 0;
        var mt_student_total = 0;
        
        for (var each in languages) {
            for (var lang in languages[each]) {
                if (each == "moi") {
                    moi_school_total += languages[each][lang]["school_count"];   
                } else {
                    mt_student_total += languages[each][lang]["student_count"];
                }    
            }
        }

        new_lang["OTHERS"] = {"name":"OTHERS", "school_count": 0, "student_count":0, "moi_perc":0,"mt_perc":0};
        for (var each in languages["moi"]) {
            if (!_.contains(lang_lookup,each)) 
            {
                new_lang["OTHERS"]["school_count"] += languages["moi"][each]["school_count"];
                delete languages["moi"][each];
            } else {
                new_lang[each]= {"name" : each};
                new_lang[each]["school_count"] = languages["moi"][each]["school_count"];
                new_lang[each]["moi_perc"] = Math.round(languages["moi"][each]["school_count"]*100/moi_school_total);
            } 
        }
        
        for (var each in languages["mt"]) {
            if (!_.contains(lang_lookup,each)) 
            {
                new_lang["OTHERS"]["student_count"] += languages["mt"][each]["student_count"];
                delete languages["mt"][each];
            } else {

                new_lang[each]["student_count"] = languages["mt"][each]["student_count"];
                new_lang[each]["mt_perc"] = Math.round(languages["mt"][each]["student_count"]*100/mt_student_total);
            }
        }

        new_lang["OTHERS"]["moi_perc"] = Math.round(new_lang["OTHERS"]["school_count"]*100/moi_school_total);
        new_lang["OTHERS"]["mt_perc"] = Math.round(new_lang["OTHERS"]["student_count"]*100/mt_student_total);
        /* All of the above is json dependent logic
        We convert distinct moi, mt hash maps to a single hashmap of the type
        newlang = { "KANNADA" :
                    {"name": "KANNADA",
                     "school_count": 12,
                     "student_count":3600,
                     "moi_perc": 10%
                     "mt_perc": 12%
                    }, ...
                }*/
        var tplLanguage = swig.compile($('#tpl-Language').html()); 
        var languageHTML = tplLanguage({"lang":new_lang});
        $('#language-profile').html(languageHTML);
        
    }

    function renderComparison(data) {
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html()); 
        var yrcompareHTML = tplYearComparison({"years":data["year-wise"]});
        $('#comparison-year').html(yrcompareHTML);
        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":data["neighbours"]});
        $('#comparison-neighbour').html(compareHTML);
    
    }

})();

