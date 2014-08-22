(function() {
    var t = klp.tabs = {};
    var templates = {};
    var dataCache = {};
    var schoolInfoURL;
    var tabs;

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
                }
            },
            'nutrition': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/infrastructure');
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

            // Change current tab link
            $trigger.parent().find("li.current").removeClass('current');
            $trigger.addClass("current");

            //show tab
            t.showTab(tab_id);

        });

        //FIXME: get tab name from url, default to info
        var firstTab = 'info';
        var tabDeferred = t.showTab(firstTab);

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
        $('.tab-content.current').removeClass('current');
        //$('#loadingTab').addClass('current');
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