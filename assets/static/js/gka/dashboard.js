/* vi:si:et:sw=4:sts=4:ts=4 */
'use strict';
var districts = {"meta":[],'details':[]};
var entity = {"meta":[],'details':[]};
var entityDetails = {};
var topSummaryData = {};

(function() {
    var premodalQueryParams = {};
    
    klp.init = function() {
        klp.accordion.init();
        klp.gka_filters.init();
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.events.on('hashchange', function(event, params) {
            hashChanged(params);
        });
        klp.router.start();

        $('#startDate').yearMonthSelect("init");
        $('#endDate').yearMonthSelect("init");

        //this is a bit of a hack to save query state when
        //triggering a modal, since modals over-ride the url
        //Works only on date modal.
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

        $('#dateSummary').click(function(e) {
            e.preventDefault();
            var currentQueryParams = premodalQueryParams;
            var startDate = $('#startDate').yearMonthSelect("getFirstDay");
            var endDate = $('#endDate').yearMonthSelect("getLastDay");
            if (moment(startDate) > moment(endDate)) {
                klp.utils.alertMessage("End date must be after start date", "error");
                return false;
            }
            currentQueryParams['from'] = $('#startDate').yearMonthSelect("getFirstDay");
            currentQueryParams['to'] = $('#endDate').yearMonthSelect("getLastDay");
            klp.router.setHash(null, currentQueryParams);
        });

        $('a[href=#datemodal]').click(function(e) {
            premodalQueryParams = klp.router.getHash().queryParams;
        });

        $('a[href=#close]').click(function(e) {
            klp.router.setHash(null, premodalQueryParams, {'trigger': false});
        });

        $('a[href=#searchmodal]').click(function(e) {
            premodalQueryParams = klp.router.getHash().queryParams;
        });
        loadData(premodalQueryParams);
    }

    function hashChanged(params) {
        var queryParams = params.queryParams;
        //This is for the default URL localhost:8001/gka 
        //No Query Params
        if(window.location.hash)
        {
            //This is a reload of localhost:8001/gka 
            //No Query Params
            if(window.location.hash == '#resetButton') {
                window.location.href = '/gka';
            }
            //This is to prevent server calls when just the modal actions are called
            //This condition is triggered for eg: for localhost:8001/gka#datemodal?from=12/03/2016&to12/06/2016
            //and not for just localhost:8001/gka#datemodal
            else if(window.location.hash != '#datemodal' && window.location.hash !='#close' && window.location.hash != '#searchmodal')
            {
                loadData(queryParams)
            } 
            //This is the do nothing case switch for localhost:8001/gka#datemodal
            else {//do nothing;
            }
        }
        $('#ReportContainer').show();
    }

    function loadData(params) {
        loadTopSummary(params);
        loadSmsData(params);
        loadAssmtData(params);
        loadGPContestData(params);
        loadSurveys(params);
        loadComparison(params);
    }

    function loadComparison(params) {
        var neighbours = [
            {"name":"neighbour1","schools":99,"sms":200,"sms_govt":50,"assmt":200,'contests':5,'surveys':30},
            {"name":"neighbour2","schools":98,"sms":210,"sms_govt":40,"assmt":240,'contests':6,'surveys':40},
            {"name":"neighbour3","schools":96,"sms":220,"sms_govt":30,"assmt":250,'contests':6,'surveys':20},
            {"name":"neighbour4","schools":95,"sms":230,"sms_govt":20,"assmt":210,'contests':10,'surveys':50}
        ]
        var tplComparison= swig.compile($('#tpl-compareTable').html());
        var compareHTML = tplComparison({"neighbours":neighbours});
        $('#compareTable').html(compareHTML);
        renderComparisonCharts(params);
    }

    function renderComparisonCharts(params){
        var meta_values = {
        "n1": [{"meta":"neighbour1","value":10,"skill":"A"},
            {"meta":"neighbour1","value":60,"skill":"S"},
            {"meta":"neighbour1","value":60,"skill":"M"},
            {"meta":"neighbour1","value":40,"skill":"D"}],
        "n2":[{"meta":"neighbour2","value":20,"skill":"A"},
            {"meta":"neighbour2","value":40,"skill":"S"},
            {"meta":"neighbour2","value":50,"skill":"M"},
            {"meta":"neighbour2","value":60,"skill":"D"}],
        "n3":[{"meta":"neighbour3","value":40,"skill":"A"},
            {"meta":"neighbour3","value":30,"skill":"S"},
            {"meta":"neighbour3","value":40,"skill":"M"},
            {"meta":"neighbour3","value":50,"skill":"D"}],
        "n4":[{"meta":"neighbour4","value":20,"skill":"A"},
            {"meta":"neighbour4","value":40,"skill":"S"},
            {"meta":"neighbour4","value":20,"skill":"M"},
            {"meta":"neighbour4","value":50,"skill":"D"}]
        };
        var competencies = {
            labels: ["Addition","Subtraction","Multiplication","Division"],
            series: [
                { 
                    className: 'ct-series-f',
                    data: meta_values["n1"]
                },
                { 
                    className: 'ct-series-a',
                    data: meta_values["n2"]
                },
                { 
                    className: 'ct-series-g',
                    data: meta_values["n3"]
                },
                { 
                    className: 'ct-series-o',
                    data: meta_values["n4"]
                }
            ],
        }
        renderBarChart('#compareAssmtGraph', competencies, "Percentage of Children");
        renderBarChart('#compareGpcGraph',competencies, "Percentage of Children");
    }

    function loadSmsData(params) {
        var metaURL = "stories/meta/?source=sms";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) 
        {
            renderSmsSummary(data);
        });

        //GETTING SMS DETAILS
        var detailURL = "stories/details/?source=sms";
        var $detailXHR = klp.api.do(detailURL, params);
        $detailXHR.done(function(data) {
            stopDetailLoading();
            renderSMS(data);
        });
        renderSMSCharts(params);
    }

    function loadSurveys(params) {
        var metaURL = "stories/meta/?source=mobile";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) 
        {
            renderSurveySummary(data);
            renderRespondentChart(data);
        });
        
        var volumeURL = "stories/volume/?source=mobile";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            renderVolumeChart(data);
        });

        var detailURL = "stories/details/?source=mobile";
        var $detailXHR = klp.api.do(detailURL, params);
        $detailXHR.done(function(data) {
            renderSurveyQuestions(data);
        });
    }

    function renderVolumeChart(data) {
        var years = _.keys(data.volumes);
        var latest = Math.max.apply(Math,years);
        var earliest = latest-1;
        var prev_months = _.keys(data.volumes[earliest]);
        var new_months = _.keys(data.volumes[latest]);
        var month_labels = [];
        var meta_values = [];
        for (var i = 5; i < 12; i++)
        {
            meta_values.push({'meta':prev_months[i]+" "+earliest,
                'value':data.volumes[earliest][prev_months[i]]})
            month_labels.push(prev_months[i]+" "+earliest);
        }
        for (var i = 0; i < 5; i++)
        {
            meta_values.push({'meta':new_months[i]+" "+latest,
                'value':data.volumes[latest][new_months[i]]})
            month_labels.push(new_months[i]+" "+latest);
        }
        //console.log(meta_values);
        var data = {
            labels: month_labels,
            series: [
                { 
                    className: 'ct-series-a',
                    data: meta_values,
                }
            ]
        };
        renderLineChart('#mobVolume', data);
    }

    function renderRespondentChart(data) {
        var labelMap = {
            'SDMC_MEMBER': 'SDMC',
            'CBO_MEMBER': 'CBO',
            'PARENTS': 'Parent',
            'TEACHERS': 'Teacher',
            'VOLUNTEER': 'Volunteer',
            'EDUCATED_YOUTH': 'Youth',
            'LOCAL_LEADER': 'Leader',
            'AKSHARA_STAFF': 'Akshara',
            'ELECTED_REPRESENTATIVE': 'Elected' 
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
        renderBarChart('#mobRespondent', data_respondent);

    }

    function renderSurveyQuestions(data) {
        var questionKeys = [];
        questionKeys = [
            "mob-sdmc-meet",
            "mob-subtraction",
            "mob-addition",
            "mob-read-english",
            "mob-read-kannada",
            "mob-teacher-shortage",
            "mob-mdm-satifactory",
            "ivrss-functional-toilets-girls"
        ];
        
        var questionObjects = _.map(questionKeys, function(key) {
            return getQuestion(data, 'mobile', key);
        });
        var questions = getQuestionsArray(questionObjects);
        //var regroup = {}
        var tplResponses = swig.compile($('#tpl-mobResponses').html());
        // for (var each in questions)
        //     regroup[questions[each]["key"]] = questions[each];
        var html = tplResponses({"questions":questions})
        $('#surveyQuestions').html(html);
    }

    function renderSurveySummary(data) {
        var tplMobSummary = swig.compile($('#tpl-mobSummary').html());
        var summaryData = data;
        summaryData["format_lastmobile"] = formatLastStory(summaryData["mobile"]["last_story"]);
        var mobSummaryHTML = tplMobSummary(summaryData);
        $('#surveySummary').html(mobSummaryHTML);
    }


    function loadTopSummary(params) {
        var metaURL = "stories/meta/";
        var $metaXHR = klp.api.do(metaURL, params);
        startSummaryLoading();
        $metaXHR.done(function(data) 
        {
            var topSummary = data.top_summary
            window.topSummaryData = topSummary
            renderTopSummary(topSummary);
        });
    }

    function renderTopSummary(topSummary) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var topSummaryHTML = tplTopSummary({"data": topSummary});
        stopSummaryLoading(); 
        $('#topSummary').html(topSummaryHTML);
    }

    function renderSmsSummary(data) {
        var tplSmsSummary = swig.compile($('#tpl-smsSummary').html());
        var summaryData = data;
        summaryData["format_lastsms"] = formatLastStory(summaryData["sms"]["last_story"]);
        var smsSummaryHTML = tplSmsSummary(summaryData);
        $('#smsSummary').html(smsSummaryHTML);
    }


    function renderSMS(data) {
        var SMSQuestionKeys = [];
        SMSQuestionKeys = [
            "ivrss-gka-trained",
            "ivrss-math-class-happening",
            "ivrss-gka-tlm-in-use",
            "ivrss-gka-rep-stage",
            "ivrss-group-work"
        ];
        
        var questionObjects = _.map(SMSQuestionKeys, function(key) {
            return getQuestion(data, 'sms', key);
        });
        var questions = getQuestionsArray(questionObjects);
        var regroup = {}
        var tplResponses = swig.compile($('#tpl-smsResponses').html());
        for (var each in questions)
            regroup[questions[each]["key"]] = questions[each];
        var html = tplResponses({"questions":regroup})
        $('#smsQuestions').html(html);
    }

    function renderSMSCharts(params) {
        var meta_values = [
            {"meta":"CRP","value":130},
            {"meta":"Field Staff","value": 100},
            {"meta":"BEO","value":20},
            {"meta":"Volunteer","value":35}
        ];
        var sms_sender = {
            labels: ["CRP","Field Staff","BEO","Volunteer"],
            series: [
                { 
                    className: 'ct-series-b',
                    data: meta_values,
                }
            ],
        }
        renderBarChart('#smsSender', sms_sender);

        var volume_values = [
            {"meta":"Jun 2016","value":10},
            {"meta":"Jul 2016","value":20},
            {"meta":"Aug 2016","value":30},
            {"meta":"Sep 2016","value":10},
            {"meta":"Oct 2016","value":40},
            {"meta":"Nov 2016","value":50},
            {"meta":"Dec 2016","value":20},
            {"meta":"Jan 2017","value":30},
            {"meta":"Feb 2017","value":20},
            {"meta":"Mar 2017","value":10}
        ];

        var sms_volume = {
            labels: ["Jun 2016","Jul 2016","Aug 2016","Sep 2016","Oct 2016","Nov 2016","Dec 2016","Jan 2017","Feb 2017","Mar 2017"],
            series: [
                { 
                    className: 'ct-series-b',
                    data: volume_values,
                },
                {
                    className: 'ct-series-h',
                    data: [60,60,60,60,60,60,60,60,60,60,60]  
                }
            ]
        }
        renderLineChart('#smsVolume', sms_volume);
        $('#smsLegend').html("<div class='center-text font-small uppercase'><span class='fa fa-circle brand-turquoise'></span>"+
                        " Expected Volumes <span class='fa fa-circle brand-green'></span> Actual Volumes</div>");   


    }

    function loadAssmtData(params) {
        var metaURL = "assessment/?ekstep_gka=true";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) {
            var topSummary = window.topSummaryData
            var tot_schools = topSummary.total_schools
            var gka_schools = topSummary.gka_schools
            var schools_perc = parseInt((gka_schools/tot_schools) * 100)
            var children = data.summary.children
            var children_impacted = topSummary.children_impacted
            var children_perc = parseInt((children/children_impacted) * 100)
            var last_assmt = new Date(data.summary.last_assmt)
            var dataSummary = {
                "count": data.summary.count,
                "schools": gka_schools,
                "schools_perc": schools_perc,
                "children": children,
                "children_perc": children_perc,
                "last_assmt": last_assmt.toDateString(),
            }
            renderAssmtSummary(dataSummary);
            renderAssmtCharts(data);
        });

        var metaURL = "stories/volume/?response_type=gka";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) {
            renderAssmtVolumeChart(data)
        });
    }
    
    function renderAssmtSummary(data) {
        var tplAssmtSummary = swig.compile($('#tpl-assmtSummary').html());
        var assmtSummaryHTML = tplAssmtSummary({'assmt':data});
        $('#assmtSummary').html(assmtSummaryHTML);
        var tplAssmtCoverage = swig.compile($('#tpl-assmtCoverage').html());
        var assmtCoverageHTML = tplAssmtCoverage({'assmt':data});
        $('#assmtCoverage').html(assmtCoverageHTML);
           
    }

    function renderAssmtCharts(data) {
        var scores = data.scores
        var meta_values = [
            {"meta":"Addition","value":parseInt((scores.Addition.score/scores.Addition.total) * 100)},
            {"meta":"Area of shape","value":parseInt((scores['Area of shape'].score/scores['Area of shape'].total) * 100)},
            {"meta":"Carryover","value":parseInt((scores.Carryover.score/scores.Carryover.total) * 100)},
            {"meta":"Decimals","value":parseInt((scores.Decimals.score/scores.Decimals.total) * 100)},
            {"meta":"Division","value":parseInt((scores.Division.score/scores.Division.total) * 100)},
            {"meta":"Division fact","value":parseInt((scores['Division fact'].score/scores['Division fact'].total) * 100)},
            {"meta":"Double digit","value":parseInt((scores['Double digit'].score/scores['Double digit'].total) * 100)},
            {"meta":"Fractions","value":parseInt((scores.Fractions.score/scores.Fractions.total) * 100)},
            {"meta":"Place value","value":parseInt((scores['Place value'].score/scores['Place value'].total) * 100)},
            {"meta":"Regrouping with money","value":parseInt((scores['Regrouping with money'].score/scores['Regrouping with money'].total) * 100)},
            {"meta":"Relationship between 3D shapes","value":parseInt((scores["Relationship between 3D shapes"].score/scores["Relationship between 3D shapes"].total) * 100)},
            {"meta":"Subtraction","value":parseInt((scores.Subtraction.score/scores.Subtraction.total) * 100)},
            {"meta":"Word problems","value":parseInt((scores['Word problems'].score/scores['Word problems'].total) * 100)}
        ];
        var competencies = {
            labels: ["Addition","Area of shape","Carryover","Decimals","Division","Division fact","Double digit","Fractions","Place value","Regrouping with money","3D Shapes","Subtraction","Word problems"],
            series: [
                { 
                    className: 'ct-series-i',
                    data: meta_values,
                    //distributed_series:true
                }
            ],
        }
        renderBarChart('#assmtCompetancy', competencies, "Percentage of Children");
    }

    function renderAssmtVolumeChart(data) {
        var volumes = data.volumes
        var volume_values = [
            {"meta":"Jun 2016","value":volumes['2016'].Jun},
            {"meta":"Jul 2016","value":volumes['2016'].Jul},
            {"meta":"Aug 2016","value":volumes['2016'].Aug},
            {"meta":"Sep 2016","value":volumes['2016'].Sep},
            {"meta":"Oct 2016","value":volumes['2016'].Oct},
            {"meta":"Nov 2016","value":volumes['2016'].Nov},
            {"meta":"Dec 2016","value":volumes['2016'].Dec},
            {"meta":"Jan 2017","value":volumes['2017'].Jan},
            {"meta":"Feb 2017","value":volumes['2017'].Feb},
            {"meta":"Mar 2017","value":volumes['2017'].Mar}
        ];

        var assmt_volume = {
            labels: ["Jun 2016","Jul 2016","Aug 2016","Sep 2016","Oct 2016","Nov 2016","Dec 2016","Jan 2017","Feb 2017","Mar 2017"],
            series: [
                { 
                    className: 'ct-series-g',
                    data: volume_values,
                },
                {
                    className: 'ct-series-d',
                    data: [60,60,60,60,60,60,60,60,60,60,60]  
                }
            ]
        }
        renderLineChart('#assmtVolume', assmt_volume);
        $('#avLegend').html("<div class='center-text font-small uppercase'><span class='fa fa-circle brand-orange'></span>"+
                        " Expected Volumes <span class='fa fa-circle pink-salmon'></span> Actual Volumes</div>");   

    }

    function loadGPContestData(params){
        var data = {
            "summary": { "schools":148,
                "gps": 20,
                "contests":20,
                "children": 2000
            },
            "Class 4": { "boy_perc":40,"girl_perc":50,"overall_perc":45 },
            "Class 5": { "boy_perc":30,"girl_perc":20,"overall_perc":25 },
            "Class 6": { "boy_perc":20,"girl_perc":10,"overall_perc":15 }
        }
        
        var tplSummary = swig.compile($('#tpl-gpcSummary').html());
        var summaryHTML = tplSummary({"data":data["summary"]});
        $('#gpcSummary').html(summaryHTML);

        tplSummary = swig.compile($('#tpl-genderGpcSummary').html());
        summaryHTML = tplSummary({"data":data["Class 4"]});
        $('#gpcGender_class4').html(summaryHTML);

        tplSummary = swig.compile($('#tpl-genderGpcSummary').html());
        summaryHTML = tplSummary({"data":data["Class 5"]});
        $('#gpcGender_class5').html(summaryHTML);

        tplSummary = swig.compile($('#tpl-genderGpcSummary').html());
        summaryHTML = tplSummary({"data":data["Class 6"]});
        $('#gpcGender_class6').html(summaryHTML);
        renderGPContestCharts(params);
    }


    function renderGPContestCharts(params) {
        var meta_values = [
            {"meta":"Number Concepts","value":50},
            {"meta":"Addition","value":50},
            {"meta":"Subtraction","value":40},
            {"meta":"Multiplication","value":30},
            {"meta":"Division","value":25},
            {"meta":"Patterns","value":10},
            {"meta":"Shapes and Spatial Understanding","value":5},
            {"meta":"Fractions","value":20},
            {"meta":"Decimal","value":10},
            {"meta":"Measurement - weight and time","value":50}
        ];
        var competencies = {
            labels: ["Number Concepts","Addition","Subtraction","Multiplication","Division","Patterns","Shapes","Fractions","Decimal","Measurement"],
            series: [
                { 
                    className: 'ct-series-n',
                    data: meta_values,
                    //distributed_series:true
                }
            ]
        }
        renderBarChart('#gpcGraph_class4', competencies, "Percentage of Children");
        renderBarChart('#gpcGraph_class5', competencies, "Percentage of Children");
        renderBarChart('#gpcGraph_class6', competencies, "Percentage of Children");
    }

    function renderBarChart(elementId, data, yTitle=' ') {

        var options = {
            //seriesBarDistance: 10,
            axisX: {
                showGrid: true,
            },
            axisY: {
                showGrid: true,
            },
            plugins: [
                Chartist.plugins.tooltip(),
                Chartist.plugins.ctAxisTitle({
                  axisX: {
                    //No label
                  },
                  axisY: {
                    axisTitle: yTitle,
                    axisClass: 'ct-axis-title',
                    offset: {
                      x: 0,
                      y: 0
                    },
                    textAnchor: 'middle',
                    flipTitle: false
                  }
                })
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

    function renderLineChart(elementId, data) {

        var options = {
            seriesBarDistance: 10,
            axisX: {
                showGrid: true,
            },
            axisY: {
                showGrid: true,
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

        var $chart_element = Chartist.Line(elementId, data, options, responsiveOptions).on('draw', function(data) {
            // if (data.type === 'bar') {
            //     data.element.attr({
            //         style: 'stroke-width: 15px;'
            //     });
            // }
            if (data.type === 'label' && data.axis === 'x') {
                data.element.attr({
                    width: 200
                })
            }
        });
    }



    /*
        Helper functions
            TODO: move to separate file and document.
     */
    function startSummaryLoading() {
        var $container = $('#ReportContainer');
        $container.find('.js-summary-container').startLoading();
    }

    function startDetailLoading() {
        var $container = $('#ReportContainer');
        $container.find('.js-detail-container').startLoading();        
    }

    function stopSummaryLoading(schoolType) {
        var $container = $('#ReportContainer');
        $container.find('.js-summary-container').stopLoading();
    }

    function stopDetailLoading(schoolType) {
        var $container = $('#ReportContainer');
        $container.find('.js-detail-container').stopLoading();  
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

    function formatLastStory(last_story) {
        var date =' ';
        var time = ' ';
        if(last_story != null) {
            if(last_story.indexOf('T') != -1) {
                var arr = last_story.split('T');
                date = moment(arr[0], "YYYY-MM-DD").format("DD MMM YYYY");
                time += moment(arr[1], "HH:mm:ss").format("h:mm:ss a");
            } else {
                date = moment(last_story, "YYYY-MM-DD").format("DD MMM YYYY");
            }
        }
        return date + time;        
    }

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
                'key':question.question.key,
                'score': score,
                'total': total,
                'percent': percent
            };
        });
    }

})();