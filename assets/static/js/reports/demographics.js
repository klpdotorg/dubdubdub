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

        var url = "reports/summary/?id="+bid;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            summaryData = data;
            var summaryJSON= getSummaryData(data);
            renderSummary(summaryJSON,"Schools");
        });
        getDetailsData(bid, lang, repType);
        getComparisonData(bid, lang, repType);
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

    function getDetailsData(bid, lang, repType)
    {
        var url = "reports/demographics/"+repType+"/details/?id="+bid+"&language="+lang;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            detailsData = data;
            getComparisonData(bid, lang, repType);
            renderCategories(data);
            renderLanguage(data["languages"]);
        });
    }

    function getComparisonData(bid, lang, repType)
    {
        var url = "reports/demographics/"+repType+"/comparison/?id="+bid+"&language="+lang;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            data["comparison"]["year-wise"][0] = {
                            "year": detailsData["report_info"]["year"],
                             "enrol_upper": detailsData["enrolment"]["Upper Primary"]["student_count"],
                             "enrol_lower": detailsData["enrolment"]["Lower Primary"]["student_count"],
                             "student_count": summaryData["student_count"],
                             "school_count": summaryData["school_count"],
                             "school_perc": summaryData["school_perc"],
                             "teacher_count": summaryData["teacher_count"],
                             "ptr": summaryData["ptr"]
            };
            data['comparison']['boundary_name'] = summaryData["boundary_info"]["name"];
            renderComparison(data["comparison"]);
        });
    }

    function renderCategories(data) {
        var categories = data["categories"];
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

    function renderLanguage(languages) {
        var new_lang = {};
        var lang_lookup = ["KANNADA","TAMIL","TELUGU","URDU"];
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

        new_lang["Others"] = {"name":"Others", "school_count": 0, "student_count":0, "moi_perc":0,"mt_perc":0};
        for (var eachlang in languages["moi"]) {
            if (!_.contains(lang_lookup,eachlang))
            {
                new_lang["Others"]["school_count"] += languages["moi"][eachlang]["school_count"];
                delete languages["moi"][eachlang];
            } else {
                new_lang[eachlang]= {"name" : eachlang};
                new_lang[eachlang]["school_count"] = languages["moi"][eachlang]["school_count"];
                new_lang[eachlang]["moi_perc"] = Math.round(languages["moi"][eachlang]["school_count"]*100/moi_school_total);
            }
        }
        
        for (var eachmt in languages["mt"]) {
            if (!_.contains(lang_lookup,eachmt))
            {
                new_lang["Others"]["student_count"] += languages["mt"][eachmt]["student_count"];
                delete languages["mt"][eachmt];
            } else {
                if (!(eachmt in new_lang))
                {
                    new_lang[eachmt] = {"name": eachmt};
                    new_lang[eachmt]["school_count"] = 0;
                    new_lang[eachmt]["moi_perc"] = 0;
                }
                new_lang[eachmt]["student_count"] = languages["mt"][eachmt]["student_count"];
                new_lang[eachmt]["mt_perc"] = Math.round(languages["mt"][eachmt]["student_count"]*100/mt_student_total);
            }
        }

        new_lang["Others"]["moi_perc"] = Math.round(new_lang["Others"]["school_count"]*100/moi_school_total);
        new_lang["Others"]["mt_perc"] = Math.round(new_lang["Others"]["student_count"]*100/mt_student_total);
        var sorted_lang = _.sortBy(new_lang, 'school_count').reverse();
        var tplLanguage = swig.compile($('#tpl-Language').html());
        var languageHTML = tplLanguage({"lang":sorted_lang});
        $('#language-profile').html(languageHTML);
        
    }

    function renderComparison(data) {
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html());
        var yrcompareHTML = tplYearComparison({"years":data["year-wise"],"boundary_name":data["boundary_name"]});
        $('#comparison-year').html(yrcompareHTML);
        var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":data["neighbours"],"boundary_name":data["boundary_name"]});
        $('#comparison-neighbour').html(compareHTML);
    }

})();
