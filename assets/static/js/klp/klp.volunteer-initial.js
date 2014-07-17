var klp = klp || {};

(function(){
	var active_volunteer_step = "date";
	var volunteer_steps;
	var modal_tpl;
	var $modal_wrapper;
	var $modal_overlay;

	var init = function(){
		volunteer_steps = ['date', 'organization', 'opportunities'];
		modal_tpl = swig.compile($("#tpl-volunteer-modal").html());
		$modal_wrapper = $("#modal_wrapper");
		$modal_overlay = $("#modal_overlay");

		// setTimeout(open_modal,1500);
		// open_modal();
	};

	var open_modal = function(e){
		if( $(window).width()<768 ){
			return true;
		}
		e.preventDefault();

		var html = modal_tpl();
		$modal_wrapper.append(html);
		var $modal = $modal_wrapper.find(".modal-volunteer");
		init_modal($modal);

		setTimeout(function(){
			$modal.addClass("show");
			$modal_overlay.addClass("show");
		},0);
	};

	var init_modal = function($modal){
		var $input_data_location = $modal.find( "input[name=data_location]" );
		var $input_data_date = $modal.find( "input[name=data_date]" );
		var $input_data_type = $modal.find( "input[name=data_type]" );

		var $btn_close = $modal.find(".btn-modal-close");
		var $btn_back = $modal.find(".btn-modal-back");
		var $btn_next_step_cal = $modal.find('.btn-next-step-cal');
		var $btn_next_step_org = $modal.find('.btn-next-step-org');
		var $datepicker_input = $modal.find('#datepicker-input');
		var $select_location = $modal.find('#select-location').selectize({onChange: onLocationChange});

		function onLocationChange(value){
			$input_data_location.val(value);
		}

		$datepicker_input.Zebra_DatePicker({
		    always_visible: $modal.find('#datepicker-wrapper'),
		    first_day_of_week: 0,
		    show_clear_date: false,
		    show_select_today: false,
		    disabled_dates: ['1,3,4,5,12,13,14,22,24'],
		    onSelect: onDateSelect,
		    onClear: onDateClear
		});
		var datepicker = $datepicker_input.data('Zebra_DatePicker');

		function onDateSelect(date){
			$input_data_date.val(date);
			$btn_next_step_cal.show();
		}
		function onDateClear(){
			$input_data_date.val("");
			$btn_next_step_cal.hide();
		}

		$btn_next_step_cal.on("click", function(e){
			e.preventDefault();
			active_volunteer_step = "organization";
			show_next_step($modal, active_volunteer_step);
			$btn_back.show();
		});

		$btn_next_step_org.on("click", function(e){
			e.preventDefault();
			active_volunteer_step = "opportunities";
			show_next_step($modal, active_volunteer_step);
			$btn_back.show();
		});

		$btn_close.on("click", function(e){
			e.preventDefault();

			$modal.removeClass("show");
			$modal_overlay.removeClass("show");
			
			setTimeout(function(){
				$modal.remove();
			},300);
		});

		$btn_back.on("click", function(e){
			e.preventDefault();

			var current_step_index = jQuery.inArray(active_volunteer_step, volunteer_steps);
			if(current_step_index<=0){
				return;
			}
			current_step_index--;
			var prev_step = volunteer_steps[current_step_index];
			active_volunteer_step = prev_step;
			show_prev_step($modal, prev_step);

			if(current_step_index<=0){
				$btn_back.hide();
			}
		});

		$modal.on('click', ".js-open-map", open_map);	

		function open_map(e){
			e.preventDefault();
			var location = $input_data_location.val();
			var date = $input_data_date.val();
			var type = $(this).data("type");
			var url = "map.php?location="+location+"&date="+date+"&type="+type;
			window.location.href = url;
		}
	};

	var show_prev_step = function($modal, step_name){
		var $step_current = $modal.find(".step-item.visible");
		var $step_prev = $modal.find(".step-item[data-step-name='" + step_name +"']");

		$step_current.removeClass("fadein").addClass("move-right fadeout");
        $step_prev.removeClass("fadeut").addClass("move-left visible");

        // Hide current step
        setTimeout(function(){
            $step_current.removeClass("visible");
        },300);

        setTimeout(function(){
            $step_prev.addClass("fadein").removeClass("move-left");
        },10);
    };

	var show_next_step = function($modal, step_name){
		var $step_current = $modal.find(".step-item.visible");
		var $step_next = $modal.find(".step-item[data-step-name='" + step_name +"']");

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

	$(document).ready(function(){
		init();
		$(document).on('click', ".js-trigger-volunteer", open_modal);	
	});

})();