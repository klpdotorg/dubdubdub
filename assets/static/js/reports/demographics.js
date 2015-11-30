'use strict';
(function() {
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
        var summaryJSON = {
            "boundary"  : {
                "name"  : "Bangalore Central",
                "type"  : "MP Constituency",
                "id"    : 1234,
                "code"  : 25,
                "elected_rep" : "PC Mohan",
                "elected_party" : "INC"
            },
            "school_count" : 314,
            "teacher_count" : 2000,
            "gender" : {
                "boys": 23118,
                "girls": 24027
            }
        }
        renderSummary(summaryJSON,"Schools");
        loadData(null, null);
    }
    function loadData(schoolType, params) {

        /*var dataURL = "reports/demographics/xxx";
        var $dataXHR = klp.api.do(detailURL, params);
        $datadetailXHR.done(function(data) {*/
            var detailsJson = {
                "categories" : {
                    "Upper Primary": {"school_count" : 168, "student_count" : 25000},
                    "Lower Primary": {"school_count" : 146, "student_count" : 22145}
                },
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
            renderCategories(detailsJson);
            renderLanguage(detailsJson);
            //var comparisonJson = {}
            //renderYearComparison(data["year-wise"])
        //});
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
        languages["moi"]["OTHERS"] = {"school_count": 0};
        for (var lang in languages["moi"]) {
            languages["moi"][lang]["name"] = lang;
            languages["moi"][lang]["perc"] = Math.round(languages["moi"][lang]["school_count"]*100/moi_school_total);
            if (!_.contains(lang_lookup,lang)) 
            {
                languages["moi"]["OTHERS"]["school_count"] += languages["moi"][lang]["school_count"];
                delete languages["moi"][lang];
            }    
        }
        languages["moi"]["OTHERS"]["perc"] = Math.round(languages["moi"]["OTHERS"]["school_count"]*100/moi_school_total);
        
        languages["mt"]["OTHERS"] = {"student_count": 0};
        for (var lang in languages["mt"]) {
            languages["mt"][lang]["name"] = lang;
            languages["mt"][lang]["perc"] = Math.round(languages["mt"][lang]["student_count"]*100/mt_student_total);
            if (!_.contains(lang_lookup,lang)) 
            {
                languages["mt"]["OTHERS"]["student_count"] += languages["mt"][lang]["student_count"];
                delete languages["mt"][lang];
            }
            
        }
        languages["mt"]["OTHERS"]["perc"] = Math.round(languages["mt"]["OTHERS"]["student_count"]*100/mt_student_total);
            
        var tplLanguage = swig.compile($('#tpl-Language').html()); 
        var languageHTML = tplLanguage({"lang":languages});
        $('#language-profile').html(languageHTML);
        
    }

})();

