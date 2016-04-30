'use strict';
(function() {
    var utils;
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

        var url = "reports/?report_name=demographics&report_type=" +repType+"&id="+bid+"&language="+lang ;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            var summaryJSON= getSummaryData(data);
            renderSummary(summaryJSON,"Schools");
            var detailsJSON= getDetailsData(data);
            renderCategories(detailsJSON);
            renderLanguage(detailsJSON);
            var comparisonJSON = data["comparison"];
            renderComparison(comparisonJSON);
        });

    }

    function getSummaryData(data)
    {
        var summaryJSON = {
            "boundary"  : data["boundary_info"],
            "school_count" : data["school_count"],
            "teacher_count" : data["teacher_count"],
            "gender" : data["gender"]
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

        data['student_total'] = data["gender"]["boys"] + data["gender"]["girls"];
        if( data["teacher_count"] == 0 )
            data['ptr'] = "NA";
        else
            data['ptr'] = Math.round(data["student_total"]/data["teacher_count"]);
        data['girl_perc'] = Math.round(( data["gender"]["girls"]/data["student_total"] )* 100);
        data['boy_perc'] = 100-data['girl_perc'];
        
        var topSummaryHTML = tplTopSummary({"data":data});
        $('#top-summary').html(topSummaryHTML);
    }

    function getDetailsData(data)
    {
        var detailsJson = {
                "categories" : data["categories"],
                "enrolment" : data["enrolment"],
                "languages" : data["languages"],
            };
        return detailsJson;
    }


    function renderCategories(data) {
        var categories = data ["categories"];
        var school_total = 0;
        for (var cat in categories) {
            categories[cat]["name"] = cat;
            categories[cat]['enrolled'] = Math.round(categories[cat]["student_count"]/categories[cat]["school_count"]);
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
                if (!(each in new_lang))
                {
                    new_lang[each]={"name": each};
                    new_lang[each]["school_count"] = 0;
                    new_lang[each]["moi_perc"] = 0;
                }
                new_lang[each]["student_count"] = languages["mt"][each]["student_count"];
                new_lang[each]["mt_perc"] = Math.round(languages["mt"][each]["student_count"]*100/mt_student_total);
            }
        }

        new_lang["OTHERS"]["moi_perc"] = Math.round(new_lang["OTHERS"]["school_count"]*100/moi_school_total);
        new_lang["OTHERS"]["mt_perc"] = Math.round(new_lang["OTHERS"]["student_count"]*100/mt_student_total);
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

