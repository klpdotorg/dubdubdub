/* vi:si:et:sw=4:sts=4:ts=4 */

'use strict';
(function() {
    var preschoolString = 'PreSchool';
    var schoolString = 'Primary School';

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        loadQuestions('schoolString',[]);
        $('form').stepy({
            next: function(index) {
                var isValid = true;
                if (index == 2) {
                    //validate first step
                    klp.utils.clearValidationErrors('sys_school');
                    isValid = validatePersonalDetails();
                }
                return isValid;
            }
        });
        initImageUploader();
        initializeUser();
        $('#sys_school').submit(function(e) {
            if (e) {
                e.preventDefault();
            }
            var $this = $(this);
            var dataArray = $this.serializeArray();
            var dataObj = {};
            _(dataArray).each(function(a) {
                dataObj[a.name] = a.value;
            });
            // var commentsChars = $('#comments_id').val().length;
            // if (commentsChars > 2000) {
            //     klp.utils.alertMessage("Comments field longer than allowed length. Please fix and try again.", "error");
            //     return;
            // }
            dataObj['images'] = getImagesData();
            var schoolID = dataObj['id'];
            delete dataObj['id'];
            var postURL = "stories/" + schoolID;
            
            var $xhr = klp.api.do(postURL, dataObj, 'POST');
            startFormLoading();
            klp.utils.startSubmit('sys_school');
            $xhr.done(function() {
                var tplSysThanks = swig.compile($('#tpl-sysThanks').html());
                var thanksHTML = tplSysThanks({'id': schoolID});
                $('.js-form-parent').html(thanksHTML);
            });
            $xhr.fail(function() {
                stopFormLoading();
                klp.utils.alertMessage("Failed submitting form. Please check errors and re-submit.", "error");
                $('#sys_school').stepy('step', 1);
            });
        });
    }

    function startFormLoading() {
        klp.utils.startSubmit('sys_school');
        $('.js-finish-btn').prop("disabled", "disabled");
        $('.js-finish-btn').val("Wait...");
    }

    function stopFormLoading() {
        klp.utils.stopSubmit('sys_school');
        $('.js-finish-btn').removeAttr("disabled");
        $('.js-finish-btn').val("Finish!");
    }

    function validatePersonalDetails() {
        var isValid = klp.utils.validateRequired("sys_school");
        var $name = $('#name_id'),
            $email = $('#email_id'),
            $tel = $('#telephone_id'),
            $date = $('#date_id');

        isValid = validateName($name)
                    && validateEmail($email)
                    && validateTel($tel)
                    && validateDate($date);

        if (!isValid) {
            klp.utils.alertMessage("Please correct errors before proceeding.", "error");
        }
        return isValid;
    }
    
    function validateName($input) {
        var name = $input.val();
        if (!validator.matches(name, /^[a-zA-Z\s]*$/)) {
            klp.utils.invalidateField($input, "Please enter a valid name");
            return false;
        }
        return true;
    }

    function validateEmail($input) {
        var email = $input.val();
        if (!validator.isEmail(email)) {
            klp.utils.invalidateField($input, "Please enter a valid e-mail");
            return false;
        }
        return true;
    }

    function validateTel($input) {
        var tel = $input.val();
        if (!validator.isNumeric(tel)) {
            klp.utils.invalidateField($input, "Please enter only numbers");
            return false;
        }
        if (tel.length != 10) {
            klp.utils.invalidateField($input, "Please enter a valid 10 digit number");
            return false;
        }
        return true;
    }

    function validateDate($input) {
        var date = $input.val();
        if (validator.isAfter(date)) {
            klp.utils.invalidateField($input, "Date must be in the past.");
            return false;
        }
        return true;
    }

    function loadQuestions(schoolType, params) {
        var questions = {
            "academic":
            [
                {'question':'Was the school open?','id':1, 'key': 'webs-school-open' },
                {'question':'Was the teacher present in each class?','id':2, 'key': 'webs-teachers-present' },
                {'question':'Are there Sufficient number of class rooms?','id':17, 'key': 'webs-number-classrooms' },
                {'question':'Were at least 50% of the children enrolled present on the day you visited the school?','id':19, 'key': 'webs-50percent-present' },
                {'question':'Is there a Separate office for Headmaster?','id':11, 'key': 'webs-headmaster-office' }
            ],
            "infra":
            [
                {'question':'Is there a Boundary wall/ Fencing?','id':8, 'key': 'webs-boundary-wall' },
                {'question':'Is there Accessibility to students with disabilities?','id':10, 'key': 'webs-access-disability' },
                {'question':'Is there a Play ground?','id':9, 'key': 'webs-playground' },
                {'question':'Are there Play Materials or Sports Equipments?','id':14, 'key': 'webs-play-material' }
            ],   
            "hygiene":
            [            
                {'question':'Are all the toilets in the school functional?','id':4, 'key': 'webs-all-toilets-functional' },
                {'question':'Does the school have a separate functional toilet for girls?','id':5, 'key': 'webs-separate-toilets' },
                {'question':'Does the school have drinking water?','id':6, 'key': 'webs-drinking-water' },
                {'question':'Is a Mid Day Meal served in the school?','id':7, 'key': 'webs-food-being-cooked' },
                {'question':'Is there a Separate room as Kitchen / Store for Mid day meals?','id':12, 'key': 'webs-separate-food-store' }
            ],
            "learning":
            [
                {'question':'Is there Teaching and Learning material?','id':16, 'key': 'webs-tlm' },
                {'question':'Is there a Library?','id':13, 'key': 'webs-library' },
                {'question':'Is there a Designated Librarian/Teacher?','id':15, 'key': 'webs-designated-librarian' }
                
            ]              
        };
        var tplSysSchool = swig.compile($('#tpl-sysSchool').html());  
        var table_start =  '<table class="table-base table-list-view table-base-sys">' +
                    '<tbody><tr class="table-base-heading">' +
                    '<th class="grey-silver">Just a few questions more...</th>' +
                    '<th></th>' +
                    '<th></th>' +
                    '<th></th>' +
                    '</tr>';
        var table_end = '</tbody></table>';

        var html = table_start + tplSysSchool({'questions':questions["academic"]}) + table_end;      
        $('#sysqset1_school').html(html);
        html = table_start + tplSysSchool({'questions':questions["infra"]}) + table_end;      
        $('#sysqset2_school').html(html);
        html = table_start + tplSysSchool({'questions':questions["hygiene"]}) + table_end;      
        $('#sysqset3_school').html(html);
        html = table_start + tplSysSchool({'questions':questions["learning"]}) + table_end;      
        $('#sysqset4_school').html(html);
    }

    function initializeUser() {
        if (klp.auth.getToken()) {
            klp.api.authDo("users/profile").done(function(data) {
                $('#name_id').val(data.first_name + " " + data.last_name);
                $('#email_id').val(data.email);
                $('#telephone_id').val(data.mobile_no);
            });
        }
    }

    function initImageUploader() {
        var MAX_IMAGES = 5;
        var dropZone = $('#images_dropzone').get(0);
        dropZone.addEventListener("dragenter", function(e) { e.stopPropagation(); e.preventDefault(); return false; }, false);
        dropZone.addEventListener("dragover", function(e) { e.stopPropagation(); e.preventDefault(); return false; }, false);
        dropZone.addEventListener("drop", function(e) {
            e.preventDefault();
            e.stopPropagation();
            var files = e.dataTransfer.files;
            for (var i=0; i<files.length; i++) {
                var fil = files[i];
                addImagePreview(fil);
            }
        });
        $('#multiImageUpload').change(function(e) {
            var t = this;
            var currentImageCount = $('.js-image-preview').length;
            for (var i=0; i<t.files.length; i++) {
                if (currentImageCount >= MAX_IMAGES) {
                    klp.utils.alertMessage("Cannot add more than " + MAX_IMAGES + " images.", "error");
                    break;
                }
                var f = t.files[i];
                addImagePreview(f);
                currentImageCount++;
            }
        });
    }

    function addImagePreview(image) {
        if (!image.type.match('image.*')) {
            return;
        }

        var reader = new FileReader();
        var resizeOptions = {
            'maxWidth': 800,
            'maxHeight': 600
        };
        reader.onload = (function(imageFile) {
            return function(e) {
                resizeImage(e.target.result, resizeOptions, function(resizedImage) {
                    var $img = $('<img />')
                                .prop("height", "100")
                                .prop("width", "100")
                                .addClass('js-image-preview')
                                .addClass('image-preview')
                                .attr("src", resizedImage)
                                .appendTo('#imagePreviews');
                    $img.click(function(e) {
                        if (confirm("Do you wish to remove this image?")) {
                            $(this).remove();
                        }
                    });
                });

            };
        })(image);  
        reader.readAsDataURL(image);
    }

    function resizeImage(imageDataURI, options, callback) {
        var opts = $.extend({
            'maxWidth': 800,
            'maxHeight': 600
        }, options);
        var tempImg = new Image();
        tempImg.src = imageDataURI;
        tempImg.onload = function() {
 
            var MAX_WIDTH = opts.maxWidth;
            var MAX_HEIGHT = opts.maxHeight;
            var tempW = tempImg.width;
            var tempH = tempImg.height;
            if (tempW > tempH) {
                if (tempW > MAX_WIDTH) {
                   tempH *= MAX_WIDTH / tempW;
                   tempW = MAX_WIDTH;
                }
            } else {
                if (tempH > MAX_HEIGHT) {
                   tempW *= MAX_HEIGHT / tempH;
                   tempH = MAX_HEIGHT;
                }
            }
 
            var canvas = document.createElement('canvas');
            canvas.width = tempW;
            canvas.height = tempH;
            var ctx = canvas.getContext("2d");
            ctx.drawImage(this, 0, 0, tempW, tempH);
            var dataURL = canvas.toDataURL("image/jpeg");
            callback(dataURL);
        }
    }

    function getImagesData() {
        var images = [];
        $('.js-image-preview').each(function() {
            var src = $(this).attr('src');
            if (src) {
                images.push(src);
            }
        });
        return images;
    }

})();