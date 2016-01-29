/* vi:si:et:sw=4:sts=4:ts=4 */

'use strict';
(function() {
    var preschoolString = 'PreSchool';
    var schoolString = 'Primary School';
    var premodalQueryParams = {};

    klp.init = function() {
        klp.accordion.init();
        klp.router = new KLPRouter();
        klp.router.init();
        initSelect2();
        klp.router.events.on('hashchange', function(event, params) {
            hashChanged(params);
        });
        klp.router.start();

        $('#startDate').yearMonthSelect("init");
        $('#endDate').yearMonthSelect("init");

        //this is a bit of a hack to save query state when
        //triggering a modal, since modals over-ride the url
        premodalQueryParams = klp.router.getHash().queryParams;

        if (premodalQueryParams.hasOwnProperty("from")) {
            var mDate = moment(premodalQueryParams.from);
            $('#startDate').yearMonthSelect("setDate", mDate);
        }
        if (premodalQueryParams.hasOwnProperty("to")) {
            var mDate = moment(premodalQueryParams.to);
            $('#endDate').yearMonthSelect("setDate", mDate);
        } else {
            $('#endDate').yearMonthSelect("setDate", moment());
        }

        //loadData('Primary School');
        //loadData('Preschool');
        //get JS query params from URL
        $('#resetButton').click(function(e) {
            e.preventDefault();
            var currentQueryParams = klp.router.getHash().queryParams;
            _.each(_.keys(currentQueryParams), function(key) {
                currentQueryParams[key] = null;
            });
            klp.router.setHash('', currentQueryParams);
        });

        $('#dateSummary').click(function(e) {
            e.preventDefault();
            var currentQueryParams = premodalQueryParams;
            // var currentQueryParams = klp.router.getHash().queryParams;
            // _.each(_.keys(currentQueryParams), function(key) {
            //     currentQueryParams[key] = null;
            // });
            var startDate = $('#startDate').yearMonthSelect("getDate");
            var endDate = $('#endDate').yearMonthSelect("getDate");
            if (moment(startDate) > moment(endDate)) {
                klp.utils.alertMessage("End date must be after start date", "error");
                return false;
            }
            currentQueryParams['from'] = $('#startDate').yearMonthSelect("getDate");
            currentQueryParams['to'] = $('#endDate').yearMonthSelect("getDate");
            //console.log("currentQueryParams", currentQueryParams);
            klp.router.setHash(null, currentQueryParams);
            //hashChanged({'queryParams':currentQueryParams});
        });

        $('a[href=#datemodal]').click(function(e) {
            premodalQueryParams = klp.router.getHash().queryParams;
            return true;
        });

        $('a[href=#close]').click(function(e) {
            klp.router.setHash(null, premodalQueryParams, {'trigger': false});
        });

        $('a[href=#searchmodal]').click(function(e) {
            premodalQueryParams = klp.router.getHash().queryParams;
            return true;
        });
    }
    // Not sure if this function is needed anymore.
    function hashChanged(params) {
        //FIXME: clear all the things, do a loading state.
        var queryParams = params.queryParams;
        if (!queryParams.school_type) {
            loadData(schoolString, queryParams);
            $('#primarySchoolContainer').show();
        } else {
            queryParams.school_type = window.decodeURIComponent(queryParams.school_type);
            loadData(queryParams.school_type, queryParams);
        }
        $('#primarySchoolContainer').show();
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
            if (premodalQueryParams.hasOwnProperty("from")) {
                hashParams['from'] = premodalQueryParams['from'];
            }
            if (premodalQueryParams.hasOwnProperty("to")) {
                hashParams['to'] = premodalQueryParams['to'];
            }
            klp.router.setHash(null, hashParams);
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

    function fillSelect2(entityDetails) {
        if (entityDetails.name == '') {
            $('#select2search').select2("data", null);
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
        $('#select2search').select2("data", dataObj);
    }

    function loadData(schoolType, params) {
        //var params = klp.router.getHash().queryParams;
        console.log(schoolType);
        var DEFAULT_START_YEAR = 2010;
        var DEFAULT_END_YEAR = (new Date()).getFullYear();
        var metaURL = "stories/meta/?source=ivrs&version=2&version=4&version=5";
        var entityDeferred = fetchEntityDetails(params);
        params['school_type'] = schoolType;
        startSummaryLoading(schoolType);
        entityDeferred.done(function(entityDetails) {
            fillSelect2(entityDetails);
            params['school_type'] = schoolType;
            var $metaXHR = klp.api.do(metaURL, params);
            $metaXHR.done(function(data) {
                stopSummaryLoading(schoolType);
                data.searchEntity = entityDetails;
                data.year_from = params.hasOwnProperty('from') ? getYear(params.from) : DEFAULT_START_YEAR;
                data.year_to = params.hasOwnProperty('to') ? getYear(params.to) : DEFAULT_END_YEAR;
                renderSummary(data, schoolType);
                //renderRespondentChart(data, schoolType);
            });
        });

        
          
        var detailURL = "stories/details/?source=ivrs&version=2&version=4&version=5";
        var $detailXHR = klp.api.do(detailURL, params);
        startDetailLoading(schoolType);
        $detailXHR.done(function(data) {
            stopDetailLoading(schoolType);
            renderIVRS(data, schoolType);
        });

        startVolumeLoading(schoolType);
        var volumeURL = "stories/volume/?source=ivrs&version=2&version=4&version=5";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            stopVolumeLoading(schoolType);
            renderIVRSVolumeChart(data, schoolType);
        });

        startTlmLoading(schoolType);
        var tlmURL = "stories/volume/?source=ivrs&version=2&version=4&version=5&response_type=gka-class";
        //var tlmURL = "/api/v1/stories/volume/?source=ivrs&version=2&version=4&version=5&response_type=gka-class&format=json";
        var $tlmXHR = klp.api.do(tlmURL, params);
        $volumeXHR.done(function(data) {
            stopTlmLoading(schoolType);
            renderTlmTable(data, schoolType);
        });


    }

    function startSummaryLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-summary-container').startLoading();
    }

    function startDetailLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-detail-container').startLoading();        
    }

    function startVolumeLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-volume-container').startLoading();         
    }

    function startTlmLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-tlm-container').startLoading();         
    }

    function stopSummaryLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-summary-container').stopLoading();
    }

    function stopDetailLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-detail-container').stopLoading();  
    }

    function stopVolumeLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-volume-container').stopLoading();       
    }

    function stopTlmLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-tlm-container').stopLoading();         
    }

    function getYear(dateString) {
        return dateString.split("-")[0];
    }

    $.fn.startLoading = function() {
        var $this = $(this);
        var $loading = $('<div />').addClass('fa fa-cog fa-spin loading-icon-base js-loading');
        $this.empty().append($loading);
    }

    $.fn.stopLoading = function() {
        var $this = $(this);
        $this.find('.js-loading').remove();
    }

    function getContainerDiv(schoolType) {
        if (schoolType === preschoolString) {
            return $('#preschoolContainer');
        } else {
            return $('#primarySchoolContainer');
        }        
    }

    function renderRespondentChart(data, schoolType) {
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
        var suffix = '';
        if (schoolType == preschoolString)
            suffix = '_ang';
        renderBarChart('#chart_respondent' + suffix, data_respondent);

    }

    function renderIVRSVolumeChart(data, schoolType) {
        var years = _.keys(data.volumes);
        var latest = Math.max.apply(Math,years);
        var earliest = Math.min.apply(Math,years);
        var months = _.keys(data.volumes[latest]);
        var tplIvrsYear = swig.compile($('#tpl-ivrsVolume').html());
        var ivrsVolTitle = tplIvrsYear({"acad_year":earliest + "-" + latest});
        $('#ivrsyears').html(ivrsVolTitle);
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
        var suffix = '';
        if (schoolType == preschoolString) {
            suffix = '_ang';
        }
        renderBarChart('#chart_ivrs' + suffix, data_ivrs);
    }


    function renderBarChart(elementId, data) {

        var options = {
            seriesBarDistance: 10,
            axisX: {
                showGrid: false,
            },
            axisY: {
                showGrid: false,
            },
            plugins: [
                Chartist.plugins.tooltip()
            ]
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
                    style: 'stroke-width: 15px;'
                });
            }
            if (data.type === 'label' && data.axis === 'x') {
                data.element.attr({
                    width: 200
                })
            }
        });
    }

    function renderSummary(data, schoolType) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplIvrsSummary = swig.compile($('#tpl-ivrsSummary').html());
        var suffix = '';
        var summaryLabel = "Schools";

        
        var searchEntityType = data.searchEntity.type;
        var isSchool = [schoolString, preschoolString].indexOf(searchEntityType) !== -1 ? true : false; 

        //if search is for a school, do some specific things:
        if (isSchool) {
            //make summary label singular
            summaryLabel = summaryLabel.substring(0, summaryLabel.length - 1);            
        }

        var summaryData = data;
        summaryData['school_type'] = summaryLabel;
        var topSummaryHTML = tplTopSummary(summaryData);
        var ivrsSummaryHTML = tplIvrsSummary(summaryData);
        $('#topSummary').html(topSummaryHTML);
        $('#ivrsSummary').html(ivrsSummaryHTML);

        if (isSchool) {
            //hide summary boxes for 'total schools' and 'total schools with stories'
            $('.js-hide-school').css("visibility", "hidden");                
        } else {
            //if this is not a school, make sure total schools, etc. is visible.
            $('.js-hide-school').css("visibility", "visible");
        }

    }

    

    function renderIVRS(data, schoolType) {
        // var tplClassGraph = swig.compile($('#tpl-classGraph').html());
        // var ivrs_class = 'ivrss-gka-tlm';
        // var classQuestion = getQuestion(data, 'ivrs', ivrs_class);
        // var classAnswers = classQuestion.answers;
        // var total = getTotal(classAnswers);
        // var score2 = getScore(classAnswers, "2");
        // var score3 = getScore(classAnswers, "3");
        // var score4 = getScore(classAnswers, "4");
        // var score5 = getScore(classAnswers, "4");
        // var classes = [{
        //     'value': 'Class 2',
        //     'score': score2,
        //     'total': total,
        //     'percent': getPercent(score2, total),
        //     'color': 'green-leaf'
        // }, {
        //     'value': 'Class 3',
        //     'score': score3,
        //     'total': total,
        //     'percent': getPercent(score3, total),
        //     'color': 'orange-mild'
        // }, {
        //     'value': 'Class 4',
        //     'score': score4,
        //     'total': total,
        //     'percent': getPercent(score4, total),
        //     'color': 'pink-salmon'
        // }, {
        //     'value': 'Class 5',
        //     'score': score5,
        //     'total': total,
        //     'percent': getPercent(score5, total),
        //     'color': 'green-pista'
        // }];

        // var html = ''
        // for (var pos in classes) {
        //     html = html + "<div class='chart-quarter-item'>" + tplClassGraph(classes[pos]) + "</div>";
        // }

        // $('#ivrsclasses').html(html);


        var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
        //define your data
        
        var IVRSQuestionKeys = [];
        if (schoolType == schoolString)
        {
            IVRSQuestionKeys = [
                'ivrss-school-open',
                "ivrss-math-class-happening",
                "ivrss-gka-trained",
                "ivrss-gka-tlm-in-use",
                "ivrss-multi-tlm",
                "ivrss-gka-rep-stage",
                "ivrss-children-use-square-line",
                "ivrss-group-work",
                'ivrss-toilets-condition',
                'ivrss-functional-toilets-girls'
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

        var questions = getQuestionsArray(questionObjects);

        var html = '<div class="chart-half-item">'
        for (var pos in questions) {
            if (pos > (questions.length/2)-1)
                html = html + "</div><div class='chart-half-item'>";
            html = html + tplPercentGraph(questions[pos]);
        }
        html = html + "</div>"
        $('#ivrsquestions').html(html);
    }

    function renderTlmTable(data, schoolType) {
        console.log("response   ");
        console.log(data);
        data = {
                    "volumes": {
                        "2016": {
                            "Jan": {
                                "2": [15],
                                "3": [20],
                                "4": [16, 12, 14],
                                "5": [4, 6, 7, 9, 10, 18],
                                "6": [20, 5]
                            },
                            "Feb": {},
                            "Mar": {},
                            "Apr": {},
                            "May": {},
                            "Jun": {},
                            "Jul": {},
                            "Aug": {},
                            "Sep": {},
                            "Oct": {},
                            "Nov": {},
                            "Dec": {}
                        },
                        "2015": {
                            "Jan": {},
                            "Feb": {},
                            "Mar": {},
                            "Apr": {},
                            "May": {},
                            "Jun": {},
                            "Jul": {
                                "4": [3, 7, 8, 16, 19, 20],
                                "5": [2, 5]
                            },
                            "Aug": {
                                "5": [3, 4, 5, 9, 12, 14]
                            },
                            "Sep": {
                                "4": [1, 2, 3, 4, 5, 7, 8, 12, 15, 17, 20],
                                "5": [1, 2, 3, 4, 7, 8, 12, 13, 14, 15, 16, 20]
                            },
                            "Oct": {
                                "4": [8, 2, 3, 4],
                                "5": [3, 4]
                            },
                            "Nov": {},
                            "Dec": {}
                        }
                    }
                }
        console.log("hardcoded   ");
        console.log(data);
        var transform = {
            "Jan": {},
            "Feb": {}, 
            "Mar": {}, 
            "Apr": {}, 
            "May": {}, 
            "Jun": {}, 
            "Jul": {}, 
            "Aug": {}, 
            "Sep": {}, 
            "Oct": {}, 
            "Nov": {}, 
            "Dec": {}
        }
        var gradeNames = {
            "1":"one","2":"two","3":"three","4":"four","5":"five","6":"six","7":"seven"
        }
        for (var year in data["volumes"]){
            for (var month in data["volumes"][year]) {
                if(_.keys(data["volumes"][year][month]).length > 0){
                    for (var grade in data["volumes"][year][month]) {
                        if (transform[month][gradeNames[grade]] == undefined)
                            transform[month][gradeNames[grade]] = []
                        for (var tlm in data["volumes"][year][month][grade]){
                            if(data["volumes"][year][month][grade][tlm] in transform[month][gradeNames[grade]])
                            {}
                            else {    
                                transform[month][gradeNames[grade]].push(data["volumes"][year][month][grade][tlm]);
                            }
                        }
                    }
                }
            }
        }
        var tplTlmTable = swig.compile($('#tpl-tlmTable').html());
        var html = tplTlmTable({"months":transform});
        $('#ivrstlmsummary').html(html);
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
        if (!paramKey) {
            setTimeout(function() {
                $deferred.resolve({
                    'type': '',
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