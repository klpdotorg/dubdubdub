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

        /*var dataURL = "reports/finances/xxx";
        var $dataXHR = klp.api.do(detailURL, params);
        $datadetailXHR.done(function(data) {*/
            var metadata = { 
                // "web": {
                //     "schools": 3163, 
                //     "last_story": "2040-08-27T00:00:00", 
                //     "verified_stories": 6587, 
                //     "stories": 6587
                // }, 
                "ivrs": {
                    "schools": 1903, 
                    "last_story": 
                    "2016-02-04T00:00:00", "stories": 7171
                }, 
                "community": {
                    "schools": 3541, 
                    "last_story": "2016-01-30T00:00:00", 
                    "stories": 160240
                }, 
                "total": {
                    "schools": 21550, 
                    "schools_with_stories": 5919, 
                    "stories": 174000
                },
                "respondents": {
                    "LOCAL_LEADER": 8916, 
                    "EDUCATED_YOUTH": 10478, 
                    "SDMC_MEMBER": 25269, 
                    "PARENTS": 86473, 
                    "TEACHERS": 2510, 
                    "AKSHARA_STAFF": 6282, 
                    "ELECTED_REPRESENTATIVE": 3572, 
                    "VOLUNTEER": 10477, 
                    "CBO_MEMBER": 17408
                }
            }
            renderStorySummary(metadata);
            renderRespondentChart(metadata);
            var calldata = {
              "volumes": 
              {
                "2016": {"Jan": 2790, "Feb": 2640, "Mar": 602, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0}, 
                "2013": {"Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 30, "Oct": 107, "Nov": 601, "Dec": 971}, 
                "2014": {"Jan": 796, "Feb": 606, "Mar": 496, "Apr": 0, "May": 0, "Jun": 314, "Jul": 192, "Aug": 92, "Sep": 59, "Oct": 2, "Nov": 84, "Dec": 206}, 
                "2015": {"Jan": 381, "Feb": 427, "Mar": 240, "Apr": 12, "May": 4, "Jun": 470, "Jul": 348, "Aug": 108, "Sep": 259, "Oct": 203, "Nov": 1689, "Dec": 3001}
              }
            }
            renderIVRSVolumeChart(calldata);
            var responses = {"web": [{"question": {"display_text": "How many schools are in an all weather pucca building?", "text": "An All weather (pucca) building", "key": "webs-pucca-building"}, "answers": {"options": {"Yes": 2225, "No": 27}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have a boundary wall or fencing?", "text": "Boundary wall/ Fencing", "key": "webs-boundary-wall"}, "answers": {"options": {"Unknown": 26, "Yes": 6730, "No": 1215}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have a playground?", "text": "Play ground", "key": "webs-playground"}, "answers": {"options": {"Unknown": 19, "Yes": 6015, "No": 1764}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have separate toilets for boys and girls?", "text": "Separate Toilets for Boys and Girls", "key": "webs-separate-toilets"}, "answers": {"options": {"Unknown": 21, "Yes": 5479, "No": 1457}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have drinking water facilities?", "text": "Drinking Water facility", "key": "webs-drinking-water"}, "answers": {"options": {"Unknown": 14, "Yes": 6355, "No": 745}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have a library?", "text": "Library", "key": "webs-library"}, "answers": {"options": {"Unknown": 18, "Yes": 5304, "No": 1156}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools was there evidence of mid day meals being served?", "text": "Did you see any evidence of mid day meal being served (food being cooked, food waste etc.) on the day of your visit?", "key": "webs-food-being-cooked"}, "answers": {"options": {"Unknown": 25, "Yes": 6489, "No": 690}, "question_type": "radio"}}, {"question": {"display_text": "In how many schools were at least 50% of the children enrolled present??", "text": "Were at least 50% of the children enrolled present on the day you visited the school?", "key": "webs-50percent-present"}, "answers": {"options": {"Unknown": 14, "Yes": 6695, "No": 491}, "question_type": "radio"}}, {"question": {"display_text": "In how many schools were all the teachers present on the day of the school visit?", "text": "Were all teachers present on the day you visited the school?", "key": "webs-teachers-present"}, "answers": {"options": {"Unknown": 18, "Yes": 6026, "No": 1148}, "question_type": "radio"}}, {"question": {"display_text": "How many schools were open?", "text": "Was the school open?", "key": "ivrss-school-open"}, "answers": {"options": {"Unknown": 6, "Yes": 19446, "No": 264}, "question_type": "checkbox"}}], "anganwadi": [], "ivrs": [{"question": {"display_text": "In how many schoos was the headmaster present?", "text": "Was the headmaster present?", "key": "ivrss-headmaster-present"}, "answers": {"options": {"Yes": 5580, "No": 935}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools were all the teachers present?", "text": "Were all the teachers present?", "key": "ivrss-teachers-present"}, "answers": {"options": {"Yes": 4846, "No": 1669}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have toilets for children in good condition?", "text": "Were the toilets for children in good condition?", "key": "ivrss-toilets-condition"}, "answers": {"options": {"Yes": 5048, "No": 1467}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools were classes being conducted properly?", "text": "Were classes being conducted properly?", "key": "ivrss-classes-proper"}, "answers": {"options": {"Yes": 5170, "No": 1345}, "question_type": "checkbox"}}, {"question": {"display_text": "How are the schools in this boundary rated?", "text": "Is this a A, B or C grade school based on your observations?", "key": "ivrss-grade"}, "answers": {"options": {"1": 2593, "3": 792, "2": 3130}, "question_type": "numeric"}}, {"question": {"display_text": "How many schools were open?", "text": "Was the school open?", "key": "ivrss-school-open"}, "answers": {"options": {"Unknown": 6, "Yes": 19446, "No": 264}, "question_type": "checkbox"}}, {"question": {"display_text": "", "text": "Class visited", "key": "ivrss-class-visited"}, "answers": {"options": {"1": 415, "3": 35, "2": 26, "5": 3568, "4": 3253, "7": 17, "6": 22, "8": 2}, "question_type": "numeric"}}, {"question": {"display_text": "In how many schools were math classes happening?", "text": "Was Math class happening on the day of your visit?", "key": "ivrss-math-class-happening"}, "answers": {"options": {"Yes": 3291, "No": 4040}, "question_type": "checkbox"}}, {"question": {"display_text": "", "text": "Which chapter of the textbook was taught?", "key": "ivrss-chapter-number"}, "answers": {"options": {"11": 12, "10": 25, "13": 1, "12": 4, "15": 2, "20": 1, "1": 13, "3": 32, "2": 18, "5": 25, "4": 25, "7": 16, "6": 27, "9": 19, "8": 9}, "question_type": "numeric"}}, {"question": {"display_text": "", "text": "Which Ganitha Kalika Andolana TLM was being used by teacher?", "key": "ivrss-gka-tlm-number"}, "answers": {"options": {"11": 1, "10": 1, "13": 21, "12": 27, "15": 31, "21": 6, "17": 48, "16": 39, "19": 31, "18": 17, "20": 21, "1": 5, "3": 34, "2": 30, "5": 23, "4": 41, "7": 41, "6": 11, "9": 14, "8": 30, "14": 59}, "question_type": "numeric"}}, {"question": {"display_text": "In how many schools were the GKA TLM being used by children?", "text": "Did you see children using the Ganitha Kalika Andolana TLM?", "key": "ivrss-gka-tlm-in-use"}, "answers": {"options": {"Yes": 2714, "No": 520}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools were group work happening?", "text": "Was group work happening in the class on the day of your visit?", "key": "ivrss-group-work"}, "answers": {"options": {"Yes": 383, "No": 393}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools were square line books being used by children?", "text": "Were children using square line book during math class?", "key": "ivrss-children-use-square-line"}, "answers": {"options": {"Yes": 65, "No": 145}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have toilets for children in good condition?", "text": "Are all the toilets in the school functional?", "key": "ivrss-toilets-condition"}, "answers": {"options": {"Unknown": 4766, "Yes": 37421, "No": 13182}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have separate toilets for boys and girls?", "text": "Does the school have a separate functional toilet for girls?", "key": "ivrss-functional-toilets-girls"}, "answers": {"options": {"Unknown": 5194, "Yes": 37491, "No": 14453}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have drinking water facilities?", "text": "Does the school have drinking water?", "key": "ivrss-drinking-water"}, "answers": {"options": {"Unknown": 1318, "Yes": 50221, "No": 3680}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools was there evidence of mid day meals being served?", "text": "Is a Mid Day Meal served in the school?", "key": "ivrss-midday-meal"}, "answers": {"options": {"Unknown": 841, "Yes": 53870, "No": 437}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools was there a teacher present in each class?", "text": "Was there a teacher present in each class?", "key": "ivrss-teacher-present"}, "answers": {"options": {"Yes": 2595, "No": 1055}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools were class 4 and 5 math teachers trained for GKA?", "text": "Were the class 4 and 5 math teachers trained in GKA methodology in the school you have visited?", "key": "ivrss-gka-trained"}, "answers": {"options": {"Yes": 1686, "No": 155}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools were multiple TLMs being used?", "text": "Were multiple TLMs being used?", "key": "ivrss-multi-tlm"}, "answers": {"options": {"Yes": 159, "No": 412}, "question_type": "numeric"}}, {"question": {"display_text": "In how many schools was representational stage in practice?", "text": "Did you see representational stage being practiced during the class?", "key": "ivrss-gka-rep-stage"}, "answers": {"options": {"Yes": 183, "No": 382}, "question_type": "checkbox"}}], "community": [{"question": {"display_text": "In how many schools are there no concerns about  mid day meals?", "text": "Is there any concern pertaining to the food served to the children in school?", "key": "comms2-food-concern"}, "answers": {"options": {"Yes": 2112, "No": 401}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools are teachers regular?", "text": "Are the teachers regular?", "key": "comms2-teachers-regular"}, "answers": {"options": {"Unknown": 9658, "Yes": 127302, "No": 10716}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools are teachers taking classes regularly?", "text": "Do teacher take classes regularly?", "key": "comms2-classes-regular"}, "answers": {"options": {"Unknown": 14989, "Yes": 120806, "No": 15902}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools are children getting academic attention?", "text": "Are the children getting the required academic attenction from the teachers?", "key": "comms2-children-attention"}, "answers": {"options": {"Unknown": 7701, "Yes": 84018, "No": 13107}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools are SDMC members involved in the progress?", "text": "Are the SDMC members involved in the progress of the school?", "key": "comms2-sdmc-involved"}, "answers": {"options": {"Unknown": 8004, "Yes": 68364, "No": 28538}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have safe drinking water?", "text": "Does the school have safe drinking water?", "key": "comms2-drinking-water"}, "answers": {"options": {"Unknown": 4714, "Yes": 86837, "No": 15978}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have functioning toilets for children?", "text": "Does school has functioning toiltes for children?", "key": "comms2-functioning-toilets"}, "answers": {"options": {"Unknown": 7353, "Yes": 74372, "No": 23990}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have sufficient teachers?", "text": "Does the school has sufficient teacher?", "key": "comms2-sufficient-teachers"}, "answers": {"options": {"Unknown": 6693, "Yes": 78978, "No": 20267}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have toilets for children in good condition?", "text": "Are all the toilets in the school functional?", "key": "ivrss-toilets-condition"}, "answers": {"options": {"Unknown": 4766, "Yes": 37421, "No": 13182}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have separate toilets for boys and girls?", "text": "Does the school have a separate functional toilet for girls?", "key": "ivrss-functional-toilets-girls"}, "answers": {"options": {"Unknown": 5194, "Yes": 37491, "No": 14453}, "question_type": "checkbox"}}, {"question": {"display_text": "How many schools have drinking water facilities?", "text": "Does the school have drinking water?", "key": "ivrss-drinking-water"}, "answers": {"options": {"Unknown": 1318, "Yes": 50221, "No": 3680}, "question_type": "checkbox"}}, {"question": {"display_text": "In how many schools was there evidence of mid day meals being served?", "text": "Is a Mid Day Meal served in the school?", "key": "ivrss-midday-meal"}, "answers": {"options": {"Unknown": 841, "Yes": 53870, "No": 437}, "question_type": "checkbox"}}], "mobile": [], "csv": []}
            renderRepsonseSummary(responses);

            var comparisonJson = {
                "year-wise": {
                    "2013":{"year":"2013","schools":5919,"ivrs_calls":1345,"surveys":200},
                    "2014":{"year":"2014","schools":5800,"ivrs_calls":5345,"surveys":800},
                    "2015":{"year":"2015","schools":5805,"ivrs_calls":11345,"surveys":1200}

                }, /* maybe entrolment can be calculated with student and school count 
                    Percentage could be percentage of schools in district */
                "neighbours" : {
                    "Bangalore Central":{"name":"Bangalore Central","schools":5919,"ivrs_calls":6545,"surveys":200},
                    "Bangalore North":{"name":"Bangalore North","schools":5800,"ivrs_calls":5005,"surveys":800},
                    "Bangalore South":{"name":"Bangalore South","schools":5805,"ivrs_calls":5543,"surveys":1200},
                    "Bangalore Rural":{"name":"Bangalore Rural","schools":5919,"ivrs_calls":3456,"surveys":200},
                    "Chikkabalapur":{"name":"Chikkabalapur","schools":5800,"ivrs_calls":5345,"surveys":200}
                }
            }
            renderComparison(comparisonJson);
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

    function renderStorySummary(data){
        var tpl = swig.compile($('#tpl-storySummary').html());
        var html = tpl(data);
        $('#story-summary').html(html); 
    }

    function renderRespondentChart(data) {
        var labelMap = {
            'SDMC_MEMBER': 'SDMC',
            'CBO_MEMBER': 'CBO',
            'PARENTS': 'Parents',
            'TEACHERS': 'Teachers',
            'VOLUNTEER': 'Volunteers',
            'EDUCATED_YOUTH': 'Youth',
            'LOCAL_LEADER': 'Local Leader',
            'AKSHARA_STAFF': 'Akshara',
            'ELECTED_REPRESENTATIVE': 'Elected Rep' 
        };
        var labels = _.map(_.keys(data.respondents), function(label) {
            if (labelMap.hasOwnProperty(label)) {
                return labelMap[label];
            } else {
                return _.str.titleize(label);
            }
        });
        var values = _.values(data.respondents);
        var meta_values = [];
        for( var i=0; i < labels.length; i++) {
            meta_values.push({'meta': labels[i],'value': values[i]});
        } /* chartist tooltip transformations */ 
        var data_respondent = {
            labels: labels,
            series: [
                { 
                    className: 'ct-series-a',
                    data: meta_values,
                }
            ]
        };
        renderBarChart('#chart-respondent', data_respondent, true);
    }

    function renderIVRSVolumeChart(data, schoolType) {
        var years = _.keys(data.volumes);
        var latest = Math.max.apply(Math,years);
        var earliest = Math.min.apply(Math,years);
        var months = _.keys(data.volumes[latest]);
        var meta_values = [];
        for (var i in months)
        {
            var month_volume = 0;
            for (var j in years)
            {
                month_volume += data.volumes[years[j]][months[i]];
            }
            meta_values.push({'meta':months[i],'value':month_volume})
        }
        var data_ivrs = {
            labels: months, //labels,
            series: [
                { 
                    className: 'ct-series-a',
                    data: meta_values,
                }
            ]
        };
        renderBarChart('#chart-ivrs', data_ivrs, false);
    }

    function renderBarChart(elementId, data, horizontal) {

        var options = {
            seriesBarDistance: 10,
            axisX: {
                showGrid: false,
            },
            axisY: {
                showGrid: false,
                offset: 70
            },
            plugins: [
                Chartist.plugins.tooltip()
            ],
            reverseData: horizontal,
            horizontalBars: horizontal
        };

        var responsiveOptions = [
            ['screen and (max-width: 640px)', {
                seriesBarDistance: 5,
                axisX: {
                    labelInterpolationFnc: function (value) {
                    return value;
                }
            }
          }]
        ];

        var $chart_element = Chartist.Bar(elementId, data, options, responsiveOptions).on('draw', function(data) {
            if (data.type === 'bar') {
                data.element.attr({
                    style: 'stroke-width: 10px;'
                });
            }
            if (data.type === 'label' && data.axis === 'x') {
                data.element.attr({
                    width: 250
                })
            }
        });
    }

    function renderRepsonseSummary(data) {
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        var webQuestionKeys = [];
        var qsets = [
          {"ivrs":"ivrss-toilets-condition","community":"comms2-functioning-toilets"},
          {"ivrs":"ivrss-functional-toilets-girls","web":"webs-separate-toilets"},
          {"ivrs":"ivrss-teachers-present","web":"webs-teachers-present"},
          {"ivrs":"ivrss-drinking-water","community":"comms2-drinking-water","web":"webs-drinking-water"},
          {"community":"comms2-sdmc-involved"},
          {"community":"comms2-sufficient-teachers"}

          
        ]
        
        var questions = mergeQuestions(data, qsets);
        var html = '<div class="sect-parent"><div class="sect-half">';
        for (var pos in questions) {
            console.log(questions[pos]);
            if (pos > (questions.length/2)-1)
                html = html + "</div><div class='sect-half'>";
            html = html + tplPercentGraph(questions[pos]); 
        }
        html = html + "</div></div>";
        $('#response-summary').html(html);
        
    }

    function mergeQuestions(data, qsets) {
        var mergeddata = [];
        for (var i in qsets) {
          var q = {}
          for (var each in qsets[i]) {
            var questionObject = getQuestion(data, each, qsets[i][each]);
            if (_.keys(q).length == 0) {
              q = getQuestionsArray([questionObject])[0];
            } else {
              var addq = getQuestionsArray([questionObject])[0];
              q.score = q.score + addq.score;
              q.total = q.total + addq.total;
              q.percent = getPercent(q.score,q.total); 
            }
          }
          mergeddata.push(q);
        }
        return mergeddata;
    }

    function renderComparison(data) {
        var tplYearComparison = swig.compile($('#tpl-YearComparison').html()); 
        var yrcompareHTML = tplYearComparison({"years":data["year-wise"]});
        $('#comparison-year').html(yrcompareHTML);
        var tplComparison = swig.compile($('#tpl-neighComparison').html()); 
        var compareHTML = tplComparison({"neighbours":data["neighbours"]});
        $('#comparison-neighbour').html(compareHTML);
    
    }


    /*
        Helper functions
            TODO: move to separate file and document.
     */
    
    function getScore(answers, option) {
        if (!answers) {
            return 0;
        }
        if (typeof(option) == 'undefined') {
            option = 'Yes';
        }
        var options = answers.options;
        if (options.hasOwnProperty(option)) {
            return options[option];
        } else {
            return 0;
        }
    }

    function getTotal(answers) {
        return _.reduce(_.keys(answers.options), function(memo, answerKey) {
            return memo + answers.options[answerKey];
        }, 0);
    }

    function getPercent(score, total) {
        if (total == 0) {
            return 0;
        }
        return Math.round((score / total) * 100);
    }

    function getQuestion(data, source, key) {
        for (var i=0, len=data[source].length; i<len; i++) {
            var question = data[source][i];
            if (question.question.key === key) {
                return question;
            }
        }
        return false;
    }

    function getQuestionsArray(questions) {
        return _.map(questions, function(question, seq) {
            var score = getScore(question.answers, 'Yes');
            var total = getTotal(question.answers);
            var percent = getPercent(score, total);
            //var qObj = featuredQuestions[seq];
            //var displayText = qObj.source_prefix + question.question.display_text;
            return {
                'question': question.question.display_text,
                'score': score,
                'total': total,
                'percent': percent
            };
        });
    }

})();

