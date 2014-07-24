var map_page = (function(){
	var _tpl = {},
		$_compare_flow,
		$_map_overlay,
		$_filter_layers_list,
		$_filter_layers_button,
		$_filter_radius_button,
		$_filter_button;

	var compile_templates = function(){
        var $raw_tpls = $(".tpl-raw");
        if(!$raw_tpls.length){
            return;
        }

        $raw_tpls.each(function( index ) {
            var name = $(this).data("tpl");
            var content = $(this).html();

            _tpl[name] = swig.compile(content);
        });
    };

    var place_info = (function(){
    	var _place_open_allowed,
    		$_map_overlay;

    	var init = function(){
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

			console.log(ctx);

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

    	return {
    		init: init,
    		close_place : close_place
    	};
    })();

    var comparison = (function(){
    	var $compare_flow,
    		$dropdown_wrapper,
    		$btn_comparison_cancel,
    		$btn_comparison_submit,
    		$comparison_option_left,
    		$comparison_option_right,
    		$comparison_default_right,
    		$comparison_result_wrapper;

    	var open = function(e){
    		e.preventDefault();

    		if(map){
    			map.closePopup();
    		}

    		place_info.close_place();
    		$comparison_result_wrapper.removeClass('show');

    		$compare_flow.removeClass("hide");
    		setTimeout(function(){
    			$compare_flow.removeClass("hide").addClass("show");
    		},0);
    	};
    	var close = function(e){
    		e.preventDefault();
    		$compare_flow.removeClass("show");
    		setTimeout(function(){
    			$compare_flow.removeClass("show").addClass("hide");
    			clear_option_left();
    			clear_option_right();
    		},300);
    	};

    	var reset_submit_button = function(){
    		$btn_comparison_cancel.addClass("show");
			$btn_comparison_submit.removeClass("show");
			$comparison_result_wrapper.html("").removeClass('show');
    	};
    	var show_submit_button = function(){
    		$btn_comparison_cancel.removeClass("show");
			$btn_comparison_submit.addClass("show");
    	};
    	var clear_option_left = function(){
    		// to do
    		reset_submit_button();
    	};
    	var clear_option_right = function(e){
    		if(e){
    			e.preventDefault();
    		}

			$comparison_option_right.hide();
			$comparison_default_right.show();

			reset_submit_button();
    	};
    	var show_options_dropdown_right = function(e){
    		e.preventDefault();
			$dropdown_wrapper.toggleClass("show");
    	};
    	var select_options_right = function(e){
    		e.preventDefault();

			$dropdown_wrapper.removeClass("show");
			$comparison_option_right.show();
			$comparison_default_right.hide();
			show_submit_button();
    	};

    	var init = function(){
    		$compare_flow = $("#compare_flow");
			$dropdown_wrapper = $('#dropdown_wrapper');

			$btn_comparison_cancel = $compare_flow.find(".js-btn-cancel");
			$btn_comparison_submit = $compare_flow.find(".js-btn-compare");

			$comparison_option_left = $(".js-comparison-option-left");
			$comparison_option_right = $(".js-comparison-option-right");
			$comparison_default_right = $(".js-comparison-default-right");

			$comparison_result_wrapper = $(".js-comparison-result-wrapper");

    		$(document).on('click', ".js-trigger-compare", open);
	    	$(document).on('click', ".js-comparison-close", close);
	    	$(document).on('click', ".js-comparison-clear-left", clear_option_left);
	    	$(document).on('click', ".js-comparison-clear-right", clear_option_right);
	    	$(document).on('click', ".js-comparison-show-options-right", show_options_dropdown_right);
	    	$(document).on('click', ".js-dropdown-option-right", select_options_right);

	    	$(document).on('click', ".js-btn-compare", function(e){
				e.preventDefault();

				$btn_comparison_submit.removeClass("show");
				var html = _tpl.comparison_result();
				$comparison_result_wrapper.html(html).addClass('show');

				setTimeout(function(){
					var $selects = $comparison_result_wrapper.find('select');
					$selects.easyDropDown();
				},0);

				setTimeout(function(){
					init_comparison_charts();
				},100);
			});
    	};

    	return {
    		init: init,
    		close: close
    	};
    })();

    var share_story = (function(){
    	var $modal_share_story;
    	var open = function(e){
    		e.preventDefault();
    		$modal_share_story.addClass("show");
		    $('#modal_overlay').addClass("show");
    	};
    	var init = function(){
    		$modal_share_story = $('#modal_share_your_story');
    		$(document).on('click', "#trigger_share_story_modal", open);
    	};

    	return {
    		init: init
    	};
    })();

    var volunteer_modal = (function(){
    	var $modal,
    		$steps,
    		_active_step;

    	var open = function(e){
    		e.preventDefault();
    		reset();

    		$modal.addClass("show");
    		$("#modal_overlay").addClass("show");
    	};

    	// Reset steps - show first step and reset params
    	var reset = function(){
    		_active_step = 1;

    		// Hide all steps
    		$modal.find('.step-item').removeClass("visible fadein fadeout move-left move-right");
    		// Show first step
    		$modal.find('.step-item[data-step="1"]').addClass("visible fadein");
    	};

    	var get_step = function(step_id){
    		return $modal.find('.step-item[data-step="'+ step_id +'"]');
    	};

    	var show_next_step = function(e){
    		e.preventDefault();
    		var $step_current = get_step(_active_step);
    		var $step_next = get_step(++_active_step);

    		// Hide current step
	    	$step_current.removeClass("move-right fadein").addClass("fadeout move-left");
	        setTimeout(function(){
	            $step_current.removeClass("visible");
	        },300);

	        // Show next step
	        $step_next.addClass("move-right visible");
	        setTimeout(function(){
	            $step_next.addClass("fadein").removeClass("move-right");
	        },10);

    	};

    	var on_close = function(e){
    		e.preventDefault();
    		setTimeout(function(){
    			reset();
    			$modal.find('.step-item.visible').removeClass("visible");
    		},300);
    	};

    	var init = function(){
    		$modal = $("#modal_volunteer_flow");
    		$steps = $modal.find(".step-item");

    		$(document).on('click', ".js-trigger-volunteer", open);
    		$(document).on('click', ".js-volunteer-next-step", show_next_step);
    		$modal.on('click', ".btn-modal-close", on_close);

    		$('#datepicker-input').Zebra_DatePicker({
			    always_visible: $('#datepicker-wrapper'),
			    first_day_of_week: 0,
			    show_clear_date: false,
			    show_select_today: false
			});
    		
    	};
    	
    	return {
    		init: init
    	};
    })();

    var checkLayersFilter = function(){
    	var n = $_filter_layers_list.find("input[type='checkbox']:checked").length;
    	if(n) {
    		$("#filter-layers-button").addClass("active");
    	} else {
    		$("#filter-layers-button").removeClass("active");
    	}
    };

    var toggleFilterRadius = function(){
    	var $filter_radius_msg = $("#msg-filter-radius");

    	if(!$_filter_radius_button.hasClass("active")) {
    		// $_filter_radius_button.addClass("active");
    		$filter_radius_msg.removeClass("hide");
    	} else {
    		// $_filter_radius_button.removeClass("active");
    		$filter_radius_msg.addClass("hide");
    	}
    };

    var openFiltersModal = function(){
    	var $modal_overlay = $("#modal_overlay");
    	var $modal = $(".modal-map-filter");
    	
    	$modal_overlay.addClass("show");
    	$modal.addClass("show");
    };

    var getUrlParam = function(key){
		var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search); 
		return result && unescape(result[1]) || ""; 
	};

	function show_volunteer_mode(){
		$(".map-subheader-wrapper").addClass("show-volunteer-filters");
	}

    $(document).ready(function(){
    	compile_templates();
    	$_filter_layers_list = $("#filter-layers-list");
    	$_filter_layers_button = $("#filter-layers-button");
    	$_filter_radius_button = $("#filter-radius-button");
    	$_filter_button = $("#filter-button");

    	place_info.init();
    	comparison.init();
    	share_story.init();
    	volunteer_modal.init();

    	var url_location_param = getUrlParam("location");
    	var url_date_param = getUrlParam("date");

    	if(url_location_param && url_date_param){
    		show_volunteer_mode();
    	}

    	$(document).on("click", ".js-volunteer-trigger", function(e){
    		e.preventDefault();
    		show_volunteer_mode();
    	});

    	$(document).on("click", ".js-toggle-layers-list", function(e){
    		var $trigger = $(e.target).closest(".js-toggle-layers-list");

    		if(!$_filter_layers_list.hasClass("show")){
    			// $trigger.addClass("open");
    			$_filter_layers_list.addClass("show");
    		} else {
    			// $trigger.removeClass("open");
    			$_filter_layers_list.removeClass("show");
    		}
    	});

    	$("input[type='checkbox']").on('change', checkLayersFilter);

    	$_filter_radius_button.on("click", toggleFilterRadius);
    	$_filter_button.on("click", openFiltersModal);
    });

	return {};
})();

