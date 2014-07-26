var container_width = 960;

function init_tabs(){
    $(document).on("click", ".js-tab-link", function(e){
        var $wrapper = $(".js-tabs-wrapper");
        var $trigger = $(this).closest(".js-tab-link");
        var tab_id = $trigger.attr('data-tab');

        // Change current tab link
        $trigger.parent().find("li.current").removeClass('current');
        $trigger.addClass("current");

        // Change current tab content
        $wrapper.find(".tab-content.current").removeClass('current');
        $wrapper.find('.tab-content[data-tab="'+ tab_id +'"]').addClass('current');
    });
}

function init_selects(){

    $(".apply-selectboxit").selectBoxIt({
        autoWidth: true
    });
}

function init_library_view_toggle(){
    var $toggler = $("#library_graph_table_switch");
    var $graph = $("#graph_library");
    var $table = $("#table_library");

    $toggler.on("click", function(e){
        e.preventDefault();

        if($graph.is(":visible") ){
            $graph.hide();
            $table.show();
            $toggler.text("Switch to Graph View");
        } else {
            $graph.show();
            $table.hide();
            $toggler.text("Switch to Table View");
        }

    });
}

function get_relative_height(width, height, min_height){
    var ht = (height/width)*container_width;
    ht = parseInt(ht,10);

    if(ht<min_height){
        return min_height;
    }

    // If number is odd, convert to even
    if(Math.abs(ht) % 2 == 1){
        ht++;
    }
    return ht;
}

function load_map() {
    map = L.map('map-canvas').setView([51.505, -0.09], 14);
    L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: '',
        id: 'examples.map-i86knfo3'
    }).addTo(map);
}

$(document).ready(function(){
    init_tabs();
    init_selects();
    init_library_view_toggle();
    load_map();

    container_width = $(document).find(".container:first").width();
    container_width = parseInt(container_width,10);

    var chart_gradient_param = [0, 0, 0, 300];

    if(container_width<960){
        chart_gradient_param = [0, 0, 0, 200];
    }
    if(container_width<600){
        chart_gradient_param = [0, 0, 0, 110];
    }

    $('#pie_chart_1').highcharts({
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
                ['Boys', 65.0],
                ['Girls', 35.0]
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

    $('#pie_chart_finance').highcharts({
        chart: {
            width: container_width,
            height: 200,
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
                    enabled: true
                },
                startAngle: 0,
                endAngle: 360,
                center: ['50%', '50%'],
                colors: ['#329186', '#c8273e', '#f68300']
            }
        },
        series: [{
            type: 'pie',
            name: 'Count',
            innerSize: '60%',
            data: [
                ['TLM', 46],
                ['SMG', 24],
                ['SG', 30]
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

    $('#graph_library').highcharts({
        chart: {
            type: 'area',
            width: container_width,
            height: get_relative_height(960,400, 200)
        },
        title: {
            text: null
        },
        xAxis: {
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

    $('#graph_nutrition').highcharts({
        chart: {
            type: 'area',
            width: container_width,
            height: get_relative_height(960,400, 230)
        },
        title:{
            text: null
        },
        subtitle: {
            text: "'Food Indent' vs 'Attendance Tracking'"
        },
        xAxis: {
            // categories: ['Easy', 'Medium', 'Hard']
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
});
