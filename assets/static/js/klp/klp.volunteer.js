var klp = klp || {};

klp.volunteer2 = (function(){
	var $modal_wrapper,
		$modal_overlay,
		modal_tpl;

	var flow = function(_wrapper){
        var $wrapper,
            $steps,
            $btn_back,
            $prev_step_cache,
            _active_step;

        this.$wrapper = $(_wrapper);
        this.$steps = this.$wrapper.find(".step-item");
        this.$btn_back = this.$wrapper.find(".btn-modal-back");
        this._active_step = 1;
        this.init();
    };
    flow.prototype.init = function(){
    	var self = this;
		this.$wrapper.on('click', ".js-volunteer-next-step", function(e){
			e.preventDefault();
			self.show_next_step();
		});
		this.$wrapper.on('click', ".btn-modal-back", function(e){
			e.preventDefault();
			self.show_prev_step();
		});
		this.$wrapper.on('click', ".btn-modal-close", function(e){
			e.preventDefault();
			self.on_close();
		});

		var $cal_step_next_btn = this.$wrapper.find('.js-next-btn-cal-step');
		var $datepicker_input = this.$wrapper.find('#datepicker-input');

		var $select_state = this.$wrapper.find('#select-cities-state').selectize();

		$datepicker_input.Zebra_DatePicker({
		    always_visible: this.$wrapper.find('#datepicker-wrapper'),
		    first_day_of_week: 0,
		    show_clear_date: false,
		    show_select_today: false,
		    disabled_dates: ['1,3,4,5,12,13,14,22,24'],
		    onSelect: onDateSelect,
		    onClear: onDateClear
		});
		var datepicker = $datepicker_input.data('Zebra_DatePicker');

		function onDateSelect(){
			$cal_step_next_btn.show();
		}
		function onDateClear(){
			$cal_step_next_btn.hide();
		}
	};
    flow.prototype.get_step = function(step_id){
		return this.$wrapper.find('.step-item[data-step="'+ step_id +'"]');
    };
    flow.prototype.show_prev_step = function(){
    	var $step_current = this.get_step(this._active_step);
		var $step_prev = this.get_step(--this._active_step);

		$step_current.removeClass("fadein").addClass("move-right fadeout");
        $step_prev.removeClass("fadeut").addClass("move-left visible");

        // Hide current step
        setTimeout(function(){
            $step_current.removeClass("visible");
        },300);

        setTimeout(function(){
            $step_prev.addClass("fadein").removeClass("move-left");
        },10);

        if(this._active_step == 1){
        	this.$btn_back.hide();
        }
    };
    flow.prototype.show_next_step = function(){
		var $step_current = this.get_step(this._active_step);
		var $step_next = this.get_step(++this._active_step);
		this.$btn_back.show();

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
	flow.prototype.on_close = function(){
		var self = this;
		this.$wrapper.removeClass("show");
		$("#modal_overlay").removeClass("show");
		setTimeout(function(){
			self.$wrapper.remove();
		},300);
	};

	var open_modal = function(e){
		if($(window).width() < 1024){
			return true;
		}

		e.preventDefault();

		var ctx = {
			hide_input_location: false
		}
		// console.log(ctx);

		var html = modal_tpl(ctx);
		$modal_wrapper.append(html);

		var $modal = $modal_wrapper.find(".modal-volunteer");
		var modal_flow = new flow($modal);

		$modal.addClass("show");
		$modal_overlay.addClass("show");
	};

	var init_page_mode = function(){
		var $wrapper = $(".page-volunteer-register").find(".volunteer-flow");
		var page_flow = new flow($wrapper);
	};

	// Reset steps - show first step and reset params
	// var reset = function(){
	// 	_active_step = 1;

	// 	// Hide all steps
	// 	$modal.find('.step-item').removeClass("visible fadein fadeout move-left move-right");
	// 	// Show first step
	// 	$modal.find('.step-item[data-step="1"]').addClass("visible fadein");
	// };

	var init = function(){
		$modal_wrapper = $("#modal_wrapper");
		$modal_overlay = $("#modal_overlay");
		modal_tpl = swig.compile($("#tpl-volunteer-modal").html());

		//$(document).on('click', ".js-trigger-volunteer", open_modal);		
	};

	$(document).ready(function(){
		init();
	});
	
	return {
		init_page_mode : init_page_mode
	};
})();