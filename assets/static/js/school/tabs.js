'use strict';
(function() {
    var t = klp.tabs = {};
    var templates = {};
    var dataCache = {};
    var schoolInfoURL;
    var tabs;
    var currentTab;
    var container_width = 960;
    var chart_gradient_param = [0, 0, 0, 300];
    var schoolType;

    t.init = function() {
        $('.js-tab-link').each(function() {
            var $this = $(this);
            var $clone = $this.clone();
            var tabName = $this.attr("data-tab");
            $('.tab-content[data-tab=' + tabName + ']').before($clone);
        });
        schoolInfoURL = 'schools/school/' + SCHOOL_ID;
        schoolType = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
        tabs = {
            'info': {
                getData: function() {
                    return klp.api.do(schoolInfoURL);
                },
                getContext: function(data) {
                    data.type_name = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
                    return data;
                },
                onRender: function(data) {
                    $('.rbox_img_gal').rbox({
                        'type': 'image',
                        'series': 'image_gallery'
                    });
                }
            },
            'demographics': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/demographics');
                },
                getContext: function(data) {
                    var d = klp.utils.addSchoolContext(data);
                    d.dise = klp.utils.getBoyGirlPercents(data.num_boys_dise, data.num_girls_dise);
                    d.type_name = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
                    return d;
                },
                onRender: function(data) {
                    if (!data.num_boys && !data.num_girls) {
                        //console.log("no boy-girl data!");
                        $('.no-data.js-klp').show();
                        $('#boygirlChartWrapper').hide();
                    } else {
                        $('#num_students_piechart').boyGirlChart(data);
                    }

                    if (!data.num_boys_dise && !data.num_girls_dise) {
                        $('.no-data.js-dise').show();
                        $('#boygirlChartWrapperDISE').hide();
                    } else {
                        $('#num_students_piechart_dise').boyGirlChart(data.dise);
                    }
                }
            },
            'programmes': {
                getData: function() {
                    return klp.api.do('programme/', {
                        'school': SCHOOL_ID
                    });
                },
                getContext: function(data) {
                    var programmes = data.features;
                    return {
                        'programmes': programmes,
                        'school_id': SCHOOL_ID
                    };
                }
            },
            'finances': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/finance');
                },
                getContext: function(data) {
                    data.sg_amount = data.sg_amount ? data.sg_amount : 0;
                    data.smg_amount = data.smg_amount ? data.smg_amount : 0;
                    data.tlm_amount = data.tlm_amount ? data.tlm_amount : 0;
                    data.total_amount = data.sg_amount + data.smg_amount + data.tlm_amount;
                    data.type_name = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
                    return data;
                },
                onRender: function(data) {
                    var container_width = $(document).find(".container:first").width();
                    var chartData = klp.utils.getFinancePercents(data);
                    var chartOptions = {
                        width: container_width,
                        height: 200,
                        innerSize: '60%'
                    };
                    $('#pie_chart_finance').financeChart(chartData, chartOptions);
                }
            },
            'infrastructure': {
                getData: function() {
                    if (SCHOOL_TYPE_ID === 2) { //is a preschool
                        return klp.api.do(schoolInfoURL + '/infrastructure');
                    }
                    //for primary schools, fetch infra data from DISE
                    if (DISE_CODE) {
                        return klp.dise_api.fetchSchoolInfra(DISE_CODE);
                    } else {
                        var $deferred = $.Deferred();
                        setTimeout(function() {
                            $deferred.resolve({});
                        }, 0);
                        return $deferred;
                    }
                },
                getContext: function(data) {
                    data.type_name = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
                    if (SCHOOL_TYPE_ID === 1) {
                        if (data.hasOwnProperty('properties')) {
                            data = data.properties;
                            data.facilities = klp.dise_infra.getFacilitiesData(data);
                        } else {
                            data.facilities = null;
                        }
                    }
                    return data;
                }
            },
            'library': {
                getData: function() {
                    var $deferred = $.Deferred();
                    var $klpXHR = klp.api.do(schoolInfoURL + "/library");
                    $klpXHR.done(function(data) {
                        var $diseXHR = klp.dise_api.fetchSchoolInfra(DISE_CODE);
                        $diseXHR.done(function(diseData)  {
                            data.dise_books = diseData.properties.books_in_library;
                            $deferred.resolve(data);
                        });
                        $diseXHR.fail(function(err) {
                            $deferred.resolve(data);
                        });
                    });
                    return $deferred;
                },

                getContext: function(data) {
                    // Step 0: Check if library data exists.
                    data.years = [];
                    data.klasses = [];
                    data.lib_borrow_agg.forEach(function (element, index) {
                        data.years.push(element.trans_year);
                        data.klasses.push(element.class_name);
                    });
                    _.each(data.lib_lang_agg, function(element, index) {
                        element.forEach(function(element, index) {
                            data.years.push(element.year);
                            data.klasses.push(element.class_name);
                        });
                    });
                    _.each(data.lib_level_agg, function(element, index) {
                        element.forEach(function(element, index) {
                            data.years.push(element.year);
                            data.klasses.push(element.class_name);
                        });
                    });

                    // Step 1: Array of years.
                    data.years = _.uniq(data.years).sort();

                    // Step 2: Array of classes.
                    data.klasses = _.uniq(_.map(data.klasses, function (klass) {
                        return String(klass);
                    })).sort();

                    // Step 2.1: Remove unfortunate null values from the klass array.
                    data.klasses = _.without(data.klasses, 'null');

                    // Step 3: Array of levels.
                    data.levels = _.keys(data.lib_level_agg);

                    // Step 4: Array of languages.
                    data.languages = _.keys(data.lib_lang_agg);

                    data.aggregate = ['aggregate']
                    // console.log('years', data.years);
                    // console.log('klasses', data.klasses);
                    // console.log('levels', data.levels);
                    // console.log('languages', data.languages);
                    data.type_name = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
                    return data;
                },
                onRender: function(data) {
                    if (data.years.length === 0 || data.klasses.length === 0 || data.levels.length === 0) {
                        //FIXME: If no levels, still show chart, just hide level drop-down
                        $(".options-wrapper").addClass('hide');
                        $("#graph_library").addClass('hide');
                        $('.no-data').removeClass('hide');
                        return;
                    }
                    var $selectLibraryParam = $("#select_library_browse");
                    var $selectLibraryYear = $("#select_library_year");
                    var $selectLibraryClass = $("#select_library_class");

                    $selectLibraryParam.on('change', drawChart);
                    $selectLibraryYear.on('change', drawChart);
                    $selectLibraryClass.on('change', drawChart);

                    function drawChart() {
                        var libraryParam = $selectLibraryParam.val();
                        var libraryYear = $selectLibraryYear.val();
                        var libraryClass = $selectLibraryClass.val();
                        $('#graph_library').libraryChart(data, {'parameter': libraryParam, 'year': libraryYear, 'klass': libraryClass});
                    }

                    drawChart();
                }
            },
            'nutrition': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/nutrition');
                },

                getContext: function(data) {
                    data.hasData = true;
                    if (_.isEmpty(data.mdm_agg)) {
                        data.hasData = false;
                        return data;
                    }
                    data.indent = [];
                    data.attendance = [];
                    data.categories = [];
                    data.diseEnrollment = [];
                    data.klpEnrollment = [];

                    data.mdm_agg.forEach(function(element, index) {
                        data.categories.push(element.mon+ ' week ' + element.wk);
                        data.indent.push(element.indent);
                        data.attendance.push(element.attend);
                        data.diseEnrollment.push(data.num_boys_dise + data.num_girls_dise);
                        data.klpEnrollment.push(data.num_boys + data.num_girls);
                    });
                    data.type_name = klp.utils.getSchoolType(SCHOOL_TYPE_ID);
                    return data;

                },

                onRender: function(data) {
                    if (data.hasData) {
                        $('.data').removeClass('hide');
                        $('#graph_nutrition').highcharts({
                            chart: {
                                type: 'area',
                                width: container_width,
                                height: klp.utils.getRelativeHeight(960,400, 230, container_width)
                            },
                            title:{
                                text: null
                            },
                            subtitle: {
                                text: "Food Indent vs Attendance Tracking"
                            },
                            xAxis: {
                                categories: data.categories,
                                tickInterval: 2
                                // allowDecimals: false,
                                // labels: {
                                //     formatter: function() {
                                //         return this.value; // clean, unformatted number for year
                                //     }
                                // }
                            },
                            yAxis: {
                                title: {
                                    text: 'Number of children'
                                },
                                labels: {
                                    formatter: function() {
                                        return this.value;
                                        // return this.value / 1000 +'k';
                                    }
                                }
                            },
                            credits:{
                                enabled: false
                            },
                            tooltip: {
                                // pointFormat: '{series.name} produced <b>{point.y:,.0f}</b><br/>warheads in {point.x}'
                            },
                            plotOptions: {
                                area: {
                                    fillOpacity: 0
                                }
                            },
                            series: [{
                                name: 'Indent',
                                data: data.indent,
                                color: '#56af31',
                                fillColor: {
                                    linearGradient: chart_gradient_param,
                                    stops: [
                                        [0, '#e5f3e0'],
                                        [1, 'rgba(255,255,255,0.3)']
                                    ]
                                }
                            }, {
                                name: 'Attendance',
                                data: data.attendance,
                                color: '#3892e3',
                                fillColor: {
                                    linearGradient: chart_gradient_param,
                                    stops: [
                                        [0, '#92c3ef'],
                                        [1, 'rgba(255,255,255,0.3)']
                                    ]
                                }
                            }, {
                                name: 'KLP Enrollment',
                                data: data.klpEnrollment,
                                color: '#646157'
                            }, {
                                name: 'DISE Enrollment',
                                data: data.diseEnrollment,
                                color: '#e4b324'
                            }
                            ]
                        });
                    } else {
                        $('.no-data').removeClass('hide');
                    }
                }
            },
            'share-story': {
                getData: function() {
                    //FIXME: replace with real SYS end-point
                    var url ="stories/";
                    var params = {
                        'school_id': SCHOOL_ID,
                        'answers': 'yes',
                        'verified': 'yes'
                    };
                    return klp.api.do(url, params);
                },
                getContext: function(data) {
                    var latestStory = getLatestStoryWithAnswers(data.features);
                    if (latestStory) {
                        data.latest_answers = getCleanedAnswers(latestStory.answers);
                    } else {
                        data.latest_answers = null;
                    }
                    data['school_id'] = SCHOOL_ID;
                    data['school_type_id'] = SCHOOL_TYPE_ID;
                    // console.log("sys data", data);
                    return data;

                    function getLatestStoryWithAnswers(stories) {
                        for (var i=0; i < stories.length; i++) {
                            var thisStory = stories[i];
                            if (thisStory.answers.length > 0) {
                                return thisStory;
                            }
                        }
                        return null;
                    }

                    function getCleanedAnswers(answers) {
                        var cleanedAnswers = [];
                        _(answers).each(function(a) {
                            if (a.text === 'Yes' || a.text === 'No') {
                                cleanedAnswers.push(a);
                            }
                        });
                        // console.log("answers", answers, cleanedAnswers);
                        return cleanedAnswers;
                    }
                },
                onRender: function(data) {
                    var $container = $('.tab-content[data-tab=share-story]');
                    var containerHTML = $container.html();
                    klp.share_story.init(SCHOOL_ID, containerHTML);
                    var urlState = klp.router.getHash();
                    var queryParams = urlState.queryParams;
                    if (queryParams.hasOwnProperty('state') && queryParams.state === 'form') {
                        $("#trigger_share_story_form").click();
                    }
                    klp.router.events.on("hashchange:state", function(e, params) {
                        if (params.changed['state'].newVal === null) {
                            //console.log("old html", oldHtml);
                            $container.html(containerHTML);
                        } else if (params.changed['state'].newVal === 'form') {
                            $("#trigger_share_story_form").click();
                        }
                    });
                }
            },
            'volunteer': {
                getData: function() {
                    var url = "volunteer_activities";
                    var params = {
                        school: SCHOOL_ID
                    };
                    return klp.api.do(url, params);
                },
                onRender: function(data) {
                    klp.volunteer_here.checkSelf(data.features);
                }
            }

        };

        //tabs to omit for preschools
        var preschoolOmit = ['finances', 'library', 'nutrition'];
        if (schoolType === 'preschool') {
            hidePreschoolTabs(preschoolOmit);
        }

        var keys = _(tabs).keys();
        if (schoolType === 'preschool') {
            keys = _(keys).without(preschoolOmit);
        }

        //compile templates for tabs
        _(keys).each(function(tabName) {
            // console.log("tab name", tabName);
            var templateString = $('#tpl-tab-' + tabName).html();
            templates[tabName] = swig.compile(templateString);
        });

        $(document).on("click", ".js-tab-link", function(e){
            var $wrapper = $(".js-tabs-wrapper");
            var $trigger = $(this).closest(".js-tab-link");
            var tab_id = $trigger.attr('data-tab');

            //show tab
            t.showTab(tab_id, false);

        });

        var queryParams = klp.router.getHash().queryParams;
        if (queryParams.hasOwnProperty('tab') && queryParams['tab'] in tabs) {
            var firstTab = queryParams['tab'];
        } else {
            var firstTab = 'info';
        }

        var tabDeferred = t.showTab(firstTab, true);
        klp.router.events.on('hashchange:tab', function(e, params) {
            // console.log("hashchange:tab", params);
            var queryParams = params.queryParams;
            if (queryParams['tab'] in tabs) {
                t.showTab(queryParams['tab']);
            }
        });

        //slightly ugly hack to lazy load all tabs only on mobile
        //FIXME: possibly, get "isMobile" somewhere else, not sure
        //checking for < 768 on page load is the best technique.
        // if ($(window).width() < 768) {
        //     tabDeferred.done(function() {
        //         var tabsToLoad = _(keys).without(firstTab);
        //         _(tabsToLoad).each(function(tabName) {
        //             t.showTab(tabName, true);
        //         });
        //     });
        // }
        // console.log(templates);

    };

    /*
        Arguments:
            tabName <string>: name of tab to show
            replaceState <boolean>: whether to "replace state", if true,
                will not add a new history entry for this tab show. This exists
                so that when we load all tabs on mobile, we can avoid adding new history
                entries for each tab.

     */
    t.showTab = function(tabName, replaceState) {
        if (currentTab === tabName) {
            return;
        }
        if (typeof(replaceState) === 'undefined') {
            replaceState = false;
        }
        $('.tab-active').removeClass('tab-active');
        var queryParams = klp.router.getHash().queryParams;
        if (!(queryParams.hasOwnProperty('tab') && queryParams['tab'] === tabName)) {
            klp.router.setHash(null, {'tab': tabName}, {trigger: false, replace: replaceState});
        }
        currentTab = tabName;
        var $tabButton = $('.js-tab-link[data-tab=' + tabName + ']');
        $(".tab-heading-active").removeClass('tab-heading-active');
        $tabButton.addClass("tab-heading-active");
        $('.tab-content[data-tab=' + tabName + ']').addClass('tab-active');
        var $deferred = $.Deferred();
        getData(tabName, function(data) {
            if (tabs[tabName].hasOwnProperty('getContext')) {
                data = tabs[tabName].getContext(data);
            }
            var html = templates[tabName](data);
            //$('#loadingTab').removeClass('current');
            $('.tab-content[data-tab=' + tabName + ']').html(html);
            doPostRender(tabName, data);
            //on mobile, scroll to top of accordion
            var $accordionTrigger = $('.tab-each .tab-heading-active');

            //slightly ugly -- if replaceState == true, means it was
            //the 'default' first tab to show. In this case, don't scroll to
            //top of the tab
            if ($accordionTrigger.is(":visible") && !replaceState) {
                var headerHeight = $('.main-header').outerHeight();
                var offsetTop = $accordionTrigger.offset().top - headerHeight;
                $('html, body').animate({
                    scrollTop: offsetTop
                });
            }
            $deferred.resolve();
        });
        return $deferred;
    };

    function getData(tabName, callback) {
        if (dataCache.hasOwnProperty(tabName)) {
            callback(dataCache[tabName]);
            return;
        }
        var $xhr = tabs[tabName].getData();
        $xhr.done(function(data) {
            dataCache[tabName] = data;
            callback(data);
        });
        $xhr.fail(function(err) {
            klp.utils.alertMessage("Temporary error loading data.");
        });
    }

    function doPostRender(tabName, data) {
        if (tabs[tabName].hasOwnProperty('onRender')) {
            tabs[tabName].onRender(data);
        }
    }

    function hidePreschoolTabs(tabNames) {
        _(tabNames).each(function(tabName) {
            $('.tabs').find('li[data-tab=' + tabName + ']').hide();
            $('.js-tabs-wrapper').find('[data-tab=' + tabName + ']').hide().prev().hide();
        });
    }

})();
