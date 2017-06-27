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
        var url = "stories/details/?gka_comparison=true";
        var $metaXHR = klp.api.do(url, params);
        startDetailLoading();
        $metaXHR.done(function(data) 
        {
            var neighbours = _.map(data.summary_comparison, function(summary){
                return {
                    name: summary.boundary_name,
                    schools: summary.schools,
                    sms: summary.sms,
                    sms_govt: summary.sms_govt,
		    sms_govt_percent: getPercent(summary.sms_govt, summary.sms),
                    assmt: summary.assessments,
                    contests: summary.contests,
                    surveys: summary.surveys
                }
            });
            var tplComparison= swig.compile($('#tpl-compareTable').html());
            var compareHTML = tplComparison({"neighbours":neighbours});
            $('#compareTable').html(compareHTML);
            renderComparisonCharts(params, data);
            stopDetailLoading();
        });
    }

    function renderComparisonCharts(params, data){

        function getSkillValue(skills, skillType, dataType) {
            var value;

            if (dataType === 'ekstep') {
                if(skills.competencies[skillType]) {
                    var total = skills.competencies[skillType].total,
                        score = skills.competencies[skillType].score;
                    value = score / total * 100;
                } else {
                    value = 0;
                }
            } else {
                for(var s in skills.competencies) {
                    var yes = 0, no = 0;
                    for(var i = 1; i <= 5; i++) {
                        if(skills.competencies[skillType + ' ' + i]) {
                            if(skills.competencies[skillType + ' ' + i].Yes && skills.competencies[skillType + ' ' + i].No) {
                                    yes += skills.competencies[skillType + ' ' + i].Yes;
                                    no += skills.competencies[skillType + ' ' + i].No;
                            }
                        }
                    }
                }
                value = yes / (yes + no) * 100;
            }

            if(value) { return value.toFixed(2); } else { return 0; }
        }
        
        function getNValues(section, dataType) {
            var addition = getSkillValue(section, 'Addition'),
                subtraction = getSkillValue(section, 'Subtraction'),
                multiplication = getSkillValue(section, 'Multiplication'),
                division = getSkillValue(section, 'Division');
            return [{
                meta: section.boundary_name,
                skill: 'Addition',
                value: getSkillValue(section, 'Addition', dataType)
            },{
                meta: section.boundary_name,
                skill: 'Subtraction',
                value: getSkillValue(section, 'Subtraction', dataType)
            },{
                meta: section.boundary_name,
                skill: 'Multiplication',
                value: getSkillValue(section, 'Multiplication', dataType)
            },{
                meta: section.boundary_name,
                skill: 'Division',
                value: getSkillValue(section, 'Division', dataType)
            }];
        };

        function getMetaValues(dataType) {
            var metaValues = {};
            for(var i = 1; i <= 4; i++) {
                if(!data.competency_comparison[i-1]) {
                    metaValues['n' + i] = [];
                } else {
                    var ekstepData = data.competency_comparison[i-1][0].type === dataType ? data.competency_comparison[i-1][0] : data.competency_comparison[i-1][1]; 
                    metaValues['n' + i] = getNValues(ekstepData, dataType);
                }
            }
            return metaValues;
        }

        var ekstepValues = getMetaValues('ekstep'),
            gpContestValues = getMetaValues('gp_contest');

        var ekstepCompetencies = {
            labels: ["Addition","Subtraction","Multiplication","Division"],
            series: [
                { 
                    className: 'ct-series-f',
                    data: ekstepValues["n1"]
                },
                { 
                    className: 'ct-series-a',
                    data: ekstepValues["n2"]
                },
                { 
                    className: 'ct-series-g',
                    data: ekstepValues["n3"]
                },
                { 
                    className: 'ct-series-o',
                    data: ekstepValues["n4"]
                }
            ],
        }

        var gpContestCompetencies = {
            labels: ["Addition","Subtraction","Multiplication","Division"],
            series: [
                { 
                    className: 'ct-series-f',
                    data: gpContestValues["n1"]
                },
                { 
                    className: 'ct-series-a',
                    data: gpContestValues["n2"]
                },
                { 
                    className: 'ct-series-g',
                    data: gpContestValues["n3"]
                },
                { 
                    className: 'ct-series-o',
                    data: gpContestValues["n4"]
                }
            ],
        }

        renderBarChart('#compareAssmtGraph', ekstepCompetencies, "Percentage of Children");
        renderBarChart('#compareGpcGraph', gpContestCompetencies, "Percentage of Children");
    }

    function loadSmsData(params) {
        var metaURL = "stories/meta/?source=sms";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) {
            renderSmsSummary(data);
        });


        //GETTING SMS DETAILS
        var detailURL = "stories/details/?source=sms";
        var $detailXHR = klp.api.do(detailURL, params);
        $detailXHR.done(function(data) {
            stopDetailLoading();
            renderSMS(data);
        });

        // SMS Volume
        var volumeURL = "stories/volume/?source=sms";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            stopDetailLoading();
            renderSMSCharts(data, params);
        });
    }

    function loadSurveys(params) {
        var metaURL = "stories/meta/?survey=Community&source=csv";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) 
        {
            renderSurveySummary(data);
            renderRespondentChart(data);
        });
        
        var volumeURL = "stories/volume/?survey=Community&source=csv";
        var $volumeXHR = klp.api.do(volumeURL, params);
        $volumeXHR.done(function(data) {
            renderVolumeChart(data);
        });

        var detailURL = "stories/details/?survey=Community&source=csv";
        var $detailXHR = klp.api.do(detailURL, params);
        $detailXHR.done(function(data) {
            renderSurveyQuestions(data);
        });
    }

    function renderVolumeChart(data) {
        var $noDataAlert = $('#survey-volume-chart-no-render-alert');
        var $mobVolume = $('#mobVolume');
        var years = _.keys(data.volumes);
        var latest = Math.max.apply(Math,years);
        var earliest = latest-1;
        var prev_months = _.keys(data.volumes[earliest]);
        var new_months = _.keys(data.volumes[latest]);
        var month_labels = [];
        var meta_values = [];

        $noDataAlert.hide();
        $mobVolume.show();

        for (var i = 5; i < 12; i++)
        {
            if(data.volumes[earliest]) {
                meta_values.push({
                    'meta': prev_months[i] + " " + earliest,
                    'value': data.volumes[earliest][prev_months[i]]
                });
                month_labels.push(prev_months[i] + " " + earliest);
            }
        }
        for (var i = 0; i < 5; i++)
        {
            if(data.volumes[latest]) {
                meta_values.push({
                    'meta': new_months[i] + " " + latest,
                    'value': data.volumes[latest][new_months[i]]
                });
                month_labels.push(new_months[i] + " " + latest);
            }
        }

        if(!meta_values.length) {
            $noDataAlert.show();
            $mobVolume.hide();
            return;
        }

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
            'SDMC_Member': 'SDMC',
            'CBO_Member': 'CBO',
            'Parents': 'Parent',
            'Teachers': 'Teacher',
            'Volunteer': 'Volunteer',
            'Educated_Youth': 'Youth',
            'Local Leader': 'Leader',
            'Akshara_Staff': 'Akshara',
            'Elected_Representative': 'Elected' ,
            'Children': 'Children'
        };

        var labels = _.values(labelMap);
        
        var respondents = data.respondents;
        var meta_values = [];
        for ( var label in labelMap) {
            meta_values.push({'meta': labelMap[label], 'value': respondents[label] || 0})
        }

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
            "mob-mdm-satisfactory",
            "ivrss-functional-toilets-girls"
        ];
        
        var questionObjects = _.map(questionKeys, function(key) {
            return getQuestion(data, 'csv', key);
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
        var tplCsvSummary = swig.compile($('#tpl-csvSummary').html());
        data["format_lastcsv"] = formatLastStory(data["csv"]["last_story"]);
        data['schoolPerc'] = getPercent(data.csv.schools, window.topSummaryData.gka_schools);
        var csvSummaryHTML = tplCsvSummary(data);
        $('#surveySummary').html(csvSummaryHTML);
    }


    function loadTopSummary(params) {
        var metaURL = "stories/meta/?top_summary=true";
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
        
        // Percentage
        if (summaryData.sms.schools && summaryData.sms.stories) {
            summaryData['smsPercentage'] = (summaryData.sms.schools / summaryData.sms.stories * 100).toFixed(2);
        } else {
            summaryData['smsPercentage'] = 0;
        }

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

    function renderSMSCharts(data, params)  {
        var meta_values = [];

        var expectedValue = 13680;
        if(typeof(params.admin1) !== 'undefined') {
            expectedValue = 2280;
        } else if(typeof(params.school_id) !== 'undefined' || typeof(params.admin2) !== 'undefined' || typeof(params.admin3) !== 'undefined') {
            expectedValue = 0;
        }

        function prepareVolumes(year) {
            var values = [];

            for(var v in data.volumes[year]) {
                values.push({
                    meta: v + ' ' + year,
                    value: data.volumes[year][v]
                });
            }
            return values;
        }

        for (var m in data.user_groups) {
            if(m) {
                meta_values.push({
                    meta: m,
                    value: data.user_groups[m]
                });
            }
        }   

        var sms_sender = {
            labels: _.map(meta_values, function(m){ return m.meta; }),
            series: [
                { 
                    className: 'ct-series-b',
                    data: meta_values,
                }
            ],
        }
        renderBarChart('#smsSender', sms_sender);

        var volume_values = prepareVolumes('2016');
        volume_values = volume_values.concat(prepareVolumes('2017'));

        if(!volume_values.length) {
            return;
        }

        if (volume_values.length > 12) {
            volume_values.splice(0, 6);
            volume_values.splice(-6);
        }


        var sms_volume = {
            labels: _.map(volume_values, function(v){ return v.meta }),
            series: [
                { 
                    className: 'ct-series-b',
                    data: volume_values,
                },
                {
                    className: 'ct-series-h',
                    data: _.map(volume_values, function(v){ return expectedValue; })  
                }
            ]
        }

        var chartLabel = '';

        if(!expectedValue) {
            sms_volume.series = [sms_volume.series[0]];
            chartLabel = "<div class='center-text font-small uppercase'>" +
                        "<span class='fa fa-circle brand-green'></span> Actual Volumes</div>"
        } else {
            chartLabel = "<div class='center-text font-small uppercase'><span class='fa fa-circle brand-turquoise'></span>"+
                        " Expected Volumes <span class='fa fa-circle brand-green'></span> Actual Volumes</div>"
        }

        renderLineChart('#smsVolume', sms_volume);
        $('#smsLegend').html(chartLabel);   


    }

    function loadAssmtData(params) {
        var metaURL = "assessment/?ekstep_gka=true";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) {
            var topSummary = window.topSummaryData
            var tot_gka_schools = topSummary.gka_schools
            var schools_assessed = data.summary.schools
            var schools_perc = getPercent(schools_assessed, tot_gka_schools)
            var children = data.summary.children
            var children_impacted = topSummary.children_impacted
            var children_perc = getPercent(children, children_impacted)
            var last_assmt = data.summary.last_assmt
            var dataSummary = {
                "count": data.summary.count,
                "schools": schools_assessed,
                "schools_perc": schools_perc,
                "children": children,
                "children_perc": children_perc,
                "last_assmt": formatLastStory(last_assmt)
            }
            renderAssmtSummary(dataSummary);
            renderAssmtCharts(data);
        });

        var metaURL = "stories/volume/?response_type=gka";
        var $metaXHR = klp.api.do(metaURL, params);
        startDetailLoading();
        $metaXHR.done(function(data) {
            renderAssmtVolumeChart(data, params);
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
        function getAssmtPerc(scores, topic) {
            return getPercent(scores[topic].score, scores[topic].total)
        }
        var scores = data.scores
        var meta_values = [
            {"meta":"Addition","value": getAssmtPerc(scores, 'Addition')},
            {"meta":"Area of shape","value": getAssmtPerc(scores, 'Area of shape')},
            {"meta":"Carryover","value": getAssmtPerc(scores, 'Carryover')},
            {"meta":"Decimals","value": getAssmtPerc(scores, 'Decimals')},
            {"meta":"Division","value": getAssmtPerc(scores, 'Division')},
            {"meta":"Division fact","value": getAssmtPerc(scores, 'Division fact')},
            {"meta":"Double digit","value": getAssmtPerc(scores, 'Double digit')},
            {"meta":"Fractions","value": getAssmtPerc(scores, 'Fractions')},
            {"meta":"Place value","value": getAssmtPerc(scores, 'Place value')},
            {"meta":"Regrouping with money","value": getAssmtPerc(scores, 'Regrouping with money')},
            {"meta":"Relationship between 3D shapes", "value": getAssmtPerc(scores, 'Relationship between 3D shapes')},
            {"meta":"Subtraction","value": getAssmtPerc(scores, 'Subtraction')},
            {"meta":"Word problems","value":getAssmtPerc(scores, 'Word problems')}
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

    function renderAssmtVolumeChart(data, params) {
        var volumes = data.volumes;

       var expectedValue = 6800;
        if(typeof(params.admin1) !== 'undefined') {
            expectedValue = 1100;
        } else if(typeof(params.school_id) !== 'undefined' || typeof(params.admin2) !== 'undefined' || typeof(params.admin3) !== 'undefined') {
            expectedValue = 0;
        }

        var volume_values = [
            {"meta":"Jun 2016","value":volumes['2016'] ? volumes['2016'].Jun : 0 },
            {"meta":"Jul 2016","value":volumes['2016'] ? volumes['2016'].Jul : 0 },
            {"meta":"Aug 2016","value":volumes['2016'] ? volumes['2016'].Aug : 0 },
            {"meta":"Sep 2016","value":volumes['2016'] ? volumes['2016'].Sep : 0 },
            {"meta":"Oct 2016","value":volumes['2016'] ? volumes['2016'].Oct : 0 },
            {"meta":"Nov 2016","value":volumes['2016'] ? volumes['2016'].Nov : 0 },
            {"meta":"Dec 2016","value":volumes['2016'] ? volumes['2016'].Dec : 0 },
            {"meta":"Jan 2017","value":volumes['2017'] ? volumes['2017'].Jan : 0 },
            {"meta":"Feb 2017","value":volumes['2017'] ? volumes['2017'].Feb : 0 },
            {"meta":"Mar 2017","value":volumes['2017'] ? volumes['2017'].Mar : 0 }
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
                    data: [expectedValue,expectedValue,expectedValue,expectedValue,expectedValue,expectedValue,expectedValue,expectedValue,expectedValue,expectedValue,expectedValue]  
                }
            ]
        }
    
        var chartLabel = '';
        if(!expectedValue) {
            assmt_volume.series = [assmt_volume.series[0]];
            chartLabel = "<div class='center-text font-small uppercase'>"+
                        "<span class='fa fa-circle pink-salmon'></span> Actual Volumes</div>"
        } else {
            chartLabel = "<div class='center-text font-small uppercase'><span class='fa fa-circle brand-orange'></span>"+
                        " Expected Volumes <span class='fa fa-circle pink-salmon'></span> Actual Volumes</div>"
        }

        renderLineChart('#assmtVolume', assmt_volume);
        $('#avLegend').html(chartLabel);   

    }

    function loadGPContestData(params){
        var metaURL = "stories/details/?survey=GP%20Contest";
        var $metaXHR = klp.api.do(metaURL, params);
        $metaXHR.done(function(data) {
            var dataSummary = {
                "summary": {
                    "schools":data.summary.schools,
                    "gps": data.summary.gps,
                    "contests":data.summary.contests,
                    "children": data.summary.students
                },
                "Class 4": {
                    "boy_perc": getPercent(data['4'].males_score, data['4'].males),
                    "girl_perc": getPercent(data['4'].females_score, data['4'].females),
                    "total_studs": getPercent(
                        data['4'].males_score + data['4'].females_score,
                        data['4'].males+data['4'].females
                    )
                },
                "Class 5": {
                    "boy_perc": getPercent(data['5'].males_score, data['5'].males),
                    "girl_perc": getPercent(data['5'].females_score, data['5'].females),
                    "total_studs": getPercent(
                        data['5'].males_score + data['5'].females_score,
                        data['5'].males + data['5'].females
                    )
                },
                "Class 6": {
                    "boy_perc": getPercent(data['6'].males_score, data['6'].males),
                    "girl_perc": getPercent(data['6'].females_score, data['6'].females),
                    "total_studs": getPercent(
                        data['6'].males_score + data['6'].females_score,
                        data['6'].males + data['6'].females
                    )
                }
            }
            
            var tplSummary = swig.compile($('#tpl-gpcSummary').html());
            var summaryHTML = tplSummary({"data": dataSummary["summary"]});
            $('#gpcSummary').html(summaryHTML);

            tplSummary = swig.compile($('#tpl-genderGpcSummary').html());
            summaryHTML = tplSummary({"data":dataSummary["Class 4"]});
            $('#gpcGender_class4').html(summaryHTML);

            tplSummary = swig.compile($('#tpl-genderGpcSummary').html());
            summaryHTML = tplSummary({"data":dataSummary["Class 5"]});
            $('#gpcGender_class5').html(summaryHTML);

            tplSummary = swig.compile($('#tpl-genderGpcSummary').html());
            summaryHTML = tplSummary({"data":dataSummary["Class 6"]});
            $('#gpcGender_class6').html(summaryHTML);

            renderGPContestCharts(data);
        })
    }


    function renderGPContestCharts(data) {
        function aggCompetancies(competancies) {
            var topics = ["Number concept","Addition","Subtraction","Multiplication","Division","Patterns","Shapes","Fractions","Decimal","Measurement"]
            var competanciesKeys = Object.keys(competancies)
            var result = {}
            for (var topic of topics) {
                result[topic] = {'Yes': 0, 'No': 0}

                for (var key of competanciesKeys) {
                    if (key.indexOf(topic) !== -1) {
                        result[topic]['Yes'] += competancies[key]['Yes']
                        result[topic]['No'] += competancies[key]['No']
                    }
                }
            }
            return result
        }

        var class4competancies = genCompetancyChartObj(aggCompetancies(data['4'].competancies));
        var class5competancies = genCompetancyChartObj(aggCompetancies(data['5'].competancies));
        var class6competancies = genCompetancyChartObj(aggCompetancies(data['6'].competancies));
        renderBarChart('#gpcGraph_class4', class4competancies, "Percentage of Children");
        renderBarChart('#gpcGraph_class5', class5competancies, "Percentage of Children");
        renderBarChart('#gpcGraph_class6', class6competancies, "Percentage of Children");
    }

    function genCompetancyChartObj(aggCompetancies) {
        function getTopicPerc(competancy){
            var yesVal = competancy['Yes'], noVal = competancy['No']
            return getPercent(yesVal, yesVal+noVal)
        }
        var meta_values = [
            {"meta":"Number Concepts", "value": getTopicPerc(aggCompetancies['Number concept'])},
            {"meta":"Addition","value": getTopicPerc(aggCompetancies['Addition'])},
            {"meta":"Subtraction","value": getTopicPerc(aggCompetancies['Subtraction'])},
            {"meta":"Multiplication","value": getTopicPerc(aggCompetancies['Multiplication'])},
            {"meta":"Division","value": getTopicPerc(aggCompetancies['Division'])},
            {"meta":"Patterns","value": getTopicPerc(aggCompetancies['Patterns'])},
            {"meta":"Shapes and Spatial Understanding","value":getTopicPerc(aggCompetancies['Shapes'])},
            {"meta":"Fractions","value": getTopicPerc(aggCompetancies['Fractions'])},
            {"meta":"Decimal","value": getTopicPerc(aggCompetancies['Decimal'])},
            {"meta":"Measurement - weight and time","value":getTopicPerc(aggCompetancies['Measurement'])}
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
        return competencies
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

        var $chart_element = Chartist.Bar(elementId, data, options, responsiveOptions).on('draw', function(chartData) {
            if (chartData.type === 'bar') {
                chartData.element.attr({
                    style: 'stroke-width: 15px;'
                });
            }
            if (chartData.type === 'label' && chartData.axis === 'x') {
                chartData.element.attr({
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
        if (!answers) { return 0; }
        return _.reduce(_.keys(answers.options), function(memo, answerKey) {
            return memo + answers.options[answerKey];
        }, 0);
    }

    function getPercent(score, total) {
        if (total == 0 || score == 0) {
            return 0;
        }
        return parseFloat((score / total) * 100).toFixed(2);
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
            var questionObj = question.question;
            return {
                'question': questionObj? questionObj.display_text: '',
                'key': questionObj? questionObj.key: '',
                'score': score,
                'total': total,
                'percent': percent
            };
        });
    }

})();
