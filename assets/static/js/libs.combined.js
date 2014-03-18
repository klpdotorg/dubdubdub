
/*   jquery.slimscroll.min.js   */
/*! Copyright (c) 2011 Piotr Rochala (http://rocha.la)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Version: 1.3.1
 *
 */
(function(f){jQuery.fn.extend({slimScroll:function(h){var a=f.extend({width:"auto",height:"250px",size:"7px",color:"#000",position:"right",distance:"1px",start:"top",opacity:0.4,alwaysVisible:!1,disableFadeOut:!1,railVisible:!1,railColor:"#333",railOpacity:0.2,railDraggable:!0,railClass:"slimScrollRail",barClass:"slimScrollBar",wrapperClass:"slimScrollDiv",allowPageScroll:!1,wheelStep:20,touchScrollStep:200,borderRadius:"7px",railBorderRadius:"7px"},h);this.each(function(){function r(d){if(s){d=d||
window.event;var c=0;d.wheelDelta&&(c=-d.wheelDelta/120);d.detail&&(c=d.detail/3);f(d.target||d.srcTarget||d.srcElement).closest("."+a.wrapperClass).is(b.parent())&&m(c,!0);d.preventDefault&&!k&&d.preventDefault();k||(d.returnValue=!1)}}function m(d,f,h){k=!1;var e=d,g=b.outerHeight()-c.outerHeight();f&&(e=parseInt(c.css("top"))+d*parseInt(a.wheelStep)/100*c.outerHeight(),e=Math.min(Math.max(e,0),g),e=0<d?Math.ceil(e):Math.floor(e),c.css({top:e+"px"}));l=parseInt(c.css("top"))/(b.outerHeight()-c.outerHeight());
e=l*(b[0].scrollHeight-b.outerHeight());h&&(e=d,d=e/b[0].scrollHeight*b.outerHeight(),d=Math.min(Math.max(d,0),g),c.css({top:d+"px"}));b.scrollTop(e);b.trigger("slimscrolling",~~e);v();p()}function C(){window.addEventListener?(this.addEventListener("DOMMouseScroll",r,!1),this.addEventListener("mousewheel",r,!1),this.addEventListener("MozMousePixelScroll",r,!1)):document.attachEvent("onmousewheel",r)}function w(){u=Math.max(b.outerHeight()/b[0].scrollHeight*b.outerHeight(),D);c.css({height:u+"px"});
var a=u==b.outerHeight()?"none":"block";c.css({display:a})}function v(){w();clearTimeout(A);l==~~l?(k=a.allowPageScroll,B!=l&&b.trigger("slimscroll",0==~~l?"top":"bottom")):k=!1;B=l;u>=b.outerHeight()?k=!0:(c.stop(!0,!0).fadeIn("fast"),a.railVisible&&g.stop(!0,!0).fadeIn("fast"))}function p(){a.alwaysVisible||(A=setTimeout(function(){a.disableFadeOut&&s||(x||y)||(c.fadeOut("slow"),g.fadeOut("slow"))},1E3))}var s,x,y,A,z,u,l,B,D=30,k=!1,b=f(this);if(b.parent().hasClass(a.wrapperClass)){var n=b.scrollTop(),
c=b.parent().find("."+a.barClass),g=b.parent().find("."+a.railClass);w();if(f.isPlainObject(h)){if("height"in h&&"auto"==h.height){b.parent().css("height","auto");b.css("height","auto");var q=b.parent().parent().height();b.parent().css("height",q);b.css("height",q)}if("scrollTo"in h)n=parseInt(a.scrollTo);else if("scrollBy"in h)n+=parseInt(a.scrollBy);else if("destroy"in h){c.remove();g.remove();b.unwrap();return}m(n,!1,!0)}}else{a.height="auto"==a.height?b.parent().height():a.height;n=f("<div></div>").addClass(a.wrapperClass).css({position:"relative",
overflow:"hidden",width:a.width,height:a.height});b.css({overflow:"hidden",width:a.width,height:a.height});var g=f("<div></div>").addClass(a.railClass).css({width:a.size,height:"100%",position:"absolute",top:0,display:a.alwaysVisible&&a.railVisible?"block":"none","border-radius":a.railBorderRadius,background:a.railColor,opacity:a.railOpacity,zIndex:90}),c=f("<div></div>").addClass(a.barClass).css({background:a.color,width:a.size,position:"absolute",top:0,opacity:a.opacity,display:a.alwaysVisible?
"block":"none","border-radius":a.borderRadius,BorderRadius:a.borderRadius,MozBorderRadius:a.borderRadius,WebkitBorderRadius:a.borderRadius,zIndex:99}),q="right"==a.position?{right:a.distance}:{left:a.distance};g.css(q);c.css(q);b.wrap(n);b.parent().append(c);b.parent().append(g);a.railDraggable&&c.bind("mousedown",function(a){var b=f(document);y=!0;t=parseFloat(c.css("top"));pageY=a.pageY;b.bind("mousemove.slimscroll",function(a){currTop=t+a.pageY-pageY;c.css("top",currTop);m(0,c.position().top,!1)});
b.bind("mouseup.slimscroll",function(a){y=!1;p();b.unbind(".slimscroll")});return!1}).bind("selectstart.slimscroll",function(a){a.stopPropagation();a.preventDefault();return!1});g.hover(function(){v()},function(){p()});c.hover(function(){x=!0},function(){x=!1});b.hover(function(){s=!0;v();p()},function(){s=!1;p()});b.bind("touchstart",function(a,b){a.originalEvent.touches.length&&(z=a.originalEvent.touches[0].pageY)});b.bind("touchmove",function(b){k||b.originalEvent.preventDefault();b.originalEvent.touches.length&&
(m((z-b.originalEvent.touches[0].pageY)/a.touchScrollStep,!0),z=b.originalEvent.touches[0].pageY)});w();"bottom"===a.start?(c.css({top:b.outerHeight()-c.outerHeight()}),m(0,!0)):"top"!==a.start&&(m(f(a.start).position().top,null,!0),a.alwaysVisible||c.hide());C()}});return this}});jQuery.fn.extend({slimscroll:jQuery.fn.slimScroll})})(jQuery);

