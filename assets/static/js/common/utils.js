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
        }
    }

})();