(function() {

   $.extend( true, jQuery.fn, {        
        imagePreview: function( options ){          
            var defaults = {};
            if( options ){
                $.extend( true, defaults, options );
            }
            $.each( this, function(){
                var $this = $( this );              
                $this.bind( 'change', function( evt ){

                    var files = evt.target.files; // FileList object
                    // Loop through the FileList and render image files as thumbnails.
                    for (var i = 0, f; f = files[i]; i++) {
                        // Only process image files.
                        if (!f.type.match('image.*')) {
                            continue;
                        }
                        var reader = new FileReader();
                        // Closure to capture the file information.
                        reader.onload = (function(theFile) {
                            return function(e) {
                                // Render thumbnail.
                                $this
                                    .parents('.field-container')
                                    .find('.imagePreview')
                                    .attr('src',e.target.result);                         
                            };
                        })(f);
                        // Read in the image file as a data URL.
                        reader.readAsDataURL(f);
                    }

                });
            });
        }   
    });

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
        $('[name=image]').imagePreview();
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
            dataObj['images'] = getImagesData();
            var postURL = "stories/" + SCHOOL_ID;
            console.log("data obj", dataObj);
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

    function getImagesData() {
        var images = [];
        $('.imagePreview').each(function() {
            var src = $(this).attr('src');
            if (src) {
                images.push(src);
            } 
        });
        return images;
    }

})();