/**
 * jquery.stickOnScroll.js
 * A jQuery plugin for making element fixed on the page.
 *
 * Created by Paul Tavares on 2012-10-19.
 * Copyright 2012 Paul Tavares. All rights reserved.
 * Licensed under the terms of the MIT License
 *
 */
;
(function($) {

    "use strict";
    /*jslint plusplus: true */
    /*global $,jQuery */

    var
    // Check if we're working in IE. Will control the animation
    // on the fixed elements.
    isIE = ($.support.optSelected === false ? true : false),

        // List of viewports and associated array of bound sticky elements
        viewports = {},

        // Local variable to hold methods
        fn = {};

    /**
     * Function bound to viewport's scroll event. Loops through
     * the list of elements that needs to be sticked for the
     * given viewport.
     * "this" keyword is assumed to be the viewport.
     *
     * @param {eventObject} jQuery's event object.
     *
     * @return {Object} The viewport (this keyword)
     *
     */

    function processElements(ev) {

        var elements = viewports[$(this).prop("stickOnScroll")],
            i, j;

        // Loop through all elements bound to this viewport.
        for (i = 0, j = elements.length; i < j; i++) {

            // Scope in the variables
            // We call this anonymous funnction with the
            // current array element ( elements[i] )
            (function(o) {

                var scrollTop,
                    maxTop,
                    cssPosition,
                    footerTop,
                    eleHeight,
                    yAxis;

                // get this viewport options
                o = elements[i];

                // FIXME: Should the clean up of reference to removed element store the position in the array and delete it later?

                // If element has no parent, then it must have been removed from DOM...
                // Remove reference to it
                if (o !== null) {
                    if (o.ele[0].parentNode === null) {
                        elements[i] = o = null;
                    }
                }
                if (o !== null) {

                    // Get the scroll top position on the view port
                    scrollTop = o.viewport.scrollTop();

                    // set the maxTop before we stick the element
                    // to be it's "normal" topPosition minus offset
                    maxTop = o.getEleMaxTop();

                    // TODO: What about calculating top values with margin's set?
                    // pt.params.footer.css('marginTop').replace(/auto/, 0)

                    // If not using the window object, then stop any IE animation
                    if (o.isWindow === false && isIE) {
                        o.ele.stop();
                    }

                    // If the current scrollTop position is greater
                    // than our maxTop value, then make element stick on the page.
                    if (scrollTop > maxTop) {

                        cssPosition = {
                            position: "fixed",
                            top: (o.topOffset - o.eleTopMargin)
                        };

                        if (o.isWindow === false) {

                            cssPosition = {
                                position: "absolute",
                                top: ((scrollTop + o.topOffset) - o.eleTopMargin)
                            };

                        }

                        o.isStick = true;

                        // ---> HAS FOOTER ELEMENT?
                        // check to see if it we're reaching the footer element,
                        // and if so, scroll the item up with the page
                        if (o.footerElement.length) {

                            // Calculate the distance from the *bottom* of the fixed
                            // element to the footer element, taking into consideration
                            // the bottomOffset that may have been set by the user. 
                            footerTop = o.footerElement.position().top;
                            eleHeight = o.ele.outerHeight();
                            yAxis = (cssPosition.top + eleHeight +
                                o.bottomOffset + o.topOffset);

                            if (o.isWindow === false) {

                                yAxis = (eleHeight + o.bottomOffset + o.topOffset);

                            } else {

                                yAxis = (cssPosition.top + scrollTop +
                                    eleHeight + o.bottomOffset);
                                footerTop = o.footerElement.offset().top;

                            }

                            if (yAxis > footerTop) {

                                if (o.isWindow === true) {

                                    cssPosition.top = (
                                        footerTop - (scrollTop + eleHeight + o.bottomOffset)
                                    );

                                    // Absolute positioned element
                                } else {

                                    cssPosition.top = (scrollTop - (yAxis - footerTop));

                                }

                            }

                        }

                        // If o.setParentOnStick is true, then set the
                        // height to this node's parent.
                        if (o.setParentOnStick === true) {

                            o.eleParent.css("height", o.eleParent.height());

                        }

                        // If o.setWidthOnStick is true, then set the width on the
                        // element that is about to be Sticky.
                        if (o.setWidthOnStick === true) {

                            o.ele.css("width", o.ele.css("width"));

                        }

                        // Stick the element
                        if (isIE && o.isWindow === false) {

                            o.ele
                                .addClass(o.stickClass)
                                .css("position", cssPosition.position)
                                .animate({
                                    top: cssPosition.top
                                }, 150);

                        } else {

                            o.ele
                                .css(cssPosition)
                                .addClass(o.stickClass);

                        }

                        // If making element stick now, then trigger
                        // onStick callback if any
                        if (o.wasStickCalled === false) {

                            o.wasStickCalled = true;

                            setTimeout(function() {

                                if (o.isOnStickSet === true) {

                                    o.onStick.call(o.ele, o.ele);

                                }

                                o.ele.trigger("stickOnScroll:onStick", [o.ele]);

                            }, 20);

                        }

                        // ELSE, If the scrollTop of the view port is
                        // less than the maxTop, then throw the element back into the 
                        // page normal flow                    
                    } else if (scrollTop <= maxTop) {

                        if (o.isStick) {

                            // reset element
                            o.ele
                                .css({
                                    position: "",
                                    top: ""
                                })
                                .removeClass(o.stickClass);

                            o.isStick = false;

                            // Reset parent if o.setParentOnStick is true
                            if (o.setParentOnStick === true) {

                                o.eleParent.css("height", "");

                            }

                            // Reset the element's width if o.setWidthOnStick is true
                            if (o.setWidthOnStick === true) {

                                o.ele.css("width", "");

                            }

                            o.wasStickCalled = false;

                            setTimeout(function() {

                                // Execute the onUnStick if defined
                                if (o.isOnUnStickSet) {

                                    o.onUnStick.call(o.ele, o.ele);

                                }

                                o.ele.trigger("stickOnScroll:onUnStick", [o.ele]);

                            }, 20);

                        }
                    }

                    // Recalculate the original top position of the element...
                    // this could have changed from when element was initialized
                    // - ex. elements were inserted into DOM. We re-calculate only
                    // if the we're at the very top of the viewport, so that we can
                    // get a good position.
                    if (scrollTop === 0) {

                        o.setEleTop();

                    }

                } // is element setup null?

            })(elements[i]);

        } //end: for()

        return this;

    } //end: processElements()


    /**
     * Make the selected items stick to the top of the viewport
     * upon reaching a scrolling offset.
     * This method manipulates the following css properties on
     * the element that is to be sticky: top, position.
     * Elements also receive a css class named 'hasStickOnScroll'.
     *
     * @param {Object} options
     * @param {Integer} [options.topOffset=0]
     * @param {Integer} [options.bottomOffset=5]
     * @param {Object|HTMLElement|jQuery} [options.footerElement=null]
     * @param {Object|HTMLElement|jQuery} [options.viewport=window]
     * @param {String} [options.stickClass="stickOnScroll-on"]
     * @param {Boolean} [options.setParentOnStick=false]
     * @param {Boolean} [options.setWidthOnStick=false]
     * @param {Function} [options.onStick=null]
     * @param {Function} [options.onUnStick=null]
     *
     * @return {jQuery} this
     *
     */
    $.fn.stickOnScroll = function(options) {
        return this.each(function() {

            // If element already has stickonscroll, exit.
            if ($(this).hasClass("hasStickOnScroll")) {
                return this;
            }

            // Setup options for tis instance
            var o = $.extend({}, {
                topOffset: 0,
                bottomOffset: 5,
                footerElement: null,
                viewport: window,
                stickClass: 'stickOnScroll-on',
                setParentOnStick: false,
                setWidthOnStick: false,
                onStick: null,
                onUnStick: null
            }, options),
                viewportKey,
                setIntID,
                setIntTries = 1800; // 1800 tries * 100 milliseconds = 3 minutes

            o.isStick = false;
            o.ele = $(this).addClass("hasStickOnScroll");
            o.eleParent = o.ele.parent();
            o.viewport = $(o.viewport);
            o.eleTop = 0;
            o.eleTopMargin = parseFloat(o.ele.css("margin-top"));
            o.footerElement = $(o.footerElement);
            o.isWindow = true;
            o.isOnStickSet = $.isFunction(o.onStick);
            o.isOnUnStickSet = $.isFunction(o.onUnStick);
            o.wasStickCalled = false;

            /**
             * Retrieves the element's top position based on the
             * type of viewport.
             *
             * @return {Integer}
             */
            o.setEleTop = function() {

                if (o.isStick === false) {

                    if (o.isWindow) {

                        o.eleTop = o.ele.offset().top;

                    } else {

                        o.eleTop = o.ele.position().top;

                    }

                }

            }; //end: o.getEleTop()

            /**
             * Get's the MAX top position for the element before it
             * is made sticky. In some cases the max could be less
             * than the original position of the element, which means
             * the element would always be sticky... in these instances
             * the max top will be set to the element's top position.
             *
             * @return {Integer}
             */
            o.getEleMaxTop = function() {

                var max = ((o.eleTop - o.topOffset));

                if (!o.isWindow) {

                    max = (max + o.eleTopMargin);

                }

                // if (max < o.eleTop) {
                //                     
                // max = o.eleTop;
                //                     
                // }

                return max;

            }; //end: o.getEleMaxTop()

            // If setParentOnStick is true, and the parent element
            // is the <body>, then set setParentOnStick to false.
            if (o.setParentOnStick === true && o.eleParent.is("body")) {

                o.setParentOnStick = false;

            }


            if (!$.isWindow(o.viewport[0])) {

                o.isWindow = false;

            }

            function addThisEleToViewportList() {

                o.setEleTop();

                viewportKey = o.viewport.prop("stickOnScroll");

                // If this viewport is not yet defined, set it up now 
                if (!viewportKey) {

                    viewportKey = "stickOnScroll" + String(Math.random()).replace(/\D/g, "");
                    o.viewport.prop("stickOnScroll", viewportKey);
                    viewports[viewportKey] = [];
                    o.viewport.on("scroll", processElements);

                }

                // Push this element's data to this view port's array
                viewports[viewportKey].push(o);

                // Trigger a scroll even
                o.viewport.scroll();

            }

            // If Element is not visible, then we have to wait until it is
            // in order to set it up. We need to obtain the top position of
            // the element in order to make the right decision when it comes
            // to making the element sticky.
            if (o.ele.is(":visible")) {

                addThisEleToViewportList();

            } else {

                setIntID = setInterval(function() {

                        if (o.ele.is(":visible") || !setIntTries) {

                            clearInterval(setIntID);
                            addThisEleToViewportList();

                        }

                        --setIntTries;

                    },
                    100);

            }

            return this;

        }); //end: each()

    }; //end: $.fn.stickOnScroll()

})(jQuery);

