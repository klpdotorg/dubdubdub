/* vi:si:et:sw=4:sts=4:ts=4 */
'use strict';
var districts = {"meta":[],'details':[]};
var entity = {"meta":[],'details':[]};
var entityDetails = {};
(function() {
    var premodalQueryParams = {};
    
    klp.init = function() {
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



    function loadTopSummary(params) {
        var data = {
            "total_schools": 15000,
            "gka_schools":14854,
            "children_impacted": 2000000,
            "tlm_kits":14854,
            "teachers_trained": 14000,
            "education_volunteers":200
        }
        startSummaryLoading();
        
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var topSummaryHTML = tplTopSummary({"data":data});
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
        var tplResponses = swig.compile($('#tpl-responseTable').html());
        //define your data
        
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
        var html = tplResponses({"questions":questions})
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
                }
            ]
        }
        renderLineChart('#smsVolume', sms_volume);

    }

    function loadAssmtData(params) {
        //var metaURL = "stories/meta/?source=sms";
        //var $metaXHR = klp.api.do(metaURL, params);
        // startDetailLoading();
        // $metaXHR.done(function(data) 
        // {
        var data = {
            "count": 2000,
            "schools":148,
            "schools_perc":10,
            "children": 2000,
            "children_perc":5,
            "last_assmt":'30 Jan 2017 2:35:42 pm'
        }
     
        renderAssmtSummary(data);

        //});

        renderAssmtCharts(params);
    }

    
    function renderAssmtSummary(data) {
        var tplAssmtSummary = swig.compile($('#tpl-assmtSummary').html());
        var assmtSummaryHTML = tplAssmtSummary({'assmt':data});
        $('#assmtSummary').html(assmtSummaryHTML);
    }

    function renderAssmtCharts(params) {
        var meta_values = [
            {"meta":"Addition","value":10},
            {"meta":"Area of shape","value":20},
            {"meta":"Carryover","value":50},
            {"meta":"Decimals","value":10},
            {"meta":"Division","value":40},
            {"meta":"Division fact","value":60},
            {"meta":"Double digit","value":50},
            {"meta":"Fractions","value":90},
            {"meta":"Place value","value":80},
            {"meta":"Regrouping with money","value":70},
            {"meta":"Subtraction","value":60},
            {"meta":"Word problems","value":60}
        ];
        var competancies = {
            labels: ["Addition","Area of shape","Carryover","Decimals","Division","Division fact","Double digit","Fractions","Place value","Regrouping with money","Subtraction","Word problems"],
            series: [
                { 
                    //className: 'ct-series-b',
                    data: meta_values,
                    distributed_series:true
                }
            ],
        }
        renderBarChart('#assmtCompetancy', competancies);

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

        var assmt_volume = {
            labels: ["Jun 2016","Jul 2016","Aug 2016","Sep 2016","Oct 2016","Nov 2016","Dec 2016","Jan 2017","Feb 2017","Mar 2017"],
            series: [
                { 
                    className: 'ct-series-g',
                    data: volume_values,
                },
                {
                    className: 'ct-series-i',
                    data: [60,60,60,60,60,60,60,60,60,60,60]  
                }
            ]
        }
        renderLineChart('#assmtVolume', assmt_volume);

    }


    function renderBarChart(elementId, data) {

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
                'score': score,
                'total': total,
                'percent': percent
            };
        });
    }

})();