(function($) {
    var container_width = 960;
    var chart_gradient_param = [0, 0, 0, 300];


    $.fn.boyGirlChart = function(data, options) {
        if (typeof(options) === 'undefined') {
            options = {};
        }
        var defaults = {
            innerSize: '80%',
            height: 170,
            width: 170
        };
        var opts = $.extend(defaults, options);

        return this.highcharts({
            chart: {
                height: opts.height,
                width: opts.width,
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
                innerSize: opts.innerSize,
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
    };

    $.fn.libraryChart = function(data, options) {

        console.log('library data', data);
        console.log('options', options);
        var chartSeries = [];

        var monthMap = {
            'Jan': 0,
            'Feb': 1,
            'Mar': 2,
            'Apr': 3,
            'May': 4,
            'Jun': 5,
            'Jul': 6,
            'Aug': 7,
            'Sep': 8,
            'Oct': 9,
            'Nov': 10,
            'Dec': 11
        };
        var colorMap = {
            'GREEN': {
                'color': '#1ee01f',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#d1f9d1'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'RED': {
                'color': '#CB0012',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#ffa9b0'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'ORANGE': {
                'color': '#ffa500',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#ffedcc'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'WHITE': {
                'color': '#fff',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#999'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'BLUE': {
                'color': '#0000ff',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#ccf'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'YELLOW': {
                'color': '#ffff00',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#ffc'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'E/K': {
                'color': '#f211fa',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#fdd9fe'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'KANNADA': {
                'color': '#c13851',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#ebb9c2'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            },
            'ENGLISH': {
                'color': '#ef5754',
                'fillColor': {
                    'linearGradient': chart_gradient_param,
                    'stops': [
                        [0, '#f9c2c1'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            }
        };

        function getSeries(parameter, klass, data, klassTotal) {
            var series = {
                'name': parameter,
                'data': [],
                'color': colorMap[parameter].color,
                'fillColor': colorMap[parameter].fillColor
            };
            _.each(monthMap, function(value, key) {
                var arrgh = data[parameter];
                var matchedObj = _.find(arrgh, function(obj) {
                    if (obj.month == key && parseInt(obj.class_name) === parseInt(klass)) {
                        return true;
                    }
                });
                if (matchedObj) {
                    var classStrength = _.find(klassTotal, function (cls) {
                        if (cls.clas === klass) {
                            return true;
                        }
                    });
                    if (classStrength) {
                        series.data.push(matchedObj.child_count/classStrength.total);
                    } else {
                        series.data.push(0);
                    }
                } else {
                    series.data.push(0);
                }
            });
            return series;
        }

        if (options.parameter === 'level') {
            _.each(data.levels, function(level) {
                chartSeries.push(getSeries(level, options.klass, data.lib_level_agg, data.classtotal));
            });
        }

        if (options.parameter === 'language') {
            _.each(data.languages, function(language) {
                chartSeries.push(getSeries(language, options.klass, data.lib_lang_agg, data.classtotal));
            });
        }

        return this.highcharts({
            chart: {
                type: 'area',
                width: container_width,
                height: klp.utils.getRelativeHeight(960, 400, 200, container_width)
            },
            title: {
                text: null
            },
            xAxis: {
                categories: ['January', 'February', 'March', 'April', 'May',
                    'June', 'July', 'August', 'September', 'October', 'November', 'December'],
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
            series: chartSeries
        });
    };

})(jQuery);