/*   energize.min.js   */
/* Energize */
(function(){if("ontouchstart"in window&&!/chrome/i.test(navigator.userAgent)){var g,h,i,e=function(a,c){return 5<Math.abs(a[0]-c[0])||5<Math.abs(a[1]-c[1])},m=function(a,c){for(var b=a,f=c.toUpperCase();b!==document.body;){if(!b||b.nodeName===f)return b;b=b.parentNode}return null};document.addEventListener("touchstart",function(a){this.startXY=[a.touches[0].clientX,a.touches[0].clientY];this.treshold=!1},!1);document.addEventListener("touchmove",function(a){if(this.treshold)return!1;this.threshold=
e(this.startXY,[a.touches[0].clientX,a.touches[0].clientY])},!1);document.addEventListener("touchend",function(a){if(!this.treshold&&!e(this.startXY,[a.changedTouches[0].clientX,a.changedTouches[0].clientY])){var c=a.changedTouches[0],b=document.createEvent("MouseEvents");b.initMouseEvent("click",!0,!0,window,0,c.screenX,c.screenY,c.clientX,c.clientY,!1,!1,!1,!1,0,null);b.simulated=!0;a.target.dispatchEvent(b)}},!1);document.addEventListener("click",function(a){var c=Date.now(),b=c-g,f=a.clientX,
e=a.clientY,j=[Math.abs(h-f),Math.abs(i-e)],d=m(a.target,"A")||a.target,k="A"===d.nodeName,l=window.navigator.standalone&&k&&a.target.getAttribute("href");g=c;h=f;i=e;if(!a.simulated&&(500>b||1500>b&&50>j[0]&&50>j[1])||l)if(a.preventDefault(),a.stopPropagation(),!l)return!1;window.navigator.standalone&&k&&d.getAttribute("href")&&(window.location=d.getAttribute("href"));d&&d.classList&&(d.classList.add("m-focus"),window.setTimeout(function(){d.classList.remove("m-focus")},150))},!0)}})();


/*  main.js   */
$(document).ready(function(){

    // Adds easing scrolling to # targets
    $('a[href*=#]:not([href=#])').click(function() {
        if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') 
            || location.hostname == this.hostname) {

          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
          if (target.length) {
            $('html,body').animate({
              scrollTop: target.offset().top-100
            }, 300);
            return false;
          }
        }
    });

    // Re-display top navigation if it gets hidden.
    $(window).resize(function() {
        if($(window).width() >=980){
            $("#navigation").show();
        } else {
            $("#navigation").hide();
        }
    });

    // Top navigation show dropdown on hover
    $(".top-nav ul li" ).hover(
      function() {
        $( this ).find('ul').show();
      }, function() {
        $( this ).find('ul').hide();
      }
    );

    $("#page_sticky_nav").stickOnScroll({
        topOffset: 0,
        setParentOnStick:   true,
        setWidthOnStick:    true
    });

});

function toggle_mobile_nav(){
    $("#navigation").slideToggle();
}
