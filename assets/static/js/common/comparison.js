/*
    Handles all JS for compare modal, accessible on map and school pages.
 */

(function(){

    var $compare_flow,
        $dropdown_wrapper,
        $btn_comparison_cancel,
        $btn_comparison_submit,
        $comparison_option_left,
        $comparison_option_right,
        $comparison_default_right,
        $trigger,
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

    var fetchInfraFacilities = function(entity) {
        var $deferred = $.Deferred();
        var isPreschool = entity.type.id === 2;
        if (isPreschool) {
            var $xhr = klp.api.do("/schools/school/" + entity.id + "/infrastructure");
            $xhr.done(function(data) {
                $deferred.resolve(data);
            });
        } else { // is primary school, fetch data from DISE API
            if (entity.dise_code) {
                var $xhr = klp.dise_api.fetchSchoolInfra(entity.dise_code);
                $xhr.done(function(data) {
                    var facilities = klp.dise_infra.getFacilitiesData(data.properties);
                    $deferred.resolve({'facilities': facilities});
                });
                $xhr.fail(function(err) {
                    klp.utils.alertMessage("Temporary error loading infrastructure data.");
                    $deferred.resolve({'factilities': {}});
                });
            } else {
                setTimeout(function() {
                    $deferred.resolve({'facilities': {}});
                }, 0);
            }
        }
        return $deferred;
    };

    var fetchData = function(entity) {
        console.log("compare entity", entity);
        var schoolURL = '/schools/school/' + entity.id;
        var endpoints = [
            //schoolURL + '/infrastructure',
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
            var facilitiesXHR = fetchInfraFacilities(entity);
            facilitiesXHR.done(function(facilities) {
                entity.infrastructure_data = facilities;
                entity.finance_data = data[endpoints[0]];
                entity.demographics_data = data[endpoints[1]];
                $deferred.resolve(entity);
            });
        });
        apiXHR.fail(function(err) {
            alert("failed to load school data");
            $deferred.reject(err);
        });
        return $deferred;
    };

    var getContext = function(entity) {
        // console.log("get context called with ", entity);
        var context = $.extend(entity, klp.utils.getBoyGirlPercents(entity.num_boys, entity.num_girls));
        var mt = klp.utils.getMTProfilePercents(entity.demographics_data.mt_profile);
        context.mt_profile_percents = mt.percents || {};
        context.total_mt = mt.total;
        context.hasFinanceData = entity.finance_data.sg_amount || entity.finance_data.smg_amount || entity.finance_data.tlm_amount;
        if (context.hasFinanceData) {
            context.finance_percents = klp.utils.getFinancePercents(entity.finance_data);
        }
        context.studentTeacherRatio = klp.utils.getStudentTeacherRatio(entity.infrastructure_data);
        context.hasStudents = entity.num_boys || entity.num_girls;
        return context;
    };

    var getMTProfiles = function(entity1, entity2) {
        var mt1 = entity1.mt_profile_percents || {};
        var mt2 = entity2.mt_profile_percents || {};
        // console.log("mt1", mt1, "mt2", mt2);
        var allLanguages = _(_(mt1).keys().concat(_(mt2).keys())).unique();
        // console.log("all languages", allLanguages);
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
        // console.log("mts", mts);
        return mts;
    };

    var getInfrastructureComparison = function(entity1, entity2) {
        var data1 = entity1.infrastructure_data.facilities || {};
        var data2 = entity2.infrastructure_data.facilities || {};
        var topLevelKeys = _(_(data1).keys().concat(_(data2).keys())).unique();
        var allOptions = {};
        _(topLevelKeys).each(function(key) {
            if (key in data1 && key in data2) {
                var arr = _(_(data1[key]).keys().concat(_(data2[key]).keys())).unique();
            } else if (key in data1) {
                var arr = _(data1[key]).keys();
            } else {
                var arr = _(data2[key]).keys();
            }
            allOptions[key] = arr;
        });
        var data = {};
        _(allOptions).each(function(value, key) {
            data[key] = {};
            _(allOptions[key]).each(function(nestedKey) {
                data[key][nestedKey] = {
                    'entity1': getInfrastructureItem(data1, key, nestedKey),
                    'entity2': getInfrastructureItem(data2, key, nestedKey)
                }
            });
        });
        // console.log("infrastructure compare data ", data);
        return data;
    };

    var getInfrastructureItem = function(entity, key, nestedKey) {
        if (!entity.hasOwnProperty(key) || !entity[key].hasOwnProperty(nestedKey)) {
            return 'grey';
        }
        var hasInfra = entity[key][nestedKey];
        if (hasInfra) {
            return 'green';
        } else {
            return 'red';
        }
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
        // console.log("compare open called with ", entity1);
        //
        $trigger.click();
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

    var openFromURL = function(compareString) {
        var entities = compareString.split(",")
        if (entities.length !== 2) {
            //invalid URL Hash, must be like "3537,4219"
            return;
        }
        var $xhr1 = klp.api.do("schools/school/" + entities[0]);
        var $xhr2 = klp.api.do("schools/school/" + entities[1]);
        $.when($xhr1, $xhr2).done(function(school1, school2) {
            open(school1);
            selectOptionRight(school2);
            $btn_comparison_submit.click();
        });
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
        klp.router.setHash(null, {compare: null}, {trigger: false});
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
        $dropdown_wrapper.removeClass("show");
        entityTwo = entityTwoXHR = null;
        reset_submit_button();
    };
    var show_options_dropdown_right = function(e){
        e.preventDefault();
        $dropdown_wrapper.addClass("show");
    };

    var init = function() {
        $trigger = $('<div />');
        $trigger.rbox({
            'type': 'inline',
            'inline': '#tpl-compare-flow',
            'onopen': afterOpen,
            'onclose': function() {
                entityOne = entityTwo = entityOneXHR = entityTwoXHR = null;
                klp.router.setHash(null, {compare: null}, {trigger: false});
            }
        });

        klp.router.events.on('hashchange:compare', function(e, params) {
            // console.log("change params", params);
            var changedCompare = params.changed.compare;
            if (changedCompare.newVal) {
                openFromURL(changedCompare.newVal);
            } else {
                close();
            }
        });
    };

    var afterOpen = function(){
        console.log("called afterOpen");
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
                        school_type: entityOne.type.id === 1 ? 'primaryschools' : 'preschools'
                    };
                },
                results: function (data, page) {
                    //console.log("data", data);
                    return {results: data.features};
                }
            },
            formatResult: function(item) {
                var html = '';
                html += item.name + '<br />';
                html += '<i>' + item.admin1.name + ', ' + item.admin2.name + ', ' + item.admin3.name + '</i>';
                return html;
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

        $('.js-comparison-clear-left').click(clear_option_left);
        $('.js-comparison-clear-right').click(clear_option_right);

        $('.js-btn-compare').click(function(e) {
            e.preventDefault();
            $.when(entityOneXHR, entityTwoXHR).done(function(data1, data2) {
                //console.log("compare xhrs done ", data1, data2);
                // console.log("school1", data1, "school2", data2);
                var school1 = getContext(data1);
                var school2 = getContext(data2);

                var context = {
                    'school1': school1,
                    'school2': school2,
                    'comparison_type': klp.utils.getSchoolType(school1.type.id),
                    'mt_profiles': getMTProfiles(school1, school2),
                    'infrastructure': getInfrastructureComparison(school1, school2)
                };
                var html = templates['comparison-result'](context);
                //console.log('comparison result html', html);
                $comparison_result_wrapper.html(html);
                $comparison_result_wrapper.html(html).addClass('show');
                var urlString = [school1.id, school2.id].join(",")
                //console.log("url string", urlString);
                klp.router.setHash(null, {'compare': urlString}, {trigger: false});
                setTimeout(function(){
                    init_comparison_charts(context);
                    $(window).resize();
                },100);
                //var html = templates['comparison-result'](context);
            });
            $btn_comparison_submit.removeClass("show");
        });
    };

    klp.comparison = {
        init: init,
        open: open,
        close: close
    };

    function init_comparison_charts(context) {
        var chart_width = 170;
        var s1 = context.school1;
        var s2 = context.school2;
        // console.log("charts init called with ", context);
        var chartOptions = {
            innerSize: '85%',
            width: chart_width,
            height: chart_width
        };

        $('#comparison_boygirlchart_1').boyGirlChart(s1, chartOptions);

        $('#comparison_boygirlchart_2').boyGirlChart(s2, chartOptions);

        if (s1.hasFinanceData) {
            $('#comparison_financechart_1').financeChart(s1.finance_percents, chartOptions);
        }

        if (s2.hasFinanceData) {
            $('#comparison_financechart_2').financeChart(s2.finance_percents, chartOptions);
        }

    }
})();
