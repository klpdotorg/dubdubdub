/* vi:si:et:sw=4:sts=4:ts=4 */

'use strict';
(function() {
    var preschoolString = 'PreSchool';
    var schoolString = 'Primary School';

    klp.init = function() {
        klp.accordion.init();
        klp.router = new KLPRouter();
        klp.router.init();
        initSelect2();
        klp.router.events.on('hashchange', function(event, params) {
            hashChanged(params);
        });
        klp.router.start();
        //loadData('Primary School');
        //loadData('Preschool');
        //get JS query params from URL

    }

    function hashChanged(params) {
        //FIXME: clear all the things, do a loading state.
        console.log("hashchange called", params);
        var queryParams = params.queryParams;
        if (!queryParams.school_type) {
            loadData(preschoolString, queryParams);
            loadData(schoolString, queryParams);
            $('#preschoolContainer').show();
            $('#primarySchoolContainer').show();
        } else {
            if (queryParams.school_type == preschoolString) {
                $('#primarySchoolContainer').hide();
                $('#preschoolContainer').show();
            } else {
                $('#primarySchoolContainer').show();
                $('#preschoolContainer').hide();                
            }
            loadData(queryParams.school_type, queryParams);
        }
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
            var objectId = choice.added.data.properties.id;
            var entityType = choice.added.data.entity_type;
            var boundaryType = choice.added.data.properties.type;
            if (entityType === 'school') {
                var paramKey = 'school_id';
            } else if (boundaryType == 'district') {
                var paramKey = 'admin1';
            } else if (['project', 'block'].indexOf(boundaryType) !== -1) {
                var paramKey = 'admin2';
            } else if (['circle', 'cluster'].indexOf(boundaryType) !== -1) {
                var paramKey = 'admin3';
            } else {
                var paramKey = 'error';
            }

            //this prevents an un-needed lookup when we already have data for
            //the entity user is filtering by
            var cacheKey = paramKey + '__' + objectId;
            var cacheValue = {
                'type': entityType === 'school' ? choice.added.data.properties.type.name : choice.added.data.properties.type,
                'name': choice.added.data.properties.name,
                'obj': choice.added.data
            };
            klp.data[cacheKey] = cacheValue;

            var schoolType = null;

            //FIXME: when back-end params get more sane
            if (['admin1', 'admin2', 'admin3'].indexOf(paramKey) !== -1) {
                schoolType = choice.added.data.properties.school_type;
                schoolType = schoolType == 'preschool' ? preschoolString : schoolString;
            } else if (paramKey == 'school_id') {
                schoolType = choice.added.data.properties.type.name;
            }

            var hashParams = {
                'school_id': null,
                'admin1': null,
                'admin2': null,
                'admin3': null,
                'school_type': schoolType
            };
            hashParams[paramKey] = objectId;
            console.log("hash params", hashParams);
            klp.router.setHash(null, hashParams);
        });

    }

    function makeResults(array, type) {
        var schoolDistrictMap = {
            'primaryschool': 'Primary School',
            'preschool': 'Preschool'
        };
        return _(array).map(function(obj) {
            console.log("obj", obj);
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

    function fillSelect2(entityDetails) {
        if (entityDetails.name == '') {
            //do nothing if name is empty
            return;
        }
        var currentData = $('#select2search').select2("data");

        var boundaryTypes = ['district', 'block', 'cluster', 'circle', 'project'];
        if (boundaryTypes.indexOf(entityDetails.type) !== -1) {
            var typ = 'boundary';
        } else {
            var typ = 'school';
        }
        var obj = entityDetails.obj;
        if (!obj.hasOwnProperty('properties')) {
            obj = {
                'properties': obj
            };
        }
        var dataObj = makeResults([obj], typ)[0];
        console.log("current data", currentData, dataObj);
        $('#select2search').select2("data", dataObj);
    }

    function loadData(schoolType, params) {
        //var params = klp.router.getHash().queryParams;
        var metaURL = "stories/meta"; //FIXME: enter API url
        params['school_type'] = schoolType

        var entityDeferred = fetchEntityDetails(params);
        entityDeferred.done(function(entityDetails) {
            fillSelect2(entityDetails);
            console.log("entity details", entityDetails);
            var $metaXHR = klp.api.do(metaURL, params);
            $metaXHR.done(function(data) {
                data.searchEntity = entityDetails;
                console.log("summary data", data);
                renderSummary(data, schoolType);
                renderRespondentChart(data, schoolType);
            });
        });

        var detailURL = "stories/details/";
        var $detailXHR = klp.api.do(detailURL, params);

        $detailXHR.done(function(data) {
            console.log("detail data", data);
            renderFeatured(data, schoolType);
            renderIVRS(data, schoolType);
            renderWeb(data, schoolType);
            if (schoolType == schoolString) {
                renderSurvey(data); // Community Surveys currently not done in Anganwadis
            }
            //renderComparison(data);
        });


        var volumeURL = "stories/volume/";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            renderIVRSVolumeChart(data, schoolType);
        });


    }

    function renderRespondentChart(data, schoolType) {
        var labels = _.map(_.keys(data.respondents), function(label) {
            return _.str.titleize(label);
        });
        var values = _.values(data.respondents);
        //console.log(labels, values);
        var data_respondent = {
            labels: labels,
            series: [
                values
            ]
        };
        var suffix = '';
        if (schoolType == preschoolString)
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
        if (schoolType == preschoolString) {
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

        if (schoolType == preschoolString) {
            summaryLabel = "Preschools";
            suffix = '_ang';
        }

        var summaryData = data;
        summaryData['school_type'] = summaryLabel;
        var topSummaryHTML = tplTopSummary(summaryData);
        $('#topSummary' + suffix).html(topSummaryHTML);

        var searchEntityType = data.searchEntity.type;
        
        //FIXME: better way to do this?
        if (searchEntityType === schoolString || searchEntityType === preschoolString) {
            $('.js-hide-school').css("visibility", "hidden");
        } else {
            $('.js-hide-school').css("visibility", "visible");                
        }

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
        if (schoolType == schoolString)
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
        if (schoolType == preschoolString) {
            suffix = '_ang';
        }
        $('#quicksummary' + suffix).html(html);

    }


    function renderIVRS(data, schoolType) {
        var tplGradeGraph = swig.compile($('#tpl-gradeGraph').html());
        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        //define your data
        var ivrs_grade = 'ivrss-grade';
        if (schoolType == preschoolString) {
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
        if (schoolType == preschoolString) {
            suffix = '_ang';
        }
        $('#ivrsgrades' + suffix).html(html);

        var IVRSQuestionKeys = [];
        if (schoolType == schoolString)
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
        if (schoolType == schoolString) {
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
        if (schoolType == preschoolString) {
            suffix = '_ang';
        }
        $('#webquestions' + suffix).html(html);

        var tplColorText = swig.compile($('#tpl-colorText').html());

        var facilityQuestions = [];
        if ( schoolType == schoolString ) {
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
            facility.total = question.total;
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

    function fetchEntityDetails(params) {
        var $deferred = $.Deferred();
        var paramKey = getParamKey(params);
        console.log("param key", paramKey, params);
        if (!paramKey) {
            setTimeout(function() {
                $deferred.resolve({
                    'type': 'All',
                    'name': '',
                    'obj': {}
                });
            }, 0);
            return $deferred;
        }
        var paramValue = params[paramKey];
        var cacheKey = paramKey + '__' + paramValue;
        if (klp.data.hasOwnProperty(cacheKey)) {
            setTimeout(function() {
                $deferred.resolve(klp.data[cacheKey]);
            }, 0);
            return $deferred;
        }
        if (paramKey == 'school_id') {
            var entityType = 'school';
            var entityURL = 'schools/school/' + paramValue;
        } else {
            var entityType = 'boundary';
            var entityURL = 'boundary/admin/' + paramValue;
        }
        var $entityXHR = klp.api.do(entityURL, {});
        $entityXHR.done(function(data) {
            var entity = {
                'name': data.name,
                'type': entityType === 'school' ? data.type.name : data.type,
                'obj': data
            }
            $deferred.resolve(entity);
        });
        $entityXHR.fail(function(err) {
            $deferred.reject(err);
        });

        return $deferred;
    }

    function getParamKey(params) {
        var possibleParams = ['admin1', 'admin2', 'admin3', 'school_id'];
        for (var i=0; i < possibleParams.length; i++) {
            var param = possibleParams[i];
            if (params[param]) {
                return param;
            }
        }
        return false;
    }

})();