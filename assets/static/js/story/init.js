/* vi:si:et:sw=4:sts=4:ts=4 */

'use strict';
(function() {

    klp.init = function() {
        klp.accordion.init();
        klp.router = new KLPRouter();
        klp.router.init();
        initSelect2();
        loadData();
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

    function loadData() {
        var params = klp.router.getHash().queryParams;
        var metaURL = "stories/meta/"; //FIXME: enter API url
        var $metaXHR = klp.api.do(metaURL, params);

        $metaXHR.done(function(data) {
            console.log("summary data", data);
            renderSummary(data);
            renderRespondentChart(data);
        });


        var detailURL = "stories/details/";
        var $detailXHR = klp.api.do(detailURL, params);

        $detailXHR.done(function(data) {
            console.log("detail data", data);
            renderFeatured(data);
            renderIVRS(data);
            renderSurvey(data);
            renderWeb(data);
            //renderComparison(data);
        });


        var volumeURL = "stories/volume/";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            renderIVRSVolumeChart(data);
        });

        //TODO: do some loading behaviour

    }

    function renderRespondentChart(data) {
        var labels = _.keys(data.respondents);
        var values = _.values(data.respondents);
        //console.log(labels, values);
        var data_respondent = {
            labels: labels,
            series: [
                values
            ]
        };

        renderBarChart('#chart_respondent', data_respondent);

    }

    function renderIVRSVolumeChart(data) {
        var months = data.volumes['2014']; //FIXME: deal with with academic year.
        var labels = _.keys(months);
        var values = _.values(months);
        var data_ivrs = {
            labels: labels,
            series: [
                values
            ]
        };
        renderBarChart('#chart_ivrs', data_ivrs);
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

    function renderSummary(data) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplCountSummary = swig.compile($('#tpl-countSummary').html());
        var topSummaryHTML = tplTopSummary(data);
        $('#topSummary').html(topSummaryHTML);

        var summaries = {
            'ivrs': [{
                'label': 'Schools',
                'count': data.total.schools
            }, {
                'label': 'Schools with Stories',
                'count': data.ivrs.schools
            }, {
                'label': 'Calls received',
                'count': data.ivrs.stories
            }, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }],
            'survey': [{
                'label': 'Schools',
                'count': data.total.schools
            }, {
                'label': 'Schools with Stories',
                'count': data.community.schools
            }, {
                'label': 'Stories',
                'count': data.community.stories
            }, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }],
            'web': [{
                'label': 'Schools',
                'count': data.total.schools
            }, {
                'label': 'Schools with Stories',
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
        $('#ivrssummary').html(html);
        html = tplCountSummary({
            'summary': summaries['survey']
        });
        $('#surveysummary').html(html);
        html = tplCountSummary({
            'summary': summaries['web']
        });
        $('#websummary').html(html);
    }

    function renderFeatured(data) {
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
        var featuredQuestions = featuredQuestionsPrimary; //TODO: add preschool
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
        $('#quicksummary').html(html);

    }

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

    function renderIVRS(data) {
        var tplGradeGraph = swig.compile($('#tpl-gradeGraph').html());
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        //define your data
        var gradeQuestion = getQuestion(data, 'ivrs', 'ivrss-grade');
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
        $('#ivrsgrades').html(html);

        var IVRSQuestionKeys = [
            'ivrss-school-open',
            'ivrss-headmaster-present',
            'ivrss-toilets-condition'
        ];

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
        $('#ivrsquestions').html(html);
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

    function renderWeb(data) {
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());

        var questions = [{
            'question': 'Where there was evidence of a Mid-day meal served:',
            'score': 440,
            'total': 1000,
            'percent': 44
        }, {
            'question': 'Where 50% of children enrolled in the school were present:',
            'score': 260,
            'total': 1000,
            'percent': 26
        }, {
            'question': 'Where all the teachers for all classes were present:',
            'score': 300,
            'total': 1000,
            'percent': 30
        }];

        var html = ''
        for (var pos in questions) {
            html = html + "<div class='chart-athird-item'>" + tplPercentGraph(questions[pos]) + "</div>";
        }
        $('#webquestions').html(html);

        var tplColorText = swig.compile($('#tpl-colorText').html());

        var facilities = [{
            'facility': 'All weather pucca building',
            'icon': ['fa fa-university'],
            'percent': 44
        }, {
            'facility': 'Playground',
            'icon': ['fa fa-futbol-o'],
            'percent': 45
        }, {
            'facility': 'Drinking Water',
            'icon': ['fa  fa-tint'],
            'percent': 54
        }, {
            'facility': 'Library',
            'icon': ['fa fa-book'],
            'percent': 64
        }, {
            'facility': 'Toilets',
            'icon': ['fa fa-male', 'fa fa-female'],
            'percent': 74
        }, {
            'facility': 'Secure Boundary Wall',
            'icon': ['fa fa-circle-o-notch'],
            'percent': 34
        }];

        var html = ''
        for (var pos in facilities) {
            html = html + tplColorText(facilities[pos]);
        }
        $('#webfacilities').html(html);

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

})();