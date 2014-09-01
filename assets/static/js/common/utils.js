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
            alert(message);
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
        }
    };

})();