function init_comparison_charts() {
	var chart_width = 300;

	$('#comparison_pie_chart_1').highcharts({
        chart: {
            height: chart_width,
            width:chart_width,
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
            innerSize: '85%',
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
                return '<b>'+ this.point.name +'</b> - ' + this.y +'%';
            }
        },
        exporting:{
        	enabled:false
        }
    });

	$('#comparison_pie_chart_2').highcharts({
        chart: {
            height: chart_width,
            width:chart_width,
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
            innerSize: '85%',
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
                return '<b>'+ this.point.name +'</b> - ' + this.y +'%';
            }
        },
        exporting:{
        	enabled:false
        }
    });

	$('#comparison_pie_chart_3').highcharts({
        chart: {
            height: chart_width,
            width:chart_width,
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
                colors: ['#41a098', '#d23f51', '#f89515']
            }
        },
        series: [{
            type: 'pie',
            name: 'Count',
            innerSize: '85%',
            data: [
                ['TLM', 40.0],
                ['SMG', 27.0],
                ['SG', 32.0]
            ]
        }],
        credits:{
        	enabled:false
        },
        tooltip:{
        	enabled:true,
        	formatter: function() {
                return '<b>'+ this.point.name +'</b> - ' + this.y +'%';
            }
        },
        exporting:{
        	enabled:false
        }
    });

	$('#comparison_pie_chart_4').highcharts({
        chart: {
            height: chart_width,
            width:chart_width,
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
                colors: ['#41a098', '#d23f51', '#f89515']
            }
        },
        series: [{
            type: 'pie',
            name: 'Count',
            innerSize: '85%',
            data: [
                ['TLM', 40.0],
                ['SMG', 27.0],
                ['SG', 32.0]
            ]
        }],
        credits:{
        	enabled:false
        },
        tooltip:{
        	enabled:true,
        	formatter: function() {
                return '<b>'+ this.point.name +'</b> - ' + this.y +'%';
            }
        },
        exporting:{
        	enabled:false
        }
    });
}


