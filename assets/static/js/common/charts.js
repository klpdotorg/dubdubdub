(function($) {

    $.fn.boyGirlChart = function(data, options) {
        if (typeof(options) === 'undefined') {
            options = {};
        };
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


})(jQuery);