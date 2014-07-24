var klp = klp || {};

(function(){
	var modal_tpl;
	var $modal_wrapper;
	var $modal_overlay;

	var init = function(){
		modal_tpl = swig.compile($("#tpl-volunteer-modal-map").html());
		$modal_wrapper = $("#modal_wrapper");
		$modal_overlay = $("#modal_overlay");
	};

	var open_modal = function(e){
		e.preventDefault();

		var date = $(this).data("date") || false;

		var ctx = {
			date: date
		}

		var html = modal_tpl(ctx);
		$modal_wrapper.append(html);
		var $modal = $modal_wrapper.find(".modal-volunteer.second-step");
		init_modal($modal);

		setTimeout(function(){
			$modal.addClass("show");
			$modal_overlay.addClass("show");
		},0);
	};

	var init_modal = function($modal){
		// var $input_data_location = $modal.find( "input[name=data_location]" );
		var $input_data_date = $modal.find( "input[name=data_date]" );
		var $input_data_type = $modal.find( "input[name=data_type]" );

		var $btn_close = $modal.find(".btn-modal-close");
		var $btn_back = $modal.find(".btn-modal-back");
		var $btn_next_step_date = $modal.find('.btn-next-step-date');
		var $btn_next_step_opportunities = $modal.find('.btn-next-step-opportunities');
		var $btn_next_step_login = $modal.find('.btn-next-step-login');
		var $btn_next_step_confirmation = $modal.find('.btn-next-step-confirmation');
		var $btn_next_step_submit = $modal.find('.btn-next-step-submit');
		var $datepicker_input = $modal.find('#datepicker-input');

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
			$btn_next_step_date.show();
		}
		function onDateClear(){
			$input_data_date.val("");
			$btn_next_step_date.hide();
		}

		$btn_next_step_date.on("click", function(e){
			show_next_step($modal, "opportunities");
			$btn_back.show();
			$btn_back.off();
			$btn_back.on("click", function(){
				show_prev_step($modal, "date");
				$btn_back.hide();
			});
		});

		$btn_next_step_opportunities.on("click", function(e){
			show_next_step($modal, "signup");
			$btn_back.show();
			$btn_back.off();
			$btn_back.on("click", function(){
				show_prev_step($modal, "opportunities");
				// $btn_back.hide();
			});
		});

		$btn_next_step_confirmation.on("click", function(e){
			show_next_step($modal, "confirmation");
			$btn_back.show();
			$btn_back.off();
			$btn_back.on("click", function(){
				show_prev_step($modal, "opportunities");
				// $btn_back.hide();
			});
		});

		$btn_next_step_login.on("click", function(e){
			show_next_step($modal, "login");
			$btn_back.off();
			$btn_back.on("click", function(){
				show_prev_step($modal, "signup");
			});
		});
		$btn_next_step_submit.on("click", function(e){
			show_next_step($modal, "submit");
			$btn_back.hide();
		});

		$btn_close.on("click", function(e){
			$modal.removeClass("show");
			$modal_overlay.removeClass("show");
			
			setTimeout(function(){
				$modal.remove();
			},300);
		});
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
		$(document).on('click', ".js-trigger-volunteer-map", open_modal);	
	});

})();