$(document).ready(function(){

	// var map = new GMaps({
	// 	div: '#map_canvas',
	// 	lat: 12.9702,
	// 	lng: 77.565,
	// });

	// var marker_icon = new google.maps.MarkerImage("images/map_marker@2x.png", null, null, null, new google.maps.Size(28,40));
	var marker_overlay_html = $("#tpl_marker_overlay").html();

	// var marker = map.addMarker({
	// 	lat: 12.9702,
	// 	lng: 77.565,
	// 	title: 'Lima',
	// 	icon: marker_icon,
	// 	click: function(e) {
	// 		// infowindow.open(map);
	// 		// alert('You clicked in this marker');
	// 	},
	// 	infoWindow: {
	// 		content: '<div style="width:400px; height: 345px;">'+marker_overlay_html+'</div>',
	// 		maxWidth : 400
	// 	}
	// });

	// $(document).on('click', ".js-btn-compare", function(e){
	// 	e.preventDefault();

	// 	// var latLng = new google.maps.LatLng(12.971, 77.565);
	// 	// map.panTo(latLng);
	// });

	$(document).on('click', ".btn-modal-close", function(e){
		e.preventDefault();

		var $modal = $(e.target).closest(".modal").removeClass("show");
		$(".modal-overlay").removeClass("show");
	});
	
});

// var chart;
// var legend;

// var chartData = [{
//     country: "Czech Republic",
//     litres: 301.90
// }, {
//     country: "Ireland",
//     litres: 201.10
// }, {
//     country: "Germany",
//     litres: 165.80
// }];

// AmCharts.ready(function () {
//     // PIE CHART
//     chart = new AmCharts.AmPieChart();
//     chart.dataProvider = chartData;
//     chart.titleField = "country";
//     chart.valueField = "litres";
//     chart.outlineColor = "#FFFFFF";
//     chart.outlineAlpha = 0.8;
//     chart.outlineThickness = 2;
//     chart.hideLabelsPercent = 0;
//     chart.labelText = "";

//     // WRITE
//     chart.write("pie_chart_1");
// });

