(function($) {
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
                                    .parent()
                                    .find('.js-image-preview')
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
})(jQuery);