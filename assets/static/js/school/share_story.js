(function() {
    
    var t = klp.share_story = {};
    var tplSysForm = swig.compile($('#tpl-share-story-form').html());
    t.init = function(schoolId, originalHTML) {
        //var originalHTML = $container.html();
        $(document).on("click", "#trigger_share_story_form", function(e) {
            e.preventDefault();
            klp.router.setHash(null, {'state': 'form'}, {trigger: false});
            var questionsURL = 'stories/' + schoolId + '/questions';
            var $xhr = klp.api.do(questionsURL);
            $xhr.done(function(data) {
                var html = tplSysForm(data);
                //console.log("oldHtml", oldHtml);
                $('.tab-content[data-tab=share-story]').html(html);
                doPostFormRender();

            });
        });
    };

    function doPostFormRender() {
        initializeUser();
        $('[name=image]').imagePreview();
        //datepicker 
        $(".js-input-date").pickadate({
            format: 'yyyy-mm-dd',
            formatSubmit: 'yyyy-mm-dd'
        });
        $('#comments_id').maxChars({
            'max': 2000
        });
        $('#sysForm').submit(function(e) {
            if (e) {
                e.preventDefault();
            }
            var $this = $(this);
            var dataArray = $this.serializeArray();
            var dataObj = {};
            _(dataArray).each(function(a) {
                dataObj[a.name] = a.value;
            });
            var commentsChars = $('#comments_id').val().length;
            if (commentsChars > 2000) {
                klp.utils.alertMessage("Comments field longer than allowed length. Please fix and try again.", "error");
                return;
            }
            dataObj['images'] = getImagesData();
            var postURL = "stories/" + SCHOOL_ID;
            // console.log("data obj", dataObj);
            var $xhr = klp.api.do(postURL, dataObj, 'POST');
            klp.utils.startSubmit('sysForm');
            $xhr.done(function() {
                klp.utils.alertMessage("Thank you for submitting your story!", "success");
                klp.router.setHash(null, {state: null});
                klp.utils.stopSubmit('sysForm');
            });
            $xhr.fail(function() {
                klp.utils.stopSubmit('sysForm');
                klp.utils.alertMessage("Failed submitting form. Please check errors and re-submit.", "error");
            });
        });
    }

    function initializeUser() {
        if (klp.auth.getToken()) {
            klp.api.authDo("users/profile").done(function(data) {
                $('#name_id').val(data.first_name + " " + data.last_name);
                $('#email_id').val(data.email);
                $('#telephone').val(data.mobile_no);
            });
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
