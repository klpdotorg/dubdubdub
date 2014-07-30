(function(){

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

        if(klp.map){
            klp.map.closePopup();
        }

        klp.place_info.close_place();
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
            var html = klp._tpl.comparison_result();
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

    klp.comparison = {
        init: init,
        close: close
    };
})();