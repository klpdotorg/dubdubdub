(function(){

    var $compare_flow,
        $dropdown_wrapper,
        $btn_comparison_cancel,
        $btn_comparison_submit,
        $comparison_option_left,
        $comparison_option_right,
        $comparison_default_right,
        $comparison_result_wrapper;

    var templates = {};

    var entityOne = null,
        entityTwo = null,
        entityOneXHR,
        entityTwoXHR;

    var getCompareOptionHTML = function(data) {
        data.type_name = data.type.id === 1 ? 'school' : 'preschool';
        return templates['compare-option'](data);
    };

    var fetchData = function(entity) {
        var schoolURL = '/schools/school/' + entity.id;
        var endpoints = [
            schoolURL + '/infrastructure',
            schoolURL + '/finance',
            schoolURL + '/demographics'
        ];
        var endpointsParamsString = _(endpoints).map(function(s) {
            return 'endpoints=' + s;
        }).join('&');
        var $deferred = $.Deferred();
        var apiURL = 'merge?' + endpointsParamsString;
        var apiXHR = klp.api.do(apiURL);
        apiXHR.done(function(data) {
            entity.infrastructure_data = data[endpoints[0]];
            entity.finance_data = data[endpoints[1]];
            entity.demographics_data = data[endpoints[2]];
            $deferred.resolve(entity);
        });
        apiXHR.fail(function(err) {
            alert("failed to load school data");
            $deferred.reject(err);
        });
        return $deferred;
    };

    var getContext = function(entity) {
        var context = $.extend(entity, klp.utils.getBoyGirlPercents(entity.num_boys, entity.num_girls));
        var mt = klp.utils.getMTProfilePercents(entity.demographics_data.mt_profile);
        context.mt_profile_percents = mt.percents;
        context.total_mt = mt.total;
        return context;
    };

    var getMTProfiles = function(entity1, entity2) {
        var mt1 = entity1.mt_profile_percents;
        var mt2 = entity2.mt_profile_percents;
        var allLanguages = _(_(mt1).keys().concat(_(mt2).keys())).unique();
        console.log("all languages", allLanguages);
        var mts = {};
        _(allLanguages).each(function(lang) {
            mts[lang] = {};
            mts[lang].school1 = {
                'percent': mt1.hasOwnProperty(lang) ? mt1[lang] : 0,
                'total': entity1.demographics_data.mt_profile.hasOwnProperty(lang) ? entity1.demographics_data.mt_profile[lang] : 0
            };
            mts[lang].school2 = {
                'percent': mt2.hasOwnProperty(lang) ? mt2[lang] : 0,
                'total': entity2.demographics_data.mt_profile.hasOwnProperty(lang) ? entity2.demographics_data.mt_profile[lang] : 0               
            };
        });
        console.log("mts", mts);
        return mts;
    };

    var selectOptionRight = function(entity) {
        entityTwo = entity;
        entityTwoXHR = fetchData(entity);
        var html = getCompareOptionHTML(entity);
        //console.log("right html", html);
        $dropdown_wrapper.removeClass("show");
        $comparison_option_right.html(html);
        $comparison_default_right.hide();
        $comparison_option_right.removeClass('hide').show();
        show_submit_button();
    };

    var open = function(entity1){
        //e.preventDefault();
        console.log("compare open called with ", entity1);
        if(klp.map){
            klp.map.closePopup();
        }
        entityOne = entity1;
        entityOneXHR = fetchData(entity1);
        var html = getCompareOptionHTML(entity1);
        $comparison_option_left.html(html);
        //klp.place_info.close_place();
        $comparison_result_wrapper.removeClass('show');

        $compare_flow.removeClass("hide");
        setTimeout(function(){
            $compare_flow.removeClass("hide").addClass("show");
        },0);
    };

    var close = function(e){
        e.preventDefault();
        $compare_flow.removeClass("show");
        entityOne = entityTwo = entityOneXHR = entityTwoXHR = null;
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

    var init = function(){
        $compare_flow = $("#compare_flow");
        $dropdown_wrapper = $('#dropdown_wrapper');

        $btn_comparison_cancel = $compare_flow.find(".js-btn-cancel");
        $btn_comparison_submit = $compare_flow.find(".js-btn-compare");

        $comparison_option_left = $(".js-comparison-option-left");
        $comparison_option_right = $(".js-comparison-option-right");
        $comparison_default_right = $(".js-comparison-default-right");

        $comparison_result_wrapper = $(".js-comparison-result-wrapper");
        $comparison_search = $("#comparison-search-select");
        _(['compare-option', 'comparison-result']).each(function(templateName) {
            var html = $('#tpl-' + templateName).html();
            //console.log("html", templateName, html);
            templates[templateName] = swig.compile(html);
        });

        $comparison_search.select2({
            placeholder: 'Search for schools...',
            minimumInputLength: 3,
            quietMillis: 300,
            allowClear: true,
            ajax: {
                url: "/api/v1/schools/info",
                quietMillis: 300,
                allowClear: true,
                data: function (term, page) {
                    return {
                        search: term,
                        type: entityOne.type.id === 1 ? 'primaryschools' : 'preschools'
                    };
                },
                results: function (data, page) {
                    //console.log("data", data);
                    return {results: data.features};
                }
            },
            formatResult: function(item) {
                return item.name;
                // console.log("item", item);
                // return {
                //     id: item.id,
                //     text: item.name,
                //     data: item
                // }
            },
            formatSelection: function(item) {
                return item.name;
            }
        });

        $comparison_search.on("change", function(e) {
            //console.log("changed event ", e);
            var data = e.added;
            selectOptionRight(data);
        });

        //$(document).on('click', ".js-trigger-compare", open);
        $(document).on('click', ".js-comparison-close", close);
        $(document).on('click', ".js-comparison-clear-left", clear_option_left);
        $(document).on('click', ".js-comparison-clear-right", clear_option_right);
        $(document).on('click', ".js-comparison-show-options-right", show_options_dropdown_right);
        //$(document).on('click', ".js-dropdown-option-right", select_options_right);
        $(document).on('click', ".js-btn-compare", function(e){
            e.preventDefault();
            $.when(entityOneXHR, entityTwoXHR).done(function(data1, data2) {
                //console.log("compare xhrs done ", data1, data2);
                var school1 = getContext(data1);
                var school2 = getContext(data2);
                var context = {
                    'school1': school1,
                    'school2': school2,
                    'mt_profiles': getMTProfiles(school1, school2)
                };
                var html = templates['comparison-result'](context);
                //console.log('comparison result html', html);
                $comparison_result_wrapper.html(html);
                $comparison_result_wrapper.html(html).addClass('show');
                setTimeout(function(){
                    var $selects = $comparison_result_wrapper.find('select');
                    $selects.easyDropDown();
                },0);

                setTimeout(function(){
                    init_comparison_charts(context);
                },100);                
                //var html = templates['comparison-result'](context);
            });
            $btn_comparison_submit.removeClass("show");
            //var html = klp._tpl.comparison_result();
            //$comparison_result_wrapper.html(html).addClass('show');


        });
    };

    klp.comparison = {
        init: init,
        open: open,
        close: close
    };

    function init_comparison_charts(context) {
        var chart_width = 300;
        var s1 = context.school1;
        var s2 = context.school2;
        var boyGirlChartOptions = {
            innerSize: '85%',
            width: chart_width,
            height: chart_width
        };
        $('#comparison_boygirlchart_1').boyGirlChart(s1, boyGirlChartOptions);

        $('#comparison_boygirlchart_2').boyGirlChart(s2, boyGirlChartOptions);

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
})();