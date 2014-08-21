(function() {
    var t = klp.tabs = {};
    var templates = {};
    var dataCache = {};
    var schoolInfoURL;
    var tabs;

    t.init = function() {
        schoolInfoURL = 'schools/school/' + SCHOOL_ID;
   
        tabs = {
            'info': {
                getData: function() {
                    return klp.api.do(schoolInfoURL);
                },
                onRender: function() {
                    console.log("post render info");
                }
            },
            'demographics': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/demographics');
                },
                onRender: function() {

                }
            },
            'programmes': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/programmes');
                }
            },
            'finances': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/finance');
                }
            },
            'infrastructure': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/infrastructure');
                }
            },
            'library': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/library');
                }
            },
            'nutrition': {
                getData: function() {
                    return klp.api.do(schoolInfoURL + '/infrastructure');
                }
            },
            'share-story': {
                getData: function() {
                    //FIXME: replace with real SYS end-point
                    return klp.api.do(schoolInfoURL);
                }
            }

        };


        //compile templates for tabs
        _(_(tabs).keys()).each(function(tabName) {
            console.log("tab name", tabName);
            var templateString = $('#tpl-tab-' + tabName).html();
            templates[tabName] = swig.compile(templateString);
        });

        $(document).on("click", ".js-tab-link", function(e){
            var $wrapper = $(".js-tabs-wrapper");
            var $trigger = $(this).closest(".js-tab-link");
            var tab_id = $trigger.attr('data-tab');

            // Change current tab link
            $trigger.parent().find("li.current").removeClass('current');
            $trigger.addClass("current");

            //show tab
            t.showTab(tab_id);

        });

        //FIXME: get tab name from url, default to info
        t.showTab('info');
        console.log(templates);

    };

    t.showTab = function(tabName) {
        $('.tab-content.current').removeClass('current');
        //FIXME: do some loading for before data arrives
        getData(tabName, function(data) {
            var html = templates[tabName](data);
            $('div[data-tab=' + tabName + ']').html(html).addClass('current');
            doPostRender(tabName, data);
        });
    };

    function getData(tabName, callback) {
        if (dataCache.hasOwnProperty(tabName)) {
            callback(dataCache[tabName]);
            return;
        }
        var $xhr = tabs[tabName].getData();
        $xhr.done(function(data) {
            dataCache[tabName] = data;
            callback(data);
        });
    }

    function doPostRender(tabName, data) {
        if (tabs[tabName].hasOwnProperty('onRender')) {
            tabs[tabName].onRender(data);
        }
    }

})();