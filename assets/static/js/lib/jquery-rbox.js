(function($) {
    
    function createInitialElements() {
        var $overlay = $('<div />').addClass('rbox_overlay');
        var $lightboxBlock = $('<div />').addClass('rbox_lightBoxBlock').appendTo($overlay);
        var $lightbox = $('<div />').addClass('rbox_lightBox').appendTo($lightboxBlock);
        var $content = $('<div />').addClass('rbox_lightBoxContent').appendTo($lightbox);
        var $close = $('<span />').attr('href', '').addClass('closeLightBox fa fa-times-circle').appendTo($lightbox);
        var $next = $('<a />').attr('href', '').addClass('nextLightBox fa fa-chevron-circle-right').appendTo($lightbox);
        var $prev = $('<a />').attr('href', '').addClass('prevLightBox fa fa-chevron-circle-left').appendTo($lightbox);
        $('body').append($overlay);
    }

    $.fn.rbox = function(options) {
        if ($('.rbox_overlay').length === 0) {
            createInitialElements();
        }
        options = options || {};
        var that = this;
        $('.rbox_lightBoxBlock').click(function(e) {
            e.stopPropagation();
        });

        //if series is passed in js options, we need to create the data attr
        if (options.series) {
            this.attr('data-rbox-series', options.series);
        }
        
        $('.closeLightBox').click(function(e) {
            e.preventDefault();
            e.stopPropagation();
            $('.rbox_overlay').unbind("click");
            var opts = $('.rbox_lightBox').data("rboxOpts");
            $('.rbox_overlay').removeClass('rbox_show');
            $('.rbox_lightBoxContent').removeClass('rbox_show_content');
            //$('.rbox_overlay').fadeOut(opts.fade, function() {
                //alert("im your friend");
            opts.beforeclose(opts);
            $('.rbox_lightBoxBlock').removeClass('rbox_' + opts.type);
            $('.rbox_lightBoxContent').html(opts.loading);
            if (opts.scrollTop) {
                $(window).scrollTop(opts.scrollTop);
            }
            opts.onclose(opts);
            //});
            //$('.lightBoxContent').data("rboxOpts", false);
        });

        $('.nextLightBox').click(function(e) {
            e.preventDefault();
            e.stopPropagation();
            var opts = $('.rbox_lightBox').data("rboxOpts");
            $('.rbox_lightBoxBlock').removeClass('rbox_' + opts.type);
            var $thisSeries = that.filter(opts.seriesSelector);
            var index = $thisSeries.index(opts.$anchor);
            $thisSeries.eq(index + 1).click();
        });

        $('.prevLightBox').click(function(e) {
            e.preventDefault();
            e.stopPropagation();
            var opts = $('.rbox_lightBox').data("rboxOpts");
            $('.rbox_lightBoxBlock').removeClass('rbox_' + opts.type);
            var $thisSeries = that.filter(opts.seriesSelector);
            var index = $thisSeries.index(opts.$anchor);
            $thisSeries.eq(index - 1).click();
        });        

        
        //get options, giving preference, in order, to data- attributes defined on the html element, options passed when instantiatiing $(element).lightbox(options), defaults.

     
        return this.each(function() {
            //console.log("options", options);
                namespace = options.namespace || "rbox",
                
                optionTypes = {
                    'strings': ['series', 'type', 'image', 'iframe', 'html', 'ajax', 'video', 'videoposter', 'caption', 'loading', 'inline'],
                    'integers': ['width', 'height', 'fade'],
                    'floats': [],
                    'arrays':  [],
                    'objects': [],
                    'booleans': ['fitvid', 'autoplay']
                    //'functions': ['callback'] FIXME: lets not.
                };

            //alert("hi");                
            var $this = $(this),
                dataOptions = $.extend(options, $this.getDataOptions(optionTypes, namespace));
            //console.log("dataOptions", dataOptions);
            var opts = $.extend({
                    'series': '', //string, series this lightbox is a part of
                    'type': 'image', //type of content - image, iframe, html or ajax
                    'image': '', //path to image, for type image
                    'iframe': '', //iframe URL
                    'html': '', //arbitrary html
                    'video': '', //Path to video file
                    'inline': '', //selector for element on page whose innerHTML is the content
                    'ajax': '', //URL to fetch ajax content from
                    'caption': '', //optional caption
                    'fade': 300, //fade delay
                    'width': 0,
                    'height': 0,
                    'videoposter': '', //poster image path for video
                    'autoplay': false, //if type==video, if video should autoplay
                    'fitvid': false, //whether to use fitvid plugin (must be included)
                    'namespace': namespace,
                    'loading': 'Loading...',
                    'beforeopen': function(opts) { return opts; }, //called before open
                    'onopen': function() { $.noop(); }, //called onopen
                    'onclose': function() { $.noop(); }, //called onclose
                    'beforeclose': function() { $.noop(); }
                }, dataOptions);


            if (opts.series) {
                opts.seriesSelector = '[data-' + opts.namespace + '-' + 'series=' + opts.series + ']';
            }

            $this.click(function(e) {
                e.preventDefault(); 
                //alert("hello");        
//                console.log(dataOptions);
                if (opts.series) {
                    var $thisSeries = that.filter(opts.seriesSelector);
                    var total = $thisSeries.length;
                    var thisIndex = $thisSeries.index($this) + 1;
                    //console.log($thisSeries, total, thisIndex);
                    if (thisIndex >= total) {
                        $('.nextLightBox').hide();
                    } else {
                        $('.nextLightBox').show();
                    }
                    if (thisIndex == 1) {
                        $('.prevLightBox').hide();
                    } else {
                        $('.prevLightBox').show();
                    }
                } else {
                    $('.nextLightBox, .prevLightBox').hide();
                }
                opts.scrollTop = $(window).scrollTop();
                $(window).scrollTop(0);
                opts.$anchor = $this;
                opts = opts.beforeopen(opts);
                getLightBoxContent(opts, showLightbox);
            });

        });

    };

    function getLightBoxContent(opts, callback) {
        switch (opts.type) {
            case "image":
                var src = opts.image;
                var $content = $("<img />").attr("src", src);
                if (opts.width) {
                    $content.attr("width", opts.width);
                }
                if (opts.height) {
                    $content.attr("height", opts.height);
                }
                callback($content, opts);
                break;
            case "iframe":
                var $content = $('<iframe />').attr("src", opts.iframe);
                if (opts.width) {
                    $content.attr("width", opts.width);
                }
                if (opts.height) {
                    $content.attr("height", opts.height);
                }
                callback($content, opts);
                break;
            case "ajax":
                $('.rbox_lightBoxContent').html(opts.loading);
                $.get(opts.ajax, function(data) {
                    $content = $('<div />').html(data);
                    callback($content, opts);
                });
                break;
            case "html":
                var $content = $('<div />').html(opts.html);
                callback($content, opts);
                break;

            case "inline":
                var $content = $(opts.inline).html();
                callback($content, opts);
                break;

            case "video":
                var $content = $('<video />')
                            .attr("controls", "controls")
                            .addClass("rbox_videoElement")
                            .attr("src", opts.video);
                if (opts.autoplay) {
                    $content.attr("autoplay", "autoplay");
                }
                if (opts.videoposter) {
                    $content.attr("poster", opts.videoposter);
                }
                if (opts.width) {
                    $content.attr("width", opts.width);
                }
                if (opts.height) {
                    $content.attr("height", opts.height);
                }
                opts.beforeclose = function() {
                    var $video = $('.rbox_videoElement');
                    console.log($video);
                    $video.get(0).pause();
                    $video.remove();
                };
                callback($content, opts);
                break;
        }
    }

    function showLightbox(content, opts) {

        //var $content = $(content);
        $('.rbox_lightBox').data("rboxOpts", opts);
        $('.rbox_lightBoxBlock').addClass('rbox_' + opts.type);
        $('.rbox_overlay').addClass('rbox_show');
        //$('.rbox_overlay').show(opts.fade, function(){
        $('.rbox_overlay').bind("click", function() {
            $('.closeLightBox').click();
        });

        $('.rbox_lightBoxContent').empty().append(content).addClass('rbox_show_content');
        if (opts.caption) {
            var $caption = $('<div />').addClass('rbox_caption').html(opts.caption);
            $('.rbox_lightBoxContent').append($caption);
        }
        if (opts.fitvid) {
            $('.rbox_lightBoxContent').find('iframe').wrap('<div class="rbox_fitvid" />');
            $('.rbox_fitvid').fitVids();    
        }
        opts.onopen(opts);
        $(window).resize(function() {
            if ($(window).height() < $('.rbox_lightBox').height())
            {            
                $('.rbox_overlay').css({'position':'absolute'});
                $('.rbox_overlay').height($(document).height());
            } else {
                $('.rbox_overlay').css({'position':'', 'height':''});
            }            
        });
        $(window).resize();
        //});            
    }


    /*
    Get options from data- attributes
        Parameters:                            
            optionTypes: <object>
                example: {
                    'strings': ['option1', 'option2', 'option3'],
                    'integers': ['fooint', 'barint'],
                    'arrays': ['list1', 'list2'],
                    'booleans': ['bool1']
                }

            namespace: <string>
                example: 'pandora'
                    namespace for data- attributes
                
            example html:
                <div id="blah" data-pandora-option1="foobar" data-pandora-fooint="23" data-pandora-list2="apples, oranges" data-pandora-bool1="true">

            usage:
                var dataOptions = $('#blah').getDataOptions(optionTypes, namespace);
    */
    $.fn.getDataOptions = function(optionTypes, namespace) {
        var $element = this;
        var prefix = "data-" + namespace + "-",
            options = {};        
        $.each(optionTypes['strings'], function(i,v) {
            var attr = prefix + v;
            options[v] = $element.hasAttr(attr) ? $element.attr(attr) : undefined;
        });
        $.each(optionTypes['integers'], function(i,v) {
            var attr = prefix + v;
            options[v] = $element.hasAttr(attr) ? parseInt($element.attr(attr)) : undefined;
        });
        $.each(optionTypes['floats'], function(i,v) {
            var attr = prefix + v;
            options[v] = $element.hasAttr(attr) ? parseFloat($element.attr(attr)) : undefined;
        });
        $.each(optionTypes['arrays'], function(i,v) {
            var attr = prefix + v;
            options[v] = $element.hasAttr(attr) ? $.map($element.attr(attr).split(","), $.trim) : undefined;
        }); 
        $.each(optionTypes['booleans'], function(i,v) {
            var attr = prefix + v;
            options[v] = $element.hasAttr(attr) ? $element.attr(attr) == 'true' : false;
        });  
        $.each(optionTypes['objects'], function(i,v) {
            var attr = prefix + v;
            options[v] = $element.hasAttr(attr) ? JSON.parse($element.attr(attr)) : undefined;
        });       
        return options;
    }

    /*
    FIXME: possibly improve - http://stackoverflow.com/questions/1318076/jquery-hasattr-checking-to-see-if-there-is-an-attribute-on-an-element#1318091
    */
    $.fn.hasAttr = function(attr) {
        return this.attr(attr) != undefined;
    };


})(jQuery);