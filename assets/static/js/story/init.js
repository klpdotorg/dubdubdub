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
            var startDate = $('#startDate').yearMonthSelect("getFirstDay");
            var endDate = $('#endDate').yearMonthSelect("getLastDay");
            if (moment(startDate) > moment(endDate)) {
                klp.utils.alertMessage("End date must be after start date", "error");
                return false;
            }
            currentQueryParams['from'] = $('#startDate').yearMonthSelect("getFirstDay");
            currentQueryParams['to'] = $('#endDate').yearMonthSelect("getLastDay");
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

    function hashChanged(params) {
        //FIXME: clear all the things, do a loading state.
        var queryParams = params.queryParams;
        if (!queryParams.school_type) {
            loadData(preschoolString, queryParams);
            loadData(schoolString, queryParams);
            $('#preschoolContainer').show();
            $('#primarySchoolContainer').show();
        } else {
            queryParams.school_type = window.decodeURIComponent(queryParams.school_type);
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
        var DEFAULT_START_YEAR = 2010;
        var DEFAULT_END_YEAR = (new Date()).getFullYear();
        var metaURL = "stories/meta";
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
                renderRespondentChart(data, schoolType);
            });
        });

        var detailURL = "stories/details/";
        var $detailXHR = klp.api.do(detailURL, params);
        startDetailLoading(schoolType);
        $detailXHR.done(function(data) {
            stopDetailLoading(schoolType);
            renderFeatured(data, schoolType);
            renderIVRS(data, schoolType);
            renderWeb(data, schoolType);
            if (schoolType == schoolString) {
                renderSurvey(data); // Community Surveys currently not done in Anganwadis
            }
            //renderComparison(data);
        });

        startVolumeLoading(schoolType);
        var volumeURL = "stories/volume/?source=ivrs";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            stopVolumeLoading(schoolType);
            renderIVRSVolumeChart(data, schoolType);
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
        // var year = new Date().getFullYear(); //FIXDB: Object.keys(data.volumes)[Object.keys(data.volumes).length-1];
        // var prev = parseInt(year) - 1 
        // var months = data.volumes[String(year)]; //FIXME: deal with with academic year.
        // var prevmonths = null;
        // if(String(prev) in Object.keys(data.volumes))
        //     prevmonths = data.volumes[String(prev)];
        // var tplIvrsYear = swig.compile($('#tpl-ivrsVolume').html());
        // var ivrsVolTitle = tplIvrsYear({"acad_year":prev + "-" + year});
        // $('#ivrsyears').html(ivrsVolTitle);
        // var meta_values = [];
        // var labels = _.keys(months);
        // var values = _.values(months);
        // var prev_values = null;
        // if(prevmonths != null)
        //     prev_values = _.values(prevmonths)
        // for( var i=0; i < labels.length; i++) {
        //     meta_values.push({'meta': labels[i],'value': values[i] + (prev_values==null?0:prev_values[i])});
        // } /* chartist tooltip transformations */ 
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

    function formatLastStory(last_story, ignoreTime) {
        var date =' ';
        var time = ' ';
        if(last_story != null) {
            if(ignoreTime == false && last_story.indexOf('T') != -1) {
                var arr = last_story.split('T');
                date = moment(arr[0], "YYYY-MM-DD").format("DD MMM YYYY");
                time += moment(arr[1], "HH:mm:ss").format("h:mm:ss a");
            } else {
                date = moment(last_story, "YYYY-MM-DD").format("DD MMM YYYY");
            }
        }
        return date + time;        
    }

    function renderSummary(data, schoolType) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var suffix = '';
        var summaryLabel = "Schools";

        if (schoolType == preschoolString) {
            summaryLabel = "Preschools";
            suffix = '_ang';
        }
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
        $('#topSummary' + suffix).html(topSummaryHTML);

        if (isSchool) {
            //hide summary boxes for 'total schools' and 'total schools with stories'
            $('.js-hide-school').css("visibility", "hidden");                
        } else {
            //if this is not a school, make sure total schools, etc. is visible.
            $('.js-hide-school').css("visibility", "visible");
        }

        var tplCountSummary = swig.compile($('#tpl-countSummary').html());  
        var summaries = {
            'ivrs': [{
                'label': summaryLabel,
                'count': data.total.schools
            }, {
                'label': summaryLabel + ' with Surveys',
                'count': data.ivrs.schools
            }, {
                'label': 'Calls received',
                'count': data.ivrs.stories
            }, {
                'label': 'Last Call',
                'count': (schoolType == preschoolString)?formatLastStory(data.ivrs.last_story, true):formatLastStory(data.ivrs.last_story, false)
            }
            /*, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }*/],
            'survey': [{
                'label': summaryLabel,
                'count': data.total.schools
            }, {
                'label': summaryLabel + ' with Surveys',
                'count': data.community.schools
            }, {
                'label': 'Surveys',
                'count': data.community.stories
            }, {
                'label': 'Last Survey',
                'count': formatLastStory(data.community.last_story, true)
            }/*, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }*/],
            'web': [{
                'label': summaryLabel,
                'count': data.total.schools
            }, {
                'label': summaryLabel + ' with Surveys',
                'count': data.web.schools
            }, {
                'label': 'Verified Surveys',
                'count': data.web.verified_stories
            }, {
                'label': 'Last Story',
                'count': formatLastStory(data.web.last_story, true)
            }/*, {
                'label': 'Academic Year',
                'count': '2015-2016'
            }*/]
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
                'ivrss-toilets-condition',
                "ivrss-classes-proper",
                "ivrss-functional-toilets-girls",
                "ivrss-drinking-water",
                "ivrss-midday-meal",
                "ivrss-teacher-present"
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

        
        // var tplColorText = swig.compile($('#tpl-colorText').html());

        // var facilityQuestions = [];
        // if ( schoolType == schoolString ) {
        //     facilityQuestions = [{
        //         'facility': 'All weather pucca building',
        //         'icon': ['fa fa-university'],
        //         'key': 'webs-pucca-building'
        //     }, {
        //         'facility': 'Playground',
        //         'icon': ['fa fa-futbol-o'],
        //         'key': 'webs-playground'
        //     }, {
        //         'facility': 'Drinking Water',
        //         'icon': ['fa  fa-tint'],
        //         'key': 'webs-drinking-water'
        //     }, {
        //         'facility': 'Library',
        //         'icon': ['fa fa-book'],
        //         'key': 'webs-library'
        //     }, {
        //         'facility': 'Toilets',
        //         'icon': ['fa fa-male', 'fa fa-female'],
        //         'key': 'webs-separate-toilets'
        //     }, {
        //         'facility': 'Secure Boundary Wall',
        //         'icon': ['fa fa-circle-o-notch'],
        //         'key': 'webs-boundary-wall'
        //     }];
        // } else {
        //     facilityQuestions = [{
        //         'facility': 'A proper designated building',
        //         'icon': ['fa fa-university'],
        //         'key': 'weba-proper-building'
        //     }, {
        //         'facility': 'Play Material',
        //         'icon': ['fa fa-futbol-o'],
        //         'key': 'weba-play-material'
        //     }, {
        //         'facility': 'Drinking Water',
        //         'icon': ['fa  fa-tint'],
        //         'key': 'weba-drinking-water'
        //     }, {
        //         'facility': 'Healthy and timely meal',
        //         'icon': ['fa fa-spoon'],
        //         'key': 'weba-food-ontime'
        //     }, {
        //         'facility': 'Toilets',
        //         'icon': ['fa fa-male', 'fa fa-female'],
        //         'key': 'weba-toilet'
        //     }, {
        //         'facility': 'Secure Boundary Wall',
        //         'icon': ['fa fa-circle-o-notch'],
        //         'key': 'weba-boundary-security'
        //     }];
        // }

        // var questionObjects = _.map(facilityQuestions, function(question) {
        //     return getQuestion(data, 'web', question.key);
        // });

        // var questionsArray = getQuestionsArray(questionObjects);


        // var facilities = _.map(questionsArray, function(question, seq) {
        //     var facility = facilityQuestions[seq];
        //     facility.percent = question.percent;
        //     facility.total = question.total;
        //     return facility;
        // });

        // var html = '';

        // _.each(facilities, function(f) {
        //     html = html + tplColorText(f);
        // });
        // /*
        // for (var i=0, len=facilities.length;pos in facilities) {
        //     html = html + tplColorText(facilities[pos]);
        // }
        // */
        // $('#webfacilities' + suffix).html(html);

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