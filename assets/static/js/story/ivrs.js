/* vi:si:et:sw=4:sts=4:ts=4 */
'use strict';
(function() {
    var preschoolString = 'PreSchool';
    var schoolString = 'Primary School';
    var premodalQueryParams = {};
    var districts = {"meta":[],'details':[]};
    var entity = {"meta":[],'details':[]};

    klp.init = function() {
        klp.gka_filters_modal.init();
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

        $('#searchModal').click(function(e) {
            e.preventDefault();
            klp.gka_filters_modal.open();
        });

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
    }

    function hashChanged(params) {
        var queryParams = params.queryParams;
        //This is for the default URL localhost:8001/gka 
        //No Query Params
        if(!window.location.hash)
        {
            loadData(schoolString, {});
        }
        else
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
                loadData(schoolString, queryParams)
            } 
            //This is the do nothing case switch for localhost:8001/gka#datemodal
            else {//do nothing;
            }
        }
        $('#primarySchoolContainer').show();
    }

    function loadData(schoolType, params) {
        /*
        CASE 1:     /gka
        CASE 2:     /gka#reset (Redirect to above)
        CASE 3:X    /gka#close (This function is not called)
        CASE 4:X    /gka#datemodal (This function is not called)
        CASE 5:     /gka#datemodal&from=12/06/2016&to=12/08/2016
        CASE 6:X    /gka#searchmodal (This function is not called)
        CASE 8:     /gka#searchmodal&admin3
        CASE 9:     /gka#searchmodal&admin1
        CASE 10:    /gka#searchmodal&admin3&from&to
        CASE 11:    /gka#searchmodal&admin1&from&to
        */
        // FOR CASE 8,9,10,11 - Getting Entity Details
        var entityDetails = getEntityDetails(params);
        // FOR CASE 10 & 11, initializing only date parameters
        var date_params = {}
        if(params.hasOwnProperty('from'))
            date_params['from'] = params['from'];
        if(params.hasOwnProperty('to'))
            date_params['to'] = params['to'];
    
        //GETTING SMS META
        var metaURL = "stories/meta/?source=sms";
        startSummaryLoading(schoolType);
        var $metaXHR = klp.api.do(metaURL, params);
        $metaXHR.done(function(data) {
            stopSummaryLoading(schoolType);
            data.searchEntity = entityDetails;
            entity["meta"] = data;
            if(entityDetails['district'] != null) {
                var districtMetaURL = "stories/meta/?source=sms&admin1="+entityDetails["district"]["id"]
                var $districtMetaXHR = klp.api.syncDo(districtMetaURL, date_params);
                $districtMetaXHR.done(function(meta){
                    districts["meta"] = meta;
                    districts["meta"]["sms"]["name"] = entityDetails["district"]["name"];        
                    renderSummary();
                });
            } else {
                districts = {};
                renderSummary();
            }
        });
               
        //GETTING SMS DETAILS
        var detailURL = "stories/details/?source=sms";
        var $detailXHR = klp.api.do(detailURL, params);
        startDetailLoading(schoolType);
        $detailXHR.done(function(data) {
            stopDetailLoading(schoolType);
            entity["details"] = data;
            if(entityDetails['district'] != null) {
                var districtURL = "stories/details/?source=sms&admin1="+entityDetails["district"]["id"]
                var $districtXHR = klp.api.syncDo(districtURL, date_params);
                $districtXHR.done(function(details){
                    districts["details"]=details
                    renderIVRS();
                });
            } else {
                districts = {};
                renderIVRS();
            }
        });
    }

    function getEntityDetails(params) {
        var entityInfo = {'entity_type':'All',}
        var entityType = 'All'
        if(_.keys(params).length > 0){
            if(params.hasOwnProperty('admin1'))
                entityType = 'admin1';
            if(params.hasOwnProperty('admin2'))
                entityType = 'admin2';
            if(params.hasOwnProperty('admin3'))
                entityType = 'admin3';
            if(entityType != 'All') {
                var $adminXHR = klp.api.do('boundary/admin/'+ params[entityType]);
                $adminXHR.done(function(entity) {
                    entityInfo['entity'] = entity;
                    entityInfo['entity_type'] = entity.type;
                    if(entity.parent!=null) {
                        if(entity.parent.type == 'block') {
                            var $blockXHR = klp.api.syncDo('boundary/admin/'+entity.parent.id);
                            $blockXHR.done(function(blk) {
                                entityInfo['district'] = blk.parent;
                            });
                        }
                        else {
                            entityInfo['district'] = entity.parent;
                        }
                    }
                    else{
                        entityInfo['district'] = null;
                    }
                });
            }
            if(params.hasOwnProperty('school_id')){
                var $schoolXHR = klp.api.syncDo('schools/school/'+params['school_id']);
                $schoolXHR.done(function(school) {
                    entityInfo['entity'] = school;
                    entityInfo['entity_type'] = 'Primary School';
                    entityInfo['district'] = school.admin1;
                });
            }
        }
        return entityInfo;
        
    }

    function renderSummary() {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplIvrsSummary = swig.compile($('#tpl-smsSummary').html());
        var searchEntityType = entity['meta'].searchEntity.entity_type;
        var isSchool = [schoolString, preschoolString].indexOf(searchEntityType) !== -1 ? true : false; 
        var summaryData = entity["meta"];
        console.log(searchEntityType);
        if (searchEntityType != 'All') {
            summaryData['searchEntity']["type"] = summaryData.searchEntity.entity_type;
            summaryData['searchEntity']['name'] = summaryData.searchEntity.entity.name;
        }
        summaryData["last_story"] = formatLastStory(summaryData["sms"]["last_story"]);
        if(_.keys(districts).length >0) {
            summaryData['district'] = districts["meta"]["sms"];
            summaryData['district']["entity_type"] = districts["meta"]["sms"].name + ' (District)';
            summaryData["district"]["last_story"] = formatLastStory(districts["meta"]["sms"]["last_story"]);
        }
        var topSummaryHTML = tplTopSummary(summaryData);
        var smsSummaryHTML = tplIvrsSummary(summaryData);
        $('#topSummary').html(topSummaryHTML);
        $('#smsSummary').html(smsSummaryHTML);

        if (isSchool) {
            //hide summary boxes for 'total schools' and 'total schools with stories'
            $('.js-hide-school').css("visibility", "hidden");                
        } else {
            //if this is not a school, make sure total schools, etc. is visible.
            $('.js-hide-school').css("visibility", "visible");
        }
    }

    

    function renderIVRS() {
        var tplResponses = swig.compile($('#tpl-responseTable').html());
        //define your data
        
        var IVRSQuestionKeys = [];
        IVRSQuestionKeys = [
            "ivrss-gka-trained",
            "ivrss-math-class-happening",
            "ivrss-gka-tlm-in-use",
            "ivrss-gka-rep-stage",
            "ivrss-group-work"
        ];
        
        var questionObjects = _.map(IVRSQuestionKeys, function(key) {
            return getQuestion(entity['details'], 'sms', key);
        });
        var questions = getQuestionsArray(questionObjects);
        var districtQuestions = null;
        if (_.keys(districts).length > 0) {
            var districtQuestionsObjects = _.map(IVRSQuestionKeys, function(key) {
                return getQuestion(districts['details'], 'sms', key);
            });
            districtQuestions = getQuestionsArray(districtQuestionsObjects);
            for(var i in questions) {
                for(var j in districtQuestions) {
                    if(districtQuestions[j].question == questions[i].question)
                        questions[i]['district'] = districtQuestions[j]
                }
            }
        }
        var html = tplResponses({"questions":questions})
        $('#smsquestions').html(html);
    }


    function startSummaryLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-summary-container').startLoading();
    }

    function startDetailLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-detail-container').startLoading();        
    }

    function stopSummaryLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
        $container.find('.js-summary-container').stopLoading();
    }

    function stopDetailLoading(schoolType) {
        var $container = getContainerDiv(schoolType);
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

    function getContainerDiv(schoolType) {
        if (schoolType === preschoolString) {
            return $('#preschoolContainer');
        } else {
            return $('#primarySchoolContainer');
        }        
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