(function(){
    var t = klp.place_info = {};

    var _place_open_allowed,
        $_map_overlay;

    t.init = function(){
        _place_open_allowed = true;
        $_map_overlay = $("#map_overlay");

        init_place_tabs();
        $(document).on('click', ".js-trigger-info", open_place);
        $_map_overlay.on('click', ".js-close-info", close_place);
    };

    var open_place = function(e){
        e.preventDefault();
        if(!_place_open_allowed){
            return;
        }

        var $trigger = $(e.target).closest(".js-trigger-info");

        var ctx = {
            school : $trigger.data("name") ? $trigger.data("name") : 'Gian Jyoti Public School',
            entity_type : $trigger.data("entity-type") ? $trigger.data("entity-type") : ''
        };

        // console.log(ctx);

        var content = _tpl.overlay_content(ctx);
        $_map_overlay.find(".content").html(content);

        if($_map_overlay.hasClass("show")){
            // Already open, just needed to replace content
            return;
        }

        $_map_overlay.removeClass("hide");
        setTimeout(function(){
            $_map_overlay.addClass("show");
        },0);

        $('#pie_chart_1').highcharts({
            chart: {
                height: 180,
                width:180,
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
                height: 200,
                width:600,
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
                type: 'area'
            },
            title: {
                text: null
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
                    text: 'Avg. No. of transations per student'
                },
                labels: {
                    formatter: function() {
                        return this.value;
                        // return this.value / 1000 +'k';
                    }
                }
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
                    linearGradient: [0, 0, 0, 300],
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
                    linearGradient: [0, 0, 0, 300],
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
                    linearGradient: [0, 0, 0, 300],
                    stops: [
                        [0, '#de69c4'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            }]
        });

        $('#graph_nutrition').highcharts({
            chart: {
                type: 'area'
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
                    linearGradient: [0, 0, 0, 300],
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
                    linearGradient: [0, 0, 0, 300],
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
                    linearGradient: [0, 0, 0, 300],
                    stops: [
                        [0, '#de69c4'],
                        [1, 'rgba(255,255,255,0.3)']
                    ]
                }
            }]
        });


    };

    var close_place = function(e) {
        if(e){
            e.preventDefault();
        }
        _place_open_allowed = false;
        $_map_overlay.removeClass("show");
        setTimeout(function(){
            $_map_overlay.removeClass("show").addClass("hide");
            _place_open_allowed = true;
        },600);
    };

    t.close_place = close_place;

    function init_place_tabs(){
        $_map_overlay.on("click", ".js-place-tab", function(e){
            var $content = $(this).closest(".content");
            var $trigger = $(this).closest(".js-place-tab");

            var tab_id = $trigger.attr('data-tab');

            $content.find("ul.tabs").find("li").removeClass('current');
            $content.find(".tab_content").removeClass('current');

            $trigger.addClass("current");
            $content.find("#"+tab_id).addClass('current');
        });
    }

})();
