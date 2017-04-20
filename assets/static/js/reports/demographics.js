'use strict';
(function() {
    var utils;
    var common;
    var summaryData;
    var detailsData;
    var acadYear;
    var klpData;
    var repType;
    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        utils  = klp.reportUtils;
        common = klp.reportCommon;
        fetchReportDetails();
        klp.router.start();
    };

    /*
        Get the basic summary data from the klp to show on the page
    */
    function fetchReportDetails()
    {
        var id, lang, url;
        repType = utils.getSlashParameterByName("report_type");
        id = utils.getSlashParameterByName("id");
        lang = utils.getSlashParameterByName("language");

        url = "reports/summary/"+repType+"/?id="+id;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            klpData = data;
            acadYear = data["academic_year"].replace(/20/g, '');
            createSummaryData();
            getDetailsData(id, lang);
            getComparisonData(id, lang);
        });
    }

    /*
        Creates the data structure for summary data and returns it.
    */
    function createSummaryData()
    {
        summaryData = {
            "info"  : klpData["report_info"],
            "school_count" : klpData["school_count"],
            "teacher_count" : klpData["teacher_count"],
            "gender" : klpData["gender"],
            "student_total": klpData["student_count"],
            "ptr" : klpData["ptr"],
            "school_perc" : klpData["school_perc"]
        };

        summaryData['girl_perc'] = Math.round(( summaryData["gender"]["girls"]/summaryData["student_total"] )* 100);
        summaryData['boy_perc'] = 100 - summaryData['girl_perc'];
        renderSummary();
    }

    /*
        Renders summary data
    */
    function renderSummary() {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplReportDate = swig.compile($('#tpl-reportDate').html());
        
        var now = new Date();
        var today = {'date' : moment(now).format("MMMM D, YYYY")};
        var dateHTML = tplReportDate({"today":today});
        $('#report-date').html(dateHTML);
        
        var topSummaryHTML = tplTopSummary({"data":summaryData});
        $('#top-summary').html(topSummaryHTML);
    }

    /*
        Get the Category and Language details from the backend.
    */
    function getDetailsData(bid, lang)
    {
        var url = "reports/demographics/"+repType+"/details/?id="+bid+"&language="+lang;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            detailsData = data;
            renderCategories(data);
            renderLanguage(data["languages"]);
        });
    }

    /*
        Gets Comparison data. Comparison across boundaries and years.
    */
    function getComparisonData(bid, lang)
    {
        var url = "reports/demographics/"+repType+"/comparison/?id="+bid+"&language="+lang;
        var $xhr = klp.api.do(url);
        $xhr.done(function(data) {
            //Adding data for current year to the 
            data["comparison"]["year-wise"][0] = {
                            "year": detailsData["report_info"]["year"],
                             "avg_enrol_upper": detailsData["enrolment"]["Upper Primary"]["average_student_count"],
                             "avg_enrol_lower": detailsData["enrolment"]["Lower Primary"]["average_student_count"],
                             "student_count": summaryData["student_count"],
                             "school_count": summaryData["school_count"],
                             "school_perc": summaryData["school_perc"],
                             "teacher_count": summaryData["teacher_count"],
                             "ptr": summaryData["ptr"]
            };
            data['comparison']['name'] = summaryData["info"]["name"];
            data['comparison']['type'] = summaryData["info"]["type"];
            renderComparison(data["comparison"]);
        });
    }

    /*
        Renders the categories. Shows average number of students per school and category percentage 
    */
    function renderCategories(data) {
        var categories = data["categories"];
        var school_total = 0;
        for (var cat in categories) {
            categories[cat]["name"] = cat;
            categories[cat]['enrolled'] = Math.round(
                categories[cat]["student_count"]/categories[cat]["school_count"]);
            school_total += categories[cat]["school_count"];
        }
        console.log("school_total:"+school_total);
        for(cat in categories) {
            console.log(cat);
            console.log(categories[cat]["school_count"]/school_total);
            categories[cat]['cat_perc'] = Math.round(
                categories[cat]["school_count"]/school_total*100);
            categories[cat]['school_total'] = school_total;
        }
        var tplCategory = swig.compile($('#tpl-Category').html());
        var categoryHTML = tplCategory({"cat":categories,"enrol":data["enrolment"]});
        $('#category-profile').html(categoryHTML);
    }

    /*
        Renders Mother Tongue and Medium of Instruction. 
        First calculates the total number of schools and then total students
        Then it calculates average number of school per language and average number of children per mother tongue.
    */
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

        new_lang["Others"] = {"name":"Others", "school_count": 0,
                              "student_count":0, "moi_perc":0,"mt_perc":0};
        for (var eachlang in languages["moi"]) {
            if (!_.contains(lang_lookup,eachlang))
            {
                new_lang["Others"]["school_count"] +=
                                    languages["moi"][eachlang]["school_count"];
                delete languages["moi"][eachlang];
            } else {
                new_lang[eachlang]= {"name" : eachlang};
                new_lang[eachlang]["school_count"] =
                                    languages["moi"][eachlang]["school_count"];
                new_lang[eachlang]["moi_perc"] = Math.round(
                    languages["moi"][eachlang]["school_count"]*100/moi_school_total);
            }
        }
        
        for (var eachmt in languages["mt"]) {
            if (!_.contains(lang_lookup,eachmt))
            {
                new_lang["Others"]["student_count"] +=
                                        languages["mt"][eachmt]["student_count"];
                delete languages["mt"][eachmt];
            } else {
                if (!(eachmt in new_lang))
                {
                    new_lang[eachmt] = {"name": eachmt};
                    new_lang[eachmt]["school_count"] = 0;
                    new_lang[eachmt]["moi_perc"] = 0;
                }
                new_lang[eachmt]["student_count"] =
                                        languages["mt"][eachmt]["student_count"];
                new_lang[eachmt]["mt_perc"] = Math.round(
                    languages["mt"][eachmt]["student_count"]*100/mt_student_total);
            }
        }

        new_lang["Others"]["moi_perc"] = Math.round(
            new_lang["Others"]["school_count"]*100/moi_school_total);
        new_lang["Others"]["mt_perc"] = Math.round(
            new_lang["Others"]["student_count"]*100/mt_student_total);
        var sorted_lang = _.sortBy(new_lang, 'school_count').reverse();
        var tplLanguage = swig.compile($('#tpl-Language').html());
        var languageHTML = tplLanguage({"lang":sorted_lang});
        $('#language-profile').html(languageHTML);
        
    }

    /*
        Renders year wise and neighbour wise comparison.
    */
    function renderComparison(data) {
        //render year comparison
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html());
        var yrcompareHTML = tplYearComparison({"years":data["year-wise"],
                                        "name":data["name"]});
        $('#comparison-year').html(yrcompareHTML);

        var tplComparison = swig.compile($('#tpl-neighComparison').html());
        var compareHTML = tplComparison({"neighbours":data["neighbours"],
                                        "name":data["name"], "type":data["type"]});
        $('#comparison-neighbour').html(compareHTML);
    }

})();
