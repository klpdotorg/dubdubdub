/* vi:si:et:sw=4:sts=4:ts=4 */

'use strict';
(function() {

    klp.init = function() {
        klp.accordion.init();
        klp.router = new KLPRouter();
        klp.router.init();
        initSelect2();
        loadData('Primary School');
        loadData('Preschool');
        //get JS query params from URL

    }

    function initSelect2() {
        $('#select2search').select2({
            placeholder: 'Search for schools and boundaries',
            minimumInputLength: 3,
            ajax: {
                url: "/api/v1/search",
                quietMillis: 300,
                allowClear: true,
                data: function(term, page) {
                    return {
                        text: term,
                        geometry: 'yes'
                    };
                },
                results: function(data, page) {
                    var searchResponse = {
                        results: [{
                            text: "Pre-Schools",
                            children: makeResults(data.pre_schools.features, 'school')
                        }, {
                            text: "Primary Schools",
                            children: makeResults(data.primary_schools.features, 'school')
                        }, {
                            text: "Boundaries",
                            children: makeResults(data.boundaries.features, 'boundary')
                        }]
                    };
                    return {
                        results: searchResponse.results
                    };
                }
            }
        });
        $('#select2search').on("change", function(choice) {
            console.log(choice);
        });
    }

    function makeResults(array, type) {
        var schoolDistrictMap = {
            'primaryschool': 'Primary School',
            'preschool': 'Preschool'
        };
        return _(array).map(function(obj) {
            var name = obj.properties.name;
            if (type === 'boundary') {
                if (obj.properties.type === 'district') {
                    name = obj.properties.name + ' - ' + schoolDistrictMap[obj.properties.school_type] + ' ' + obj.properties.type;
                } else {
                    name = obj.properties.name + ' - ' + obj.properties.type;
                }
            }

            obj.entity_type = type;
            return {
                id: obj.properties.id,
                text: _.str.titleize(name),
                data: obj
            };
        });
    }

    function loadData(schoolType) {
        var params = klp.router.getHash().queryParams;
        var metaURL = "stories/meta"; //FIXME: enter API url
        params['school_type'] = schoolType
        var $metaXHR = klp.api.do(metaURL, params);

        $metaXHR.done(function(data) {
            console.log("summary data", data);
            renderSummary(data, schoolType);
            renderRespondentChart(data, schoolType);
        });


        var detailURL = "stories/details/";
        var $detailXHR = klp.api.do(detailURL, params);

        $detailXHR.done(function(data) {
            console.log("detail data", data);
            renderFeatured(data, schoolType);
            renderIVRS(data, schoolType);
            renderWeb(data, schoolType);
            if (schoolType == "Primary School")
                renderSurvey(data); // Community Surveys currently not done in Anganwadis
            
            //renderComparison(data);
        });


        var volumeURL = "stories/volume/";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            renderIVRSVolumeChart(data, schoolType);
        });


    }

    function renderRespondentChart(data, schoolType) {
        var labels = _.keys(data.respondents);
        var values = _.values(data.respondents);
        //console.log(labels, values);
        var data_respondent = {
            labels: labels,
            series: [
                values
            ]
        };
        var suffix = '';
        if (schoolType == 'Preschool')
            suffix = '_ang';
        renderBarChart('#chart_respondent' + suffix, data_respondent);

    }

    function renderIVRSVolumeChart(data, schoolType) {
        var months = data.volumes['2014']; //FIXME: deal with with academic year.
        var labels = _.keys(months);
        var values = _.values(months);
        var data_ivrs = {
            labels: labels,
            series: [
                values
            ]
        };
        var suffix = '';
        if (schoolType == "Preschool") {
            suffix = '_ang';
        }
        renderBarChart('#chart_ivrs' + suffix, data_ivrs);
    }


    function renderBarChart(elementId, data) {
        var options = {
            axisX: {
                showGrid: false
            },
            axisY: {
                showGrid: false
            }
        };

        var chart_element = Chartist.Bar(elementId, data, options).on('draw', function(data) {
            if (data.type === 'bar') {
                data.element.attr({
                    style: 'stroke-width: 20px'
                });
            }
        });
    }

    function renderSummary(data, schoolType) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var suffix = '';
        var summaryLabel = "Schools";

        if (schoolType == "Preschool") {
            summaryLabel = "Preschools";
            suffix = '_ang';
        }

        var summaryData = data;
        summaryData['school_type'] = summaryLabel;
        var topSummaryHTML = tplTopSummary(summaryData);
        $('#topSummary' + suffix).html(topSummaryHTML);
          
        var tplCountSummary = swig.compile($('#tpl-countSummary').html());  
        var summaries = {
            'ivrs': [{
                'label': summaryLabel,
                'count': data.total.schools
            }, {
                'label': summaryLabel + ' with Stories',
                'count': data.ivrs.schools
            }, {
                'label': 'Calls received',
                'count': data.ivrs.stories
            }, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }],
            'survey': [{
                'label': summaryLabel,
                'count': data.total.schools
            }, {
                'label': summaryLabel + ' with Stories',
                'count': data.community.schools
            }, {
                'label': 'Stories',
                'count': data.community.stories
            }, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }],
            'web': [{
                'label': summaryLabel,
                'count': data.total.schools
            }, {
                'label': summaryLabel + ' with Stories',
                'count': data.web.schools
            }, {
                'label': 'Verified Stories',
                'count': data.web.verified_stories
            }, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }]
        };

        var html = tplCountSummary({
            'summary': summaries['ivrs']
        });
        $('#ivrssummary' + suffix).html(html);
        html = tplCountSummary({
            'summary': summaries['survey']
        });
        $('#surveysummary' + suffix).html(html);
        html = tplCountSummary({
            'summary': summaries['web']
        });
        $('#websummary' + suffix).html(html);
    }

    function renderFeatured(data, schoolType) {
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        var featuredQuestionsPrimary = [
            {
                'source': 'ivrs',
                'key': 'ivrss-teachers-present',
                'source_prefix': 'IVRS: '
            },
            {
                'source': 'ivrs',
                'key': 'ivrss-classes-proper',
                'source_prefix': 'IVRS: '
            },
            {
                'source': 'community',
                'key': 'comms2-functioning-toilets',
                'source_prefix': 'Surveys: '
            },
            {
                'source': 'community',
                'key': 'comms2-drinking-water',
                'source_prefix': 'Surveys: '
            }
        ];
        var featuredQuestionsPreschool = [
            {
                'source': 'web',
                'key': 'weba-anganwadi-time',
                'source_prefix': 'Website: '
            },
            {
                'source': 'ivrs',
                'key': 'ivrsa-worker-present',
                'source_prefix': 'IVRS: '
            },
            {
                'source': 'web',
                'key': 'weba-tlm',
                'source_prefix': 'Website: '
            },
            {
                'source': 'ivrs',
                'key': 'ivrsa-activities-conducted',
                'source_prefix': 'IVRS: '
            }
        ];
        var featuredQuestions;
        if (schoolType == 'Primary School')
            featuredQuestions = featuredQuestionsPrimary;
        else
            featuredQuestions = featuredQuestionsPreschool;

        var questionObjects = _.map(featuredQuestions, function(obj) {
            return getQuestion(data, obj.source, obj.key);
        });

        var questions = getQuestionsArray(questionObjects);
        var questions = _.map(questions, function(question, seq) {
            question.display_text = featuredQuestions[seq].source_prefix + question.display_text;
            return question;
        });
        var html = ''
        for (var pos in questions) {
            html = html + tplPercentGraph(questions[pos]);
        }

        var suffix = '';
        if (schoolType == "Preschool") {
            suffix = '_ang';
        }
        $('#quicksummary' + suffix).html(html);

    }


    function renderIVRS(data, schoolType) {
        var tplGradeGraph = swig.compile($('#tpl-gradeGraph').html());
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        //define your data
        var ivrs_grade = 'ivrss-grade';
        if (schoolType == "Preschool") {
            ivrs_grade = 'ivrsa-grade';
        }
        var gradeQuestion = getQuestion(data, 'ivrs', ivrs_grade);
        var gradeAnswers = gradeQuestion.answers;
        var total = getTotal(gradeAnswers);
        var scoreA = getScore(gradeAnswers, "1");
        var scoreB = getScore(gradeAnswers, "2");
        var scoreC = getScore(gradeAnswers, "3");
        var grades = [{
            'value': 'A',
            'score': scoreA,
            'total': total,
            'percent': getPercent(scoreA, total),
            'color': 'green-leaf'
        }, {
            'value': 'B',
            'score': scoreB,
            'total': total,
            'percent': getPercent(scoreB, total),
            'color': 'orange-mild'
        }, {
            'value': 'C',
            'score': scoreC,
            'total': total,
            'percent': getPercent(scoreC, total),
            'color': 'pink-salmon'
        }];

        var html = ''
        for (var pos in grades) {
            html = html + "<div class='chart-athird-item'>" + tplGradeGraph(grades[pos]) + "</div>";
        }

        var suffix = '';
        if (schoolType == "Preschool") {
            suffix = '_ang';
        }
        $('#ivrsgrades' + suffix).html(html);

        var IVRSQuestionKeys = [];
        if (schoolType == "Primary School")
        {
            IVRSQuestionKeys = [
                'ivrss-school-open',
                'ivrss-headmaster-present',
                'ivrss-toilets-condition'
            ];
        } else {
            IVRSQuestionKeys = [
                'ivrsa-center-open',
                'ivrsa-worker-present'//,
                //'ivrsa-how-many-children'
            ];
        }

        var questionObjects = _.map(IVRSQuestionKeys, function(key) {
            return getQuestion(data, 'ivrs', key);
        });
        //console.log("ivrs question objects", questionObjects);

        var questions = getQuestionsArray(questionObjects);
        //console.log("ivrs questions", questions);

        html = ''
        for (var pos in questions) {
            html = html + tplPercentGraph(questions[pos]);
        }

        $('#ivrsquestions' + suffix).html(html);
    }

    function renderSurvey(data) {
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        var surveyQuestionKeys = [
            'comms2-teachers-regular',
            'comms2-sufficient-teachers',
            'comms2-classes-regular',
            'comms2-children-attention',
            'comms2-sdmc-involved',
            'comms2-food-concern'
        ]
        var questionObjects = _.map(surveyQuestionKeys, function(key) {
            return getQuestion(data, 'community', key);
        });
        var questions = getQuestionsArray(questionObjects);

        var html = "<div class='chart-half-item'>";
        for (var pos in questions) {
            if (pos == questions.length / 2) {
                html = html + "</div><div class='chart-half-item'>";
            }
            html = html + tplPercentGraph(questions[pos]);
        }
        html = html + "</div>";
        $('#surveyquestions').html(html);
    }

    function renderWeb(data, schoolType) {
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        var webQuestionKeys = [];
        if (schoolType == "Primary School") {
            webQuestionKeys = [
                'webs-food-being-cooked',
                'webs-50percent-present',
                'webs-teachers-present'
            ];
        } else {
            webQuestionKeys = [
                'weba-50percent-present',
                'weba-teacher-trained-disability',
                'weba-bal-vikas-meetings'
            ];
        }
        var questionObjects = _.map(webQuestionKeys, function(key) {
            return getQuestion(data, 'web', key);
        });
        var questions = getQuestionsArray(questionObjects);

        var html = ''
        for (var pos in questions) {
            html = html + "<div class='chart-athird-item'>" + tplPercentGraph(questions[pos]) + "</div>";
        }
        var suffix = '';
        if (schoolType == "Preschool") {
            suffix = '_ang';
        }
        $('#webquestions' + suffix).html(html);

        var tplColorText = swig.compile($('#tpl-colorText').html());

        var facilityQuestions = [];
        if ( schoolType == "Primary School" ) {
            facilityQuestions = [{
                'facility': 'All weather pucca building',
                'icon': ['fa fa-university'],
                'key': 'webs-pucca-building'
            }, {
                'facility': 'Playground',
                'icon': ['fa fa-futbol-o'],
                'key': 'webs-playground'
            }, {
                'facility': 'Drinking Water',
                'icon': ['fa  fa-tint'],
                'key': 'webs-drinking-water'
            }, {
                'facility': 'Library',
                'icon': ['fa fa-book'],
                'key': 'webs-library'
            }, {
                'facility': 'Toilets',
                'icon': ['fa fa-male', 'fa fa-female'],
                'key': 'webs-separate-toilets'
            }, {
                'facility': 'Secure Boundary Wall',
                'icon': ['fa fa-circle-o-notch'],
                'key': 'webs-boundary-wall'
            }];
        } else {
            facilityQuestions = [{
                'facility': 'A proper designated building',
                'icon': ['fa fa-university'],
                'key': 'weba-proper-building'
            }, {
                'facility': 'Play Material',
                'icon': ['fa fa-futbol-o'],
                'key': 'weba-play-material'
            }, {
                'facility': 'Drinking Water',
                'icon': ['fa  fa-tint'],
                'key': 'weba-drinking-water'
            }, {
                'facility': 'Mid-day meal',
                'icon': ['fa fa-spoon'],
                'key': 'weba-food-ontime'
            }, {
                'facility': 'Toilets',
                'icon': ['fa fa-male', 'fa fa-female'],
                'key': 'weba-toilet'
            }, {
                'facility': 'Secure Boundary Wall',
                'icon': ['fa fa-circle-o-notch'],
                'key': 'weba-boundary-security'
            }];
        }

        var questionObjects = _.map(facilityQuestions, function(question) {
            return getQuestion(data, 'web', question.key);
        });
        console.log("facility question objects", questionObjects);
        var questionsArray = getQuestionsArray(questionObjects);


        var facilities = _.map(questionsArray, function(question, seq) {
            var facility = facilityQuestions[seq];
            facility.percent = question.percent;
            return facility;
        });

        console.log("facilities", facilities);
        var html = ''
        for (var pos in facilities) {
            html = html + tplColorText(facilities[pos]);
        }
        $('#webfacilities' + suffix).html(html);

    }

    function renderComparison(data) {
        var tplCompareTable = swig.compile($('#tpl-compareTable').html());

        var neighbours = [{
            'name': 'Bangalore North',
            'schools': 1000,
            'stories': 440,
            'needs_volunteer': 'Playground',
            'needs_community': 'Playground',
            'ivrs': 500
        }, {
            'name': 'Bangalore South',
            'schools': 1000,
            'stories': 540,
            'needs_volunteer': 'Drinking Water',
            'needs_community': 'Mid-day Meals',
            'ivrs': 600
        }, {
            'name': 'Bangalore Central',
            'schools': 1000,
            'stories': 640,
            'needs_volunteer': 'Drinking Water',
            'needs_community': 'Playground',
            'ivrs': 600
        }, {
            'name': 'Bangalore Rural',
            'schools': 1000,
            'stories': 740,
            'needs_volunteer': 'Playground',
            'needs_community': 'Mid-day Meals',
            'ivrs': 600
        }];

        var html = tplCompareTable({
            'neighbours': neighbours
        });
        $('#comparison').html(html);

    }


    /*
        Helper functions
            TODO: move to separate file and document.
     */
    
    function getScore(answers, option) {
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