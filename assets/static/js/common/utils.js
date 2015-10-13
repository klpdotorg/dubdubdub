/*
    Bunch of utility methods used all over the place
    FIXME: clean-up this file a bit. Remove this message when done.
 */

(function() {
    klp.utils = {

        /*
            Helper function to precompile templates with class tpl-raw
            Those templates will need a data-tpl attribute with a name
            See usage in map/init.js
         */
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
        
        /*
            Returns a Leaflet map icon based on type of entity
            For new types / icons:
              Add icons in /static/images/map/icon_<type>.png
              And add the type -> name mapping below                
        */
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

        /*
            Function to display the alert boxes at top of screen
            Remains for 3 seconds, then goes away
            TODO: Make timeout a param
         */
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

        /*
            Filters out empty geometries from a geojson
         */
        filterGeoJSON: function(geojson) {
            return geojson.features.filter(emptyGeom);

            function emptyGeom(feature) {
                return !_.isEmpty(feature.geometry);
            }
        },

        /*
            FIXME: I really hope we are not using this function anywhere.
         */
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

        /*
            Get percentage values for mt (mother-tongue) profile data
         */
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

        /*
            Get ratio for students:teachers given school data
            Returns an integer value
         */
        getStudentTeacherRatio: function(data) {
            var numBoys = data.num_boys_dise || 0;
            var numGirls = data.num_girls_dise || 0;
            var totalStudents = numBoys + numGirls;
            var numTeachers = data.teacher_count || null;
            if (numTeachers) {
                //FIXME: use Math.round ?
                return parseInt(totalStudents / numTeachers);
            } else {
                return false;
            }
        },

        /*
            Get percentage values and total given num_boys and num_girls
         */
        getBoyGirlPercents: function(num_boys, num_girls) {
            num_boys = num_boys ? parseInt(num_boys) : 0;
            num_girls = num_girls ? parseInt(num_girls) : 0;
            var total_students = num_boys + num_girls;
            var percent_boys = Math.round((num_boys / total_students) * 100);
            var percent_girls = Math.round((num_girls / total_students) * 100);
            return {
                total_students: total_students,
                percent_boys: percent_boys,
                percent_girls: percent_girls
            };
        },

        /*
            Get percentage values for finance data
         */
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

        /*
            Given school data, it adds some values to it and returns the data object:
              has_num_students
              total_students
              percent_boys
              percent_girls
              mt_profile_percents
         */
        addSchoolContext: function(data) {
            data.has_num_students = data.num_boys && data.num_girls;
            data = $.extend(data, klp.utils.getBoyGirlPercents(data.num_boys, data.num_girls));
            if (data.hasOwnProperty('mt_profile')) {
                data.mt_profile_percents = klp.utils.getMTProfilePercents(data.mt_profile).percents;
            }
            return data;
        },

        /*
            Params:
                fields <object> is a mapping of names to DOM elements
                data <object> is a mapping of names to values
            Populates all the DOM elements with data for corresponding name fields. 
         */
        populateForm: function(fields, data) {
            _(_(fields).keys()).each(function(key) {
                var $field = fields[key];
                if ($field.is('[data-type=image]')) {
                    if (data[key]) {
                        var $imagePreview = $field.parent().find('.js-image-preview');

                        //FIXME: avoid hard-coding "/media/", get from settings or so
                        var imageSrc = "/media/" + data[key];
                        $imagePreview.attr("src", imageSrc);
                    }
                } else {    
                    $field.val(data[key]);
                }
            });
        },

        /*
            Params:
                fields <object>
            Returns form data for all fields specified.
         */
        getFormData: function(fields) {
            var data = {};
            _(_(fields).keys()).each(function(key) {
                var $field = fields[key];
                if ($field.attr('type') === 'checkbox') {
                    data[key] = $field.is(":checked");
                } else if ($field.is('[data-type=image]')) {
                    var imageData = $field.parent().find('.js-image-preview').attr('src');
                    if (imageData) {
                        //remove first part of b64data
                        var fileData = imageData.split(",")[1];
                        data[key] = fileData;
                    } else {
                        data[key] = ''; //FIXME: UGLY!!
                    }
                } else {
                    data[key] = fields[key].val();
                }
            });
            return data;
        },

        /*
            Show error message on a field
            Params:
                $field - jQuery element - field to show error on
                message - <string> - error message to show
         */
        invalidateField: function($field, message) {
            //remove existing errors
            $field.parent().find('.error-message').remove();

            $field.addClass('error');
            var $error = $('<div />').addClass('js-error-message error-message');
            $error.text(message);
            $field.parents(".form-field-wrap").append($error);
            //$field.after($error);
        },

        /*
            Pass in multiple errors to invalidate fields
         */
        invalidateErrors: function(fields, errors) {
            _(_(errors).keys()).each(function(errorKey) {
                var errorMsg = errors[errorKey];
                var $field = fields[errorKey];
                klp.utils.invalidateField($field, errorMsg);
            });
        },


        /*
            Check all inputs in a form with data-required=true
            and invalidate them if they contain no data
         */
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

        /*
            Clear all validation errors on a form
         */
        clearValidationErrors: function(formID) {
            var $form = $('#' + formID);
            $form.find('.error').removeClass('error');
            $form.find('.js-error-message, .error-message').remove();
        },

        /*
            Set all values in a form to blank
         */
        clearForm: function(formID) {
            $('#' + formID).find('input, select').not('[type=submit]').each(function() {
                $(this).val('');
            });
            klp.utils.clearValidationErrors(formID);
        },

        /*
            Show loading for form
         */
        startSubmit: function(formID) {
            var $form = $('#' + formID);
            $form.find('.js-submit-btn').hide();
            $form.find('input, textarea, select').attr('disabled', 'disabled');
            $form.find('.js-submit-loading').show();
        },

        /*
            Stop showing loading for form
         */
        stopSubmit: function(formID) {
            var $form = $('#' + formID);
            $form.find('.js-submit-btn').show();
            $form.find('input, textarea, select').removeAttr('disabled');
            $form.find('.js-submit-loading').hide();            
        },

        /*
            Instantiate select2 on an element to search for schools
         */
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

        /*
            Get school type as a string when passed a type id
         */
        getSchoolType: function(id) {
            return id === 1 ? 'school' : 'preschool';
        },

        /*
            Open an rbox model given some html
            FIXME: FIXME
         */
        openModal: function(html) {
            var $trigger = $('<div />');
            $trigger.rbox({
                'type': 'html',
                'html': html
            });
            $trigger.click();
        }
    };

})();
