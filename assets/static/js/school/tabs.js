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

    t.init = function() {
        schoolInfoURL = 'schools/school/' + SCHOOL_ID;
   
        tabs = {
            'info': {
                getData: function() {
                    return klp.api.do(schoolInfoURL);
                },
                getContext: function(data) {
                    return data;
                },
                onRender: function(data) {
                    console.log("post render info");
                }
            },
            'demographics': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/demographics');
                },
                getContext: function(data) {
                    var total_students = data.num_boys + data.num_girls;
                    _(['num_boys', 'num_girls']).each(function(n) {
                        if (data[n] === null) {
                            data[n] = 0;
                        }
                    });
                    data.has_num_students = data.num_boys && data.num_girls;
                    data.percent_boys = ((data.num_boys / total_students) * 100).toFixed(2);
                    data.percent_girls = ((data.num_girls / total_students) * 100).toFixed(2);
                    var total_mts = _(_(data.mt_profile).values()).reduce(function(a, b) {
                        return a + b;
                    });
                    data.mt_profile_percents = {};
                    _(_(data.mt_profile).keys()).each(function(mt) {
                        data.mt_profile_percents[mt] = (data.mt_profile[mt] / total_mts) * 100;
                    });
                    //console.log("data", data);
                    return data;
                },
                onRender: function(data) {
                    //console.log("onrender", data);
                    $('#num_students_piechart').highcharts({
                        chart: {
                            height: 170,
                            width:170,
                            plotBackgroundColor: null,
                            plotBorderWidth: 0,
                            plotShadow: false
                        },
                        title: {
                            text: null
                        },
                        plotOptions: {
                            pie: {
                                dataLabels: {
                                    enabled: false
                                },
                                startAngle: 0,
                                endAngle: 360,
                                center: ['50%', '50%'],
                                colors: ['#609adf', '#f87c84']
                            }
                        },
                        series: [{
                            type: 'pie',
                            name: 'Count',
                            innerSize: '80%',
                            data: [
                                ['Boys', parseFloat(data.percent_boys)],
                                ['Girls', parseFloat(data.percent_girls)]
                            ]
                        }],
                        credits:{
                            enabled:false
                        },
                        tooltip:{
                            enabled:true,
                            formatter: function() {
                                return '<b>'+ this.y +'%</b>';
                            }
                        },
                        exporting:{
                            enabled:false
                        }
                    });

                }
            },
            'programmes': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/programmes');
                }
            },
            'finances': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/finance');
                }
            },
            'infrastructure': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/infrastructure');
                }
            },
            'library': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/library');
                },

                getContext: function(data) {
                    // Step 0: Check if library data exists.
                    // Step 1: Array of years.
                    // Step 2: Array of classes.
                    // Step 3: Array of levels.
                    // Step 4: Array of languages.
                    // Step 5: Array of months.
                    console.log(data);
                    return data;
                },
                onRender: function(data) {
                    $(".apply-selectboxit").selectBoxIt();
                    $('#graph_library').highcharts({
                        chart: {
                            type: 'area',
                            width: container_width,
                            height: klp.utils.getRelativeHeight(960, 400, 200, container_width)
                        },
                        title: {
                            text: null
                        },
                        xAxis: {
                            title: {
                                text: 'Month of the Year'
                            },
                            labels: {
                                formatter: function() {
                                    return this.value; 
                                }
                            }
                        },
                        yAxis: {
                            title: {
                                text: 'Avg. No. of transations per student'
                            },
                            labels: {
                                formatter: function() {
                                    return this.value;
                                    // return this.value / 1000 +'k';
                                }
                            }
                        },credits:{
                            enabled:false
                        },
                        tooltip: {
                            // pointFormat: '{series.name} produced <b>{point.y:,.0f}</b><br/>warheads in {point.x}'
                        },
                        plotOptions: {
                            area: {
                                fillOpacity:1
                            }
                        },
                        series: [{
                            name: 'Easy',
                            data: [0.2, 0.3, 0.4, 0.5, 0.8, 0.4 , 0.6, 0.4, 0.6, 0.4, 0.2, 0 ],
                            color: '#56af31',
                            fillColor: {
                                linearGradient: chart_gradient_param,
                                stops: [
                                    [0, '#e5f3e0'],
                                    [1, 'rgba(255,255,255,0.3)']
                                ]
                            }
                        }, {
                            name: 'Medium',
                            data: [0, 0.2, 0.4, 0.4, 0.5, 0.8, 0.2 , 0.3, 0.4, 0.3, 0.4, 0.2 ],
                            color: '#3892e3',
                            fillColor: {
                                linearGradient: chart_gradient_param,
                                stops: [
                                    [0, '#92c3ef'],
                                    [1, 'rgba(255,255,255,0.3)']
                                ]
                            }
                        }, {
                            name: 'Hard',
                            data: [0, 0.2, 0.4, 0.2, 0.2, 0.4, 0.3 , 0.2, null, null, null, null ],
                            color: '#cb0012',
                            fillColor: {
                                linearGradient: chart_gradient_param,
                                stops: [
                                    [0, '#de69c4'],
                                    [1, 'rgba(255,255,255,0.3)']
                                ]
                            }
                        }]
                    });
                }
            },
            'nutrition': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/nutrition');
                },

                getContext: function(data) {
                    console.log('nutrition', data);
                    data.indent = [];
                    data.attendance = [];
                    data.categories = [];
                    // console.log('could be array', _.toArray(data));
                    data.mdm_agg.forEach(function(element, index) {
                        data.categories.push(element.mon+ ' week ' + element.wk);
                        data.indent.push(element.indent);
                        data.attendance.push(element.attend);
                    });
                    console.log('categories', data.categories);
                    return data;
                },

                onRender: function(data) {
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
                            text: "'Food Indent' vs 'Attendance Tracking'"
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
                            enabled:false
                        },
                        tooltip: {
                            // pointFormat: '{series.name} produced <b>{point.y:,.0f}</b><br/>warheads in {point.x}'
                        },
                        plotOptions: {
                            area: {
                                fillOpacity:1
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
                        }]
                    });
                }
            },
            'share-story': {
                getData: function() {
                    //FIXME: replace with real SYS end-point
                    return klp.api.do(schoolInfoURL);
                }
            }

        };


        //compile templates for tabs
        _(_(tabs).keys()).each(function(tabName) {
            console.log("tab name", tabName);
            var templateString = $('#tpl-tab-' + tabName).html();
            templates[tabName] = swig.compile(templateString);
        });

        $(document).on("click", ".js-tab-link", function(e){
            var $wrapper = $(".js-tabs-wrapper");
            var $trigger = $(this).closest(".js-tab-link");
            var tab_id = $trigger.attr('data-tab');

            //show tab
            t.showTab(tab_id);

        });

        var queryParams = klp.router.getHash().queryParams;
        if (queryParams.hasOwnProperty('tab') && queryParams['tab'] in tabs) {
            var firstTab = queryParams['tab'];
        } else {
            var firstTab = 'info';
        }

        var tabDeferred = t.showTab(firstTab);
        klp.router.events.on('hashchange:tab', function(e, params) {
            console.log("hashchange:tab", params);
            var queryParams = params.queryParams;
            if (queryParams['tab'] in tabs) {
                t.showTab(queryParams['tab']);
            }
        });

        //slightly ugly hack to lazy load all tabs only on mobile
        //FIXME: possibly, get "isMobile" somewhere else, not sure
        //checking for < 768 on page load is the best technique.
        if ($(window).width() < 768) {
            tabDeferred.done(function() {
                var allTabs = _(tabs).keys();
                var tabsToLoad = _(allTabs).without(firstTab);
                _(tabsToLoad).each(function(tabName) {
                    t.showTab(tabName);
                });
            });
        }
        console.log(templates);

    };

    t.showTab = function(tabName) {
        if (currentTab === tabName) {
            return;
        }
        $('.tab-content.current').removeClass('current');
        var queryParams = klp.router.getHash().queryParams;
        if (!(queryParams.hasOwnProperty('tab') && queryParams['tab'] === tabName)) {
            klp.router.setHash(null, {'tab': tabName}, {trigger: false});
        }
        currentTab = tabName;
        var $tabButton = $('.js-tab-link[data-tab=' + tabName + ']');
        $tabButton.parent().find("li.current").removeClass('current');
        $tabButton.addClass("current");
        var $deferred = $.Deferred();
        getData(tabName, function(data) {
            if (tabs[tabName].hasOwnProperty('getContext')) {
                data = tabs[tabName].getContext(data);
            }
            var html = templates[tabName](data);
            //$('#loadingTab').removeClass('current');
            $('div[data-tab=' + tabName + ']').html(html).addClass('current');
            doPostRender(tabName, data);
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
    }

    function doPostRender(tabName, data) {
        if (tabs[tabName].hasOwnProperty('onRender')) {
            tabs[tabName].onRender(data);
        }
    }

})();