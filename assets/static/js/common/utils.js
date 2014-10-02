(function() {
    klp.utils = {
        compile_templates: function() {
            var $raw_tpls = $(".tpl-raw");
            var _tpl = {};
            if(!$raw_tpls.length){
                return _tpl;
            }
            $raw_tpls.each(function( index ) {
                var name = $(this).data("tpl");
                var content = $(this).html();

                _tpl[name] = swig.compile(content);
            });
            return _tpl;
        },
        
        mapIcon: function (type) {

            // FIXME: May be fix this in the icon name.
            // This is Sanjay's fault.
            type = type.replace(' ', '').toLowerCase();
            if (type === 'primaryschool') {
                type = 'school';
            }
            if (type === 'primaryschool_district') {
                type = 'school_district';
            }
            if (type === 'primaryschool_block') {
                type = 'school_block';
            }
            if (type === 'primaryschool_cluster') {
                type = 'school_cluster';
            }
            return L.icon({
                iconUrl: '/static/images/map/icon_'+type+'.png',
                iconSize: [20, 30],
                iconAnchor: [10, 26],
                popupAnchor: [0, -25]
            });
        },

        alertMessage: function(message, status) {
            // Status - error, success, warning.
            var $alert = $('<div />')
                            .addClass('alert')
                            .hide()
                            .text(message)
                            .appendTo('body')
                            .slideDown(250);

            if (status) {
                $alert.addClass(status);
            }
            setTimeout(function() {
                $alert.slideUp(500, function() {
                    $alert.remove();
                });
            }, 3000);
            //alert(message);
        },

        getRelativeHeight: function (width, height, min_height, container_width){
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
        },

        getMTProfilePercents: function(mt_profile) {
            if (!mt_profile || _.isEmpty(mt_profile)) {
                return {
                    total: 0,
                    percents: {}
                };
            }
            var total_mts = _(_(mt_profile).values()).reduce(function(a, b) {
                return a + b;
            });
            mt_profile_percents = {};
            _(_(mt_profile).keys()).each(function(mt) {
                mt_profile_percents[mt] = ((mt_profile[mt] / total_mts) * 100).toFixed(2);
            });
            return {
                total: total_mts,
                percents: mt_profile_percents
            };           
        },

        getStudentTeacherRatio: function(data) {
            var numBoys = data.num_boys_dise || 0;
            var numGirls = data.num_girls_dise || 0;
            var totalStudents = numBoys + numGirls;
            var numTeachers = data.teacher_count || null;
            if (numTeachers) {
                return parseInt(totalStudents / numTeachers);
            } else {
                return false;
            }
        },

        getBoyGirlPercents: function(num_boys, num_girls) {
            var total_students = num_boys + num_girls;
            var percent_boys = Math.round((num_boys / total_students) * 100);
            var percent_girls = Math.round((num_girls / total_students) * 100);
            return {
                total_students: total_students,
                percent_boys: percent_boys,
                percent_girls: percent_girls
            };
        },

        getFinancePercents: function(financeData) {
            var sgAmount = financeData.sg_amount ? financeData.sg_amount : 0;
            var smgAmount = financeData.smg_amount ? financeData.smg_amount : 0;
            var tlmAmount = financeData.tlm_amount ? financeData.tlm_amount : 0;
            var total = sgAmount + smgAmount + tlmAmount;
            return {
                'sg': ((sgAmount / total) * 100).toFixed(2),
                'smg': ((smgAmount / total) * 100).toFixed(2),
                'tlm': ((tlmAmount / total) * 100).toFixed(2)
            }
        },

        addSchoolContext: function(data) {
            data.has_num_students = data.num_boys && data.num_girls;
            data = $.extend(data, klp.utils.getBoyGirlPercents(data.num_boys, data.num_girls));
            if (data.hasOwnProperty('mt_profile')) {
                data.mt_profile_percents = klp.utils.getMTProfilePercents(data.mt_profile).percents;
            }
            return data;
        },

        getFormData: function(fields) {
            var data = {};
            _(_(fields).keys()).each(function(key) {
                data[key] = fields[key].val();
            });
            return data;
        },

        invalidateField: function($field, message) {
            $field.addClass('error');
            var $error = $('<div />').addClass('error-message mt-5');
            $error.text(message);
            $field.after($error);
        },

        invalidateErrors: function(fields, errors) {
            _(_(errors).keys()).each(function(errorKey) {
                var errorMsg = errors[errorKey];
                var $field = fields[errorKey];
                klp.utils.invalidateField($field, errorMsg);
            });
        },

        validateRequired: function(formID) {
            var $form = $('#' + formID);
            var isValid = true;
            $form.find('[data-required=true]').each(function() {
                var $this = $(this);
                if ($this.val() === '') {
                    isValid = false;
                    klp.utils.invalidateField($this, "This field is required.");
                }
            });
            return isValid;
        },

        clearValidationErrors: function(formID) {
            var $form = $('#' + formID);
            $form.find('.error').removeClass('error');
            $form.find('.error-message').remove();
        },

        clearForm: function(formID) {
            $('#' + formID).find('input, select').not('[type=submit]').each(function() {
                $(this).val('');
            });
            klp.utils.clearValidationErrors(formID);
        },

        startSubmit: function(formID) {
            var $form = $('#' + formID);
            $form.find('.js-submit-btn').hide();
            $form.find('.js-submit-loading').show();
        },

        stopSubmit: function(formID) {
            var $form = $('#' + formID);
            $form.find('.js-submit-btn').show();
            $form.find('.js-submit-loading').hide();            
        },

        schoolSelect2: function($elem, options) {
            $elem.select2({
                placeholder: 'Search for schools...',
                minimumInputLength: 3,
                quietMillis: 300,
                allowClear: true,
                initSelection: function(element, callback) {
                    var id = $(element).val();
                    if (id !== '') {
                        var url = "schools/school/" + id;
                        var $xhr = klp.api.do(url);
                        $xhr.done(function(response) {
                            callback({
                                'id': response.id,
                                'name': response.name
                            })
                        });
                    }
                },
                ajax: {
                    url: "/api/v1/schools/info",
                    quietMillis: 300,
                    allowClear: true,
                    data: function (term, page) {
                        return {
                            search: term
                        };
                    },
                    results: function (data, page) {
                        //console.log("data", data);
                        return {results: data.features};
                    }
                },
                formatResult: function(item) {
                    return item.name;
                },
                formatSelection: function(item) {
                    return item.name;
                }
            });
        },

        getSchoolType: function(id) {
            return id === 1 ? 'school' : 'preschool';
        }
    };